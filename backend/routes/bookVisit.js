const express = require("express");
const router = express.Router();
const Complain = require("../model/complain");
const email = require("../emailer");

const Visit = require("../model/visits");
const Booking = require("../model/booking");

router.post("/bookVisit/:email_address", async (req, res) => {
  const email_address = req.params.email_address;
  const { property_id, contact_number, date } = req.body;
  console.log(req.body);
  try {
    Visit.findOne({ customer_email: email_address }, (err, doc) => {
      if (!err) {
        if (doc === null || doc === undefined) {
          const visit = new Visit({
            customer_email: email_address,
            property_id: property_id,
            contact_number: contact_number,
            date: date,
          });
          email.sendEmailVisit(email_address);
          Visit.create(visit, (err) => {
            if (!err) {
              console.log("Email Sent");
              res
                .status(200)
                .send({ message: "Your Visit will be resolved shortly" });
            } else {
              console.log(err);
              res.status(404).send({ message: "Error Occurred" });
            }
          });
        } else {
          res
            .status(404)
            .send({ message: "You have already taken appoinment" });
        }
      }
    });
  } catch (error) {
    console.log(error);
    res.status(404).send({ message: "Error Occurred" });
  }
});

router.get("/bookingHistory/:email_address", async (req, res) => {
  const emailAddress = req.params.email_address;
  console.log("Email: " + emailAddress);
  Booking.aggregate(
    [
      { $match: { user_email: emailAddress } },
      {
        $lookup: {
          from: "postads",
          localField: "property_id",
          foreignField: "property_id",
          as: "bookings",
        },
      },
      {
        $lookup: {
          from: "propertyimages",
          localField: "property_id",
          foreignField: "property_id",
          as: "images",
        },
      },
    ],
    (err, data) => {
      if (!err) {
        console.log(data);
        res.status(200).send({ history: data });
      } else {
        res.status(400).send({ message: "Error" });
      }
    }
  );
});

module.exports = router;
