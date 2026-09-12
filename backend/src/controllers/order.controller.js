const orderService = require('../services/order.service');

// Create a new order
const createOrder = async (req, res) => {

    try {

        const {
            event_id,
            customer_name,
            quantity
        } = req.body;

        const order = await orderService.createOrder({
            event_id,
            customer_name,
            quantity
        });

        res.status(201).json(order);

    } catch (error) {

    console.error(error);

    res.status(400).json({
        message: error.message
    });

}
};

// Mark an order as paid
const payOrder = async (req, res) => {

    try {

        const order = await orderService.payOrder(req.params.id);

        res.json(order);

    } catch (error) {

        console.error(error);

        res.status(400).json({
            message: error.message
        });

    }
};

// Cancel a pending order
const cancelOrder = async (req, res) => {

    try {

        const order = await orderService.cancelOrder(req.params.id);

        res.json(order);

    } catch (error) {

        console.error(error);

        res.status(400).json({
            message: error.message
        });

    }
};

// Get all orders, optionally filtered by event_id
const getOrders = async (req, res) => {
    try {
        const { event_id, status } = req.query;
        const orders = await orderService.getOrders({
            event_id, 
            status
        });
        res.json(orders);
    } catch (error) {
        console.error(error);
        res.status(400).json({
            message: error.message
        });
    }
};

// Expire pending orders that have passed their expiration time
const expirePendingOrders = async (req, res) => {

    try {

        const expiredOrders =
            await orderService.expirePendingOrders();

        res.json({
            message: "Expired orders processed",
            expiredCount: expiredOrders.length,
            orders: expiredOrders
        });

    } catch (error) {

        console.error("Error expiring orders:", error);

        res.status(500).json({
            message: error.message
        });
    }
};

module.exports = {
    createOrder,
    payOrder,
    cancelOrder,
    getOrders,
    expirePendingOrders
};