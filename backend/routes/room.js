const express = require("express");
const mongoose = require("mongoose");

const router = express.Router();

const PostAd = require("../model/postAd");
const Rooms = require("../model/rooms");
const Booking = require("../model/booking");

router.get("/getRooms/:id", (req, res) => {
  const property_id = req.params.id;
  console.log("Request Fetched: " + property_id);
  PostAd.aggregate(
    [
      { $match: { property_id: property_id } },
      // { $addFields: { post_id: "$property_id" } },
      {
        $lookup: {
          from: "rooms",
          localField: "property_id",
          foreignField: "property_id",
          as: "data",
        },
      },
    ],
    (err, rooms) => {
      if (!err) {
        console.log("------->" + JSON.stringify(rooms));
        res.status(200).send({ rooms: rooms });
      } else {
        res.status(404).send({ message: "Rooms not found" });
      }
    }
  );
});

router.post("/bookRoom", (req, res) => {
  const {
    roomId,
    userEmail,
    propertyId,
    start_date,
    end_date,
    card_holder_name,
    card_number,
    expiration_date,
    cvv,
    total_amount,
  } = req.body;
  console.log(JSON.stringify(req.body));
  Rooms.findById(roomId, (err, room) => {
    if (!err) {
      if (room.available > 0) {
        Rooms.updateOne(
          { _id: roomId },
          {
            $inc: { available: -1 },
          },
          (err) => {
            if (!err) {
              const booking = new Booking({
                room_id: roomId,
                user_email: userEmail,
                property_id: propertyId,
                start_date: start_date,
                end_date: end_date,
                card_holder_name: card_holder_name,
                card_number: card_number,
                expiration_date: expiration_date,
                cvv: cvv,
                total_amount: total_amount,
              });
              Booking.create(booking, (err) => {
                if (!err) {
                  console.log("Room Booked");
                  res.status(200).send({ message: "Room Booked" });
                } else {
                  console.log("Room Booked Failed");
                  res.status(401).send({ message: "Room Booking Failed" });
                }
              });
            } else {
              res.status(401).send({ message: "Room Booking Failed" });
            }
          }
        );
      } else {
        res.status(404).send({ message: "Room Not Available" });
      }
    } else {
      res.status(404).send({ message: "Room Not Found" });
    }
  });
});

module.exports = router;
