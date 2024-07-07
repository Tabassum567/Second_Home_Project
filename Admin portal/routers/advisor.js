const express = require("express");

const router = express.Router();
const User = require("../models/users");

const Document = require("../models/document");

router.get("/documentDetails", async (req, res) => {
  console.log("Here");
  Document.aggregate(
    [
      {
        $lookup: {
          from: "customers",
          localField: "email",
          foreignField: "email_address",
          as: "data",
        },
      },
      { $unwind: "$data" },
    ],
    (err, data) => {
      if (!err) {
        console.log(data);
        res.render("advisor", {
          data: data,
        });
      } else {
        res.render("advisor", {
          data: "",
        });
      }
    }
  );
});

router.post("/documentDetails", (req, res) => {
  const { email, status } = req.body;
  console.log(req.body);

  User.findOneAndUpdate(
    { email_address: email },
    {
      status: status,
    },
    (err) => {
      if (!err) {
        console.log("Record Updated");
      } else {
        console.log("Record could not be updated");
      }
    }
  );
});

module.exports = router;
