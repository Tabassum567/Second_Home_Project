const express = require("express");

const router = express.Router();
const User = require("../model/user");
const Chat = require("../model/chat");

router.get("/chatConsultants", (req, res) => {
  try {
    User.find({ role: "Consultant" }, (err, data) => {
      if (!err) {
        res.status(200).send({ message: "Success", consultant: data });
      } else {
        res.status(400).send({ message: "Error" });
      }
    });
  } catch (error) {
    res.status(500).send({ message: "Internal Server Error " + error });
  }
});

router.post("/sendMessage", (req, res) => {
  const { messageData, studentEmail } = req.body;
  console.log(req.body);
  const message = new Chat({
    sender_email: studentEmail,
    content: messageData,
  });
  Chat.create(message, (err) => {
    if (!err) {
      res.status(200).send({ message: "Message Sent" });
    }
  });
});

router.get("/chatMessages", (req, res) => {
  Chat.aggregate(
    [
      {
        $lookup: {
          from: "customers",
          localField: "sender_email",
          foreignField: "email_address",
          as: "data",
        },
      },
      { $unwind: "$data" },
    ],
    (err, data) => {
      if (!err) {
        console.log(data);
        res.status(200).send({ message: "Success", messages: data });
      } else {
        res.status(400).send({ message: "Error Occurred" });
      }
    }
  );
});

module.exports = router;
