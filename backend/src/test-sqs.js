require("dotenv").config();

const { sendMessage } = require("./services/sqs");

async function main() {
  const result = await sendMessage({
    event: "test",
    message: "CloudTicket SQS test",
  });

  console.log("Message ID:", result.MessageId);
}

main().catch((error) => {
  console.error("SQS test failed:");
  console.error(error);
  process.exit(1);
});
