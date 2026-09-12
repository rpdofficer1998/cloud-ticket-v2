const pool = require('../config/db');

const createOrder = async ({
    event_id,
    customer_name,
    quantity
}) => {

    const client = await pool.connect();
    try{
        // Start a transaction
        await client.query('BEGIN');

        // 1. Lock the event row to prevent race conditions
        const eventResult = await client.query(
            `SELECT * FROM events WHERE id = $1 FOR UPDATE`,
            [event_id]
        );

        const event = eventResult.rows[0];

        if (!event) {
        throw new Error("Event not found");
    }

    // 2. Check ticket availability
    if (event.available_tickets < quantity) {
        throw new Error("Not enough tickets available");
    }

    // 3. Reduce available tickets
    await client.query(
        `
        UPDATE events
        SET available_tickets = available_tickets - $1
        WHERE id = $2
        `,
        [quantity, event_id]
    );

    // 4. Create a PENDING order with expiration time
    const orderResult = await client.query(
        `
        INSERT INTO orders (event_id, customer_name, quantity, status, expires_at)
        VALUES ($1, $2, $3, 'PENDING', NOW() + INTERVAL '3 minutes')
        RETURNING *
        `,
        [event_id, customer_name, quantity]
    );

    // 5. Commit the transaction
    await client.query('COMMIT'); 
    return orderResult.rows[0];
} catch (error) {
    // Rollback the transaction in case of error
    await client.query('ROLLBACK');
    throw error;
} finally {
    client.release();
}
};

// Mark a pending order as paid
const payOrder = async (id) => {

    // Find the order
    const orderResult = await pool.query(
        "SELECT * FROM orders WHERE id = $1",
        [id]
    );

    const order = orderResult.rows[0];

    if (!order) {
        throw new Error("Order not found");
    }

    // Only pending orders can be paid
    if (order.status !== 'PENDING') {
        throw new Error("Order is not pending");
    }

    // Update status to PAID
    const result = await pool.query(
        `
        UPDATE orders
        SET
            status = 'PAID',
            expires_at = NULL
        WHERE id = $1
        RETURNING *
        `,
        [id]
    );

    return result.rows[0];
};

// Cancel a pending order and release tickets
const cancelOrder = async (id) => {

    // 1. Find the order
    const orderResult = await pool.query(
        "SELECT * FROM orders WHERE id = $1",
        [id]
    );

    const order = orderResult.rows[0];

    if (!order) {
        throw new Error("Order not found");
    }

    // 2. Only pending orders can be cancelled
    if (order.status !== 'PENDING') {
        throw new Error("Only pending orders can be cancelled");
    }

    // 3. Release the locked tickets
    await pool.query(
        `
        UPDATE events
        SET available_tickets = available_tickets + $1
        WHERE id = $2
        `,
        [order.quantity, order.event_id]
    );

    // 4. Update order status
    const result = await pool.query(
        `
        UPDATE orders
        SET
            status = 'CANCELLED',
            expires_at = NULL
        WHERE id = $1
        RETURNING *
        `,
        [id]
    );

    return result.rows[0];
};

// Get all orders, optionally filtered by event_id and status
const getOrders = async (filters) => {

    const { event_id, status } = filters;

    const conditions = [];
    const values = [];

    // Filter by event_id
    if (event_id) {

        conditions.push(
            `event_id = $${values.length + 1}`
        );

        values.push(event_id);
    }

    // Filter by status
    if (status) {

        conditions.push(
            `status = $${values.length + 1}`
        );

        values.push(status);
    }

    // Base query
    let query = `
        SELECT *
        FROM orders
    `;

    // Add WHERE clause if filters exist
    if (conditions.length > 0) {

        query += `
            WHERE ${conditions.join(" AND ")}
        `;
    }

    // Sort by newest first
    query += `
        ORDER BY id DESC
    `;

    const result = await pool.query(
        query,
        values
    );

    return result.rows;
};

// Find all expired pending orders
const expirePendingOrders = async () => {

    const client = await pool.connect();

    try {

        await client.query('BEGIN');


        // 1. Find expired pending orders
        const result = await client.query(
            `
            SELECT *
            FROM orders
            WHERE status = 'PENDING'
              AND expires_at < NOW()
            `
        );

        const expiredOrders = result.rows;


        // 2. Release tickets
        for (const order of expiredOrders) {

            await client.query(
                `
                UPDATE events
                SET available_tickets = available_tickets + $1
                WHERE id = $2
                `,
                [order.quantity, order.event_id]
            );
        }


        // 3. Mark orders as CANCELLED
        await client.query(
            `
            UPDATE orders
            SET
                status = 'CANCELLED',
                expires_at = NULL
            WHERE status = 'PENDING'
              AND expires_at < NOW()
            `
        );


        await client.query('COMMIT');


        return expiredOrders;


    } catch (error) {

        await client.query('ROLLBACK');

        throw error;

    } finally {

        client.release();
    }
};


module.exports = {
    createOrder,
    payOrder,
    cancelOrder,
    getOrders,
    expirePendingOrders
};
