const express = require("express");

const router = express.Router();
const User = require("../models/users");
const Visit = require("../models/visits");
const { sendEmailVisitScheduled } = require("./emailer");

router.get("/bookAVisit", async (req, res) => {
  Visit.aggregate(
    [
      {
        $lookup: {
          from: "customers",
          localField: "customer_email",
          foreignField: "email_address",
          as: "customerData",
        },
      },
      {
        $lookup: {
          from: "postads",
          localField: "property_id",
          foreignField: "property_id",
          as: "postAdData",
        },
      },
      { $unwind: "$customerData" },
      { $unwind: "$postAdData" },

      {
        $lookup: {
          from: "customers",
          localField: "postAdData.contact_email",
          foreignField: "email_address",
          as: "ownerData",
        },
      },

      { $unwind: "$customerData" },
      { $unwind: "$ownerData" },
    ],
    (err, data) => {
      User.aggregate(
        [
          { $match: { role: "Owner" } },
          {
            $lookup: {
              from: "customers",
              localField: "email_address",
              foreignField: "email_address",
              as: "ownerData",
            },
          },
          { $unwind: "$ownerData" },
        ],
        (err, ownerData) => {
          if (!err) {
            console.log(ownerData);
            res.render("bookAVisit", {
              data: data,
              ownerData: ownerData,
            });
          } else {
            res.render("bookAVisit", {
              data: "",
            });
          }
        }
      );
      if (!err) {
        console.log("Success");
      } else {
        console.log("Error");
      }
    }
  );
});

router.post("/scheduleAVisit", async (req, res) => {
  const { id, visit, slot } = req.body;
  console.log("Body: " + id);
  Visit.updateOne(
    { _id: id },
    {
      status: "scheduled",
      visit_date: visit,
      visit_time: slot,
    },
    (error) => {
      if (!error) {
        Visit.findById(id, (err, doc) => {
          if (!err) {
            sendEmailVisitScheduled(doc.customer_email, visit, slot).catch(
              (reason) => {
                console.log("Could Not Sent Email" + reason);
              }
            );
            console.log("Visit Scheduled ");
            res.status(200).send({ message: "Appoinment Scheduled" });
          }
        });
      } else {
        console.log("Appoinment Schedule Failed " + error);
      }
    }
  );
});

module.exports = router;
