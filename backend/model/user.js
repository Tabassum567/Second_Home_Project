const mongoose = require("mongoose");

const schema = new mongoose.Schema({
  email_address: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    default: "Unverified",
  },
});

module.exports = mongoose.model("user", schema);
