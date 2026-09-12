require('dotenv').config();

const app = require('./app');

const orderService = require('./services/order.service');

const PORT = process.env.PORT || 3000;


// Auto expire pending orders 

setInterval(async () => {

    try {

        const expiredOrders =
            await orderService.expirePendingOrders();

        if (expiredOrders.length > 0) {

            console.log(
                `Expired ${expiredOrders.length} orders`
            );
        }

    } catch (error) {

        console.error(
            'Error running expirePendingOrders:',
            error
        );
    }

}, 60 * 1000);

app.listen(PORT, () => {
    console.log(`🚀 CloudTicket API is running on port ${PORT}`);
});