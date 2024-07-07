const express = require("express");
const router = express.Router();
const User = require("../model/user");
const Customer = require("../model/customer");
// Login
router.post("/login", (req, res) => {
  var { email_address, password } = req.body;
  console.log(req.body);

  User.findOne(
    { email_address: email_address, password: password },
    (err, doc) => {
      if (err) {
        console.log("1" + err);
        res.status(404).send({ message: "Error Occurred" });
      } else if (doc) {
        res.status(200).send({ message: "Successfull Login", user: doc });
        console.log("2");
      } else {
        res.status(401).send({ message: "Incorrect Credentials" });
        console.log("3");
      }
    }
  );
});

module.exports = router;
