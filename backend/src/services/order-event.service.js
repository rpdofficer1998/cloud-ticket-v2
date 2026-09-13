function publishOrderCreated(order) {
  console.log("[ORDER_CREATED]", {
    order_id: order.id,
    event_id: order.event_id,
    customer_name: order.customer_name,
    quantity: order.quantity,
  });
}

function publishPaymentSuccessful(order) {
  console.log("[PAYMENT_SUCCESSFUL]", {
    order_id: order.id,
    event_id: order.event_id,
    customer_name: order.customer_name,
    quantity: order.quantity,
  });
}

function publishOrderCancelled(order) {
  console.log("[ORDER_CANCELLED]", {
    order_id: order.id,
    event_id: order.event_id,
    customer_name: order.customer_name,
    quantity: order.quantity,
  });
}

module.exports = {
  publishOrderCreated,
  publishPaymentSuccessful,
  publishOrderCancelled,
};