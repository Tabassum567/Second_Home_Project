const mongoose = require("mongoose");

const schema = mongoose.Schema({
  property_id: {
    type: String,
    require: true,
  },
  room_type: {
    type: String,
    require: true,
  },
  bed_number: {
    type: Number,
    require: true,
  },
  available: {
    type: Number,
    require: true,
  },
});

module.exports = mongoose.model("rooms", schema);
