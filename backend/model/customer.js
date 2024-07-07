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
  availability: {
    type: String,
  },
  
});

module.exports = mongoose.model("customer", schema);
