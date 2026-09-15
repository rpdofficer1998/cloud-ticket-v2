require("dotenv").config();

const {
  GetQueueUrlCommand,
  SendMessageCommand,
} = require("@aws-sdk/client-sqs");

const { sqsClient } = require("./services/sqs");

const QUEUE_NAME = "cloudticket-test";

async function main() {
  const queue = await sqsClient.send(
    new GetQueueUrlCommand({
      QueueName: QUEUE_NAME,
    })
  );

  console.log("Queue URL:", queue.QueueUrl);

  const result = await sqsClient.send(
    new SendMessageCommand({
      QueueUrl: queue.QueueUrl,
      MessageBody: JSON.stringify({
        event: "test",
        message: "CloudTicket SQS test",
      }),
    })
  );

  console.log("Message ID:", result.MessageId);
}

main().catch((error) => {
  console.error("SQS test failed:");
  console.error(error);
  process.exit(1);
});