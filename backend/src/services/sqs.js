const {
  SQSClient,
  GetQueueUrlCommand,
  SendMessageCommand,
} = require("@aws-sdk/client-sqs");

const sqsClient = new SQSClient({
  region: process.env.AWS_DEFAULT_REGION || "ap-southeast-2",

  endpoint:
    process.env.NODE_ENV === "production"
      ? undefined
      : "http://localstack:4566",
});

const queueName =
  process.env.SQS_QUEUE_NAME || "cloudticket-order-events";

async function getQueueUrl() {
  const result = await sqsClient.send(
    new GetQueueUrlCommand({
      QueueName: queueName,
    })
  );

  return result.QueueUrl;
}

async function sendMessage(message) {
  const queueUrl = await getQueueUrl();

  return sqsClient.send(
    new SendMessageCommand({
      QueueUrl: queueUrl,
      MessageBody: JSON.stringify(message),
    })
  );
}

module.exports = {
  sqsClient,
  getQueueUrl,
  sendMessage,
};