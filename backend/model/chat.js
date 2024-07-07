const mongoose = require("mongoose");

const schema = mongoose.Schema({
  sender_email: {
    type: String,
    required: true,
  },
  receiver_email: {
    type: String,
    default: "",
  },
  content: {
    type: String,
    required: true,
  },
  date: {
    type: String,
    default: new Date().toLocaleDateString(),
  },
});

module.exports = mongoose.model("chat", schema);
