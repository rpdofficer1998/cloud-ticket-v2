
require("./config/db");

const express = require('express');
const cors = require('cors');

const app = express();

const healthRoutes = require('./routes/health.routes');

const eventRoutes = require('./routes/event.routes');

const orderRoutes = require('./routes/order.routes');


app.use(cors());
app.use(express.json());
app.use('/api/events', eventRoutes);
app.use('/api/orders', orderRoutes);


app.get('/', (req, res) => {
    res.json({
        message: 'Welcome to CloudTicket API!'
    });
});


app.use('/health', healthRoutes);


module.exports = app;