const express = require("express");
const router = express.Router();
const cloudinary = require("../utils/cloudinary");
const Customer = require("../model/customer");

router.get("/fetchCustomer/:email_address", async (req, res) => {
  const email_address = req.params.email_address;

  console.log("Requested " + email_address);
  Customer.findOne({ email_address: email_address }, (err, data) => {
    if (!err) {
      res.status(200).send({ message: "Success", customer: data });
    } else {
      console.log(err);
      res.status(400).send({ message: "Error" });
    }
  });
});

router.post("/updateCustomer/:email", async (req, res) => {
  const email = req.params.email;
  const { email_address, name, contact_number, image } = req.body;

  console.log(email, req.body);
  if (image !== null) {
    const picture = "data:image/jpeg;base64," + image;
    const result = await cloudinary.uploader.upload(picture, {
      folder: "Profile Pictures",
    });
    Customer.findOneAndUpdate(
      { email_address: email },
      {
        username: name,
        email_address: email_address,
        contact_number: contact_number,
        picture_public_id: result.public_id,
        picture_public_url: result.secure_url,
      },
      (err) => {
        if (!err) {
          console.log("updated without image " + result.secure_url + " <-");
          res.status(200).send({ message: "Updated Successfully" });
        } else {
          console.log("Failed1");
          res.status(400).send({ message: "Error Occurred" });
        }
      }
    );
  } else {
    Customer.findOneAndUpdate(
      { email_address: email },
      {
        username: name,
        email_address: email_address,
        contact_number: contact_number,
      },
      (err) => {
        if (!err) {
          console.log("updated with image");
          res.status(200).send({ message: "Updated Successfully" });
        } else {
          console.log("Failed2");
          res.status(400).send({ message: "Error Occurred" });
        }
      }
    );
  }
});

router.post("/ownerAvailability/:email", (req, res) => {
  const email_address = req.params.email;
  const { availability } = req.body;
  try {
    console.log("Availability: " + availability);
    Customer.findOneAndUpdate(
      { email_address: email_address },
      {
        availability: availability,
      },
      (err) => {
        if (!err) {
          res.status(200).send({ message: "Success" });
        } else {
          res.status(404).send({ message: "Error" });
        }
      }
    );
  } catch (error) {
    res.status(500).send({ message: "Internal Error" });
  }
});
module.exports = router;
