const mongoose = require("mongoose");

const schema = mongoose.Schema({
  complain_owner: {
    type: String,
    required: true,
  },
  complain_title: {
    type: String,
    required: true,
  },
  complain_description: {
    type: String,
    required: true,
  },
  complain_category: {
    type: String,
    required: true,
  },
  complain_status: {
    type: String,
    default: "Unresolved",
  },
});

module.exports = mongoose.model("complain", schema);
