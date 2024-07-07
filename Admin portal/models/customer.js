const mongoose = require("mongoose");

const schema = mongoose.Schema({
  username: {
    type: String,
  },
  email_address: {
    type: String,
  },
  contact_number: {
    type: String,
  },
  cnic: {
    type: String,
  },
  password: {
    type: String,
  },
  agreement: {
    type: String,
  },
  picture_public_id: {
    type: String,
  },
  picture_public_url: {
    type: String,
  },
});

module.exports = mongoose.model("customer", schema);
