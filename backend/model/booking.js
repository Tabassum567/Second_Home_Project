const mongoose = require("mongoose");

const schema = mongoose.Schema({
  room_id: {
    type: String,
    required: true,
  },
  user_email: {
    type: String,
    required: true,
  },
  property_id: {
    type: String,
    required: true,
  },
  start_date: {
    type: String,
    required: true,
  },
  end_date: {
    type: String,
    required: true,
  },
  card_holder_name: {
    type: String,
    required: true,
  },
  card_number: {
    type: String,
    required: true,
  },
  expiration_date: {
    type: String,
    required: true,
  },
  cvv: {
    type: String,
    required: true,
  },
  total_amount: {
    type: Number,
    required: true,
  },
});

module.exports = mongoose.model("booking", schema);
