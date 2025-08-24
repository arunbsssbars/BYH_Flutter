import express from "express";
import Razorpay from "razorpay";
import bodyParser from "body-parser";
import crypto from "crypto";

const app = express();
app.use(bodyParser.json());

// 🔴 Replace with your Razorpay credentials
const razorpay = new Razorpay({
  key_id: "rzp_test_1234567890abcdef",
  key_secret: "your_razorpay_secret",
});

// ✅ Create order API
app.post("/create-order", async (req, res) => {
  const { amount, currency = "INR", receipt } = req.body;

  try {
    const options = {
      amount: amount * 100, // in paise
      currency,
      receipt,
    };
    const order = await razorpay.orders.create(options);
    res.json({ orderId: order.id, currency: order.currency, amount: order.amount });
  } catch (err) {
    res.status(500).send(err);
  }
});

// ✅ Verify payment signature API
app.post("/verify-payment", (req, res) => {
  const { orderId, paymentId, signature } = req.body;

  const body = orderId + "|" + paymentId;
  const expectedSignature = crypto
    .createHmac("sha256", razorpay.key_secret)
    .update(body.toString())
    .digest("hex");

  if (expectedSignature === signature) {
    res.json({ success: true, message: "Payment verified" });
  } else {
    res.json({ success: false, message: "Payment verification failed" });
  }
});

app.listen(5000, () => {
  console.log("Server running on http://localhost:5000");
});
