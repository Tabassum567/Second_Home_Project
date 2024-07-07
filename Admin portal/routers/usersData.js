const express = require("express");

const User = require("../models/users");

const router = express.Router();

router.get("/students", (req, res) => {
  User.aggregate(
    [
      { $match: { role: "Student" } },
      {
        $lookup: {
          from: "customers",
          localField: "email_address",
          foreignField: "email_address",
          as: "studentData",
        },
      },
      { $unwind: "$studentData" },
    ],
    (err, data) => {
      if (!err) {
        console.log(data);
        res.render("student", {
          data: data,
        });
      } else {
        res.render("student", { data: "" });
      }
    }
  );
});

router.get("/owners", (req, res) => {
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
    (err, data) => {
      if (!err) {
        console.log(data);
        res.render("owner", {
          data: data,
        });
      } else {
        res.render("owner", { data: "" });
      }
    }
  );
});

module.exports = router;
