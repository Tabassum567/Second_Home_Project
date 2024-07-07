const express = require("express");
const router = express.Router();
const Complain = require("../model/complain");
const email = require("../emailer");

router.post("/complain/:email_address", async (req, res) => {
  const email_address = req.params.email_address;
  const {
    complain_title,
    complain_description,
    complain_category,
  } = req.body;
  console.log(complain_title, complain_description, complain_category);
  const complain = new Complain({
    complain_owner: email_address,
    complain_category: complain_category,
    complain_title: complain_title,
    complain_description: complain_description,
  });
  email.sendEmail(email_address);
  try {
    await complain.save();
    res.status(200).send({ message: "Your Complain will be resolved shortly" });
  } catch (error) {
    res.status(404).send({ message: "Error Occurred" });
  }
});

module.exports = router;
