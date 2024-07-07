const mongoose = require("mongoose");

const schema = new mongoose.Schema({
  property_type: {
    type: String,
    required: true,
  },
  property_title: {
    type: String,
    required: true,
  },
  city: {
    type: String,
    required: true,
  },
  rooms: {
    type: String,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  availability_period: {
    type: String,
    required: true,
  },
  monthly_rent: {
    type: String,
    required: true,
  },
  currency: {
    type: String,
    required: true,
  },
  installment_allowed: {
    type: String,
  },
  advance_payment: {
    type: String,
    required: true,
  },
  additional_informtion: {
    type: String,
  },
  facilities: {
    type: String,
    required: true,
  },
  contact_name: {
    type: String,
    required: true,
  },
  contact_number: {
    type: String,
    required: true,
  },
  contact_email: {
    type: String,
    required: true,
  },
});

module.exports = mongoose.model("adminpostadapprovals", schema); 
