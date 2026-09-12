const express = require('express');
const router = express.Router();

const {
    createOrder,
    payOrder,
    cancelOrder,
    getOrders,
    expirePendingOrders
} = require('../controllers/order.controller');

router.post('/', createOrder);

router.post('/:id/pay', payOrder);

router.post('/:id/cancel', cancelOrder);

router.get('/', getOrders);

router.post('/expire', expirePendingOrders);

module.exports = router;