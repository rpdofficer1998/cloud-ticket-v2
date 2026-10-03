const {
  SQSClient,
  SendMessageCommand,
} = require("@aws-sdk/client-sqs");

const sqsClient = new SQSClient({
  region: process.env.AWS_DEFAULT_REGION || "ap-southeast-2",

  endpoint:
    process.env.NODE_ENV === "production"
      ? undefined
      : "http://localstack:4566",
});

const queueUrl = process.env.SQS_QUEUE_URL;

async function sendMessage(message) {
  if (!queueUrl) {
    throw new Error("SQS_QUEUE_URL is not configured");
  }

  return sqsClient.send(
    new SendMessageCommand({
      QueueUrl: queueUrl,
      MessageBody: JSON.stringify(message),
    })
  );
}

module.exports = {
  sqsClient,
  sendMessage,
};
