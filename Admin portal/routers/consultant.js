const express = require("express");

const router = express.Router();
const User = require("../models/users");

router.get("/consultant", (req, res) => {
  User.find({ role: "Consultant" }, (err, data) => {
    if (!err) {
      console.log(data);
      res.render("consultant", {
        consultants: data,
      });
    }
  });
});

module.exports = router;
