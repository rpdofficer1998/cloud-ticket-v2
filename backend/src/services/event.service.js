const pool = require("../config/db");

// Get all events from the database
const getAllEvents = async () => {
    const result = await pool.query(
    "SELECT * FROM events ORDER BY id"
);

return result.rows;
};

//Get an event by ID from the database
const getEventById = async (id) => {
    const result = await pool.query(
        "SELECT * FROM events WHERE id = $1",
        [id]
    );

    return result.rows[0];
}

// Create a new event in the database
const createEvent = async ({
    title,
    city,
    date,
    available_tickets
}) => {

    const result = await pool.query(
        `
        INSERT INTO events
        (
            title,
            city,
            date,
            available_tickets
        )
        VALUES
        ($1, $2, $3, $4)
        RETURNING *
        `,
        [
            title,
            city,
            date,
            available_tickets
        ]
    );

    return result.rows[0];
};

// Update a current event in the database
const updateEventById = async (id,
    {
    title,
    city,
    date,
    available_tickets
}) => {
    const result = await pool.query(
        `
        UPDATE events
        SET
            title = $1,
            city = $2,
            date = $3,
            available_tickets = $4
        WHERE id = $5
        RETURNING *
        `,
        [
            title,
            city,
            date,
            available_tickets,
            id
        ]
    );

    return result.rows[0];
};

// Delete an event from the database
const deleteEventById = async (id) => {
    const result = await pool.query(
        "DELETE FROM events WHERE id = $1 RETURNING *",
        [id]
    );

    return result.rows[0];
};

module.exports = {
    getAllEvents,
    getEventById,
    createEvent,
    updateEventById,
    deleteEventById
};