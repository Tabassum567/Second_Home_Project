const express = require("express");
const router = express.Router();
const Customer = require("../model/customer");
// Login
router.post("/setAgreement/:email_address", (req, res) => {
  const email_address = req.params.email_address;
  console.log(email_address);
  Customer.findOneAndUpdate(
    { email_address: email_address },
    {
      agreement: "true",
    },
    (err) => {
      if (!err) {
        console.log("updated");
        res.status(200).send({ message: "Updated Successfully" });
      } else {
        console.log("Failed");
        res.status(400).send({ message: "Error Occurred" });
      }
    }
  );
});

module.exports = router;
