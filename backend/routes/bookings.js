const express = require("express");

const router = express.Router();
const Booking = require("../model/booking");
const PostAd = require("../model/postAd");

router.get("/booking/:email", (req, res) => {
  const email = req.params.email;
  Booking.aggregate(
    [
      {
        $lookup: {
          from: "postads",
          localField: "property_id",
          foreignField: "property_id",
          as: "data",
        },
      },
      { $unwind: "$data" },
      { $match: { "data.contact_email": email } },
    ],
    (err, data) => {
      if (!err) {
        console.log(data);
        res.status(200).send({ message: "Success", data: data });
      } else {
        res.status(400).send({ message: "Error" });
      }
    },
  );
});

module.exports = router;
