const { sendMessage } = require("./sqs");

async function publishOrderCreated(order) {
  const message = {
    event_type: "ORDER_CREATED",
    order_id: order.id,
    event_id: order.event_id,
    customer_name: order.customer_name,
    quantity: order.quantity,
  };

  const result = await sendMessage(message);

  console.log("[ORDER_CREATED] SQS message sent:", {
    message_id: result.MessageId,
    order_id: order.id,
  });
}

async function publishPaymentSuccessful(order) {
  const message = {
    event_type: "PAYMENT_SUCCESSFUL",
    order_id: order.id,
    event_id: order.event_id,
    customer_name: order.customer_name,
    quantity: order.quantity,
  };

  const result = await sendMessage(message);

  console.log("[PAYMENT_SUCCESSFUL] SQS message sent:", {
    message_id: result.MessageId,
    order_id: order.id,
  });
}

async function publishOrderCancelled(order) {
  const message = {
    event_type: "ORDER_CANCELLED",
    order_id: order.id,
    event_id: order.event_id,
    customer_name: order.customer_name,
    quantity: order.quantity,
  };

  const result = await sendMessage(message);

  console.log("[ORDER_CANCELLED] SQS message sent:", {
    message_id: result.MessageId,
    order_id: order.id,
  });
}

module.exports = {
  publishOrderCreated,
  publishPaymentSuccessful,
  publishOrderCancelled,
};