const express = require("express");

const router = express.Router();
const Complain = require("../models/complain");
const { complainResolved } = require("./emailer");

router.get("/complain", async (req, res) => {
  const complains = await Complain.aggregate(
    [
      {
        $lookup: {
          from: "customers",
          localField: "complain_owner",
          foreignField: "email_address",
          as: "complain",
        },
      },
      { $unwind: "$complain" },
    ],
    (err, data) => {
      if (!err) {
        res.render("complain", {
          complains: data,
        });
      } else {
        alert("Error Occurred");
        res.redirect("/dashboard");
      }
    }
  );
});

router.post("/complain", (req, res) => {
  const { email, description } = req.body;
//   console.log(req.body);
    Complain.updateMany(
      { complain_owner: email },
      {
        complain_status: "Resolved",
        complain_resolution: description,
      },
      (err) => {
        if (!err) {
          complainResolved(email, description);
          res.redirect("/complain");
        } else {
          res.redirect("/complain");
        }
      }
    );
});

module.exports = router;
