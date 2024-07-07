const express = require("express");

const router = express.Router();

const postAd = require("../model/postAd");
const adminApproval = require("../model/adminpostAdApproval");
const rejectedAds = require("../model/rejectedAccount");

router.get("/postPending/:email", (req, res) => {
  const ownerEmail = req.params.email;
  try {
    adminApproval.find({ contact_email: ownerEmail }, (err, docs) => {
      if (!err) {
        res.status(200).send({ message: "Success", ads: docs });
      } else {
        res.status(400).send({ message: "Error Occurred" + err });
      }
    });
  } catch (error) {
    res.status(500).send({ message: "Internal Server Error" });
  }
});

router.get("/postApproved/:email", (req, res) => {
  const ownerEmail = req.params.email;
  try {
    postAd.find({ contact_email: ownerEmail }, (err, docs) => {
      if (!err) {
        res.status(200).send({ message: "Success", ads: docs });
      } else {
        res.status(400).send({ message: "Error Occurred" + err });
      }
    });
  } catch (error) {
    res.status(500).send({ message: "Internal Server Error" });
  }
});

router.get("/postRejected/:email", (req, res) => {
  const ownerEmail = req.params.email;
  try {
    rejectedAds.find({ contact_email: ownerEmail }, (err, docs) => {
      if (!err) {
        res.status(200).send({ message: "Success", ads: docs });
      } else {
        res.status(400).send({ message: "Error Occurred" + err });
      }
    });
  } catch (error) {
    res.status(500).send({ message: "Internal Server Error" });
  }
});

module.exports = router;
