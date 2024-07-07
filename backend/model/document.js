const mongoose = require("mongoose");

const schema = mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  picture_url: {
    type: String,
  },
  public_id: {
    type: String,
  },
});

module.exports = mongoose.model("document", schema);
