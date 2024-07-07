const mongoose = require("mongoose");

const schema = mongoose.Schema({
  customer_email: {
    type: String,
    required: true,
  },
  property_id: {
    type: String,
    required: true,
  },
  contact_number: {
    type: String,
    required: true,
  },
  date: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    default: "pending",
  },
});

module.exports = mongoose.model("visits", schema);
