const express = require("express");
const router = express.Router();
const User = require("../model/user");
const Customer = require("../model/customer");

router.post("/register", async (req, res) => {
  var { username, email_address, contact_number, cnic, password, role } =
    req.body;
  //   console.log(req.body);

  await User.exists({ email_address: email_address }, async (err, doc) => {
    if (doc) {
      res.status(403).send({ message: "User Already Present" });
    } else if (!doc) {
      const user = new User({
        email_address: email_address,
        password: password,
        role: role,
      });

      const customer = new Customer({
        username: username,
        email_address: email_address,
        contact_number: contact_number,
        cnic: cnic,
      });

      await user.save();
      await customer.save();
      res.status(200).send({ message: "Registration Succesful" });
    } else {
      res.status(402).send({ message: "Error Occured" });
    }
  });
});

module.exports = router;
