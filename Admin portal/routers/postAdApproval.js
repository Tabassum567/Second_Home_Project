const express = require("express");

const PostAdApproval = require("../models/adminpostAdApproval");
const RejectedAccount = require("../models/rejectedAccount");
const PostAd = require("../models/postAd");
const { rejectionEmail } = require( "./emailer" );

const router = express.Router();

router.get("/postAdApprovals", async (req, res) => {
  const approvals = await PostAdApproval.find();
  res.render("postAdApproval", {
    approvals: approvals,
  });
});

router.post("/postAdApprovals", async (req, res) => {
  const {
    id,
    contact_name,
    contact_number,
    email_address,
    property_type,
    city,
    address,
    rooms,
    property_title,
    availabilty_period,
    monthly_rent,
    currency,
    installment_allowed,
    advance_payment,
    additional_information,
    facilities,
    button,
  } = req.body;
  console.log(req.body);
  if (button === "Accept") {
    const postad = PostAd({
      property_id: id,
      property_type: property_type,
      property_title: property_title,
      city: city,
      rooms: rooms,
      address: address,
      availability_period: availabilty_period,
      monthly_rent: monthly_rent,
      currency: currency,
      installment_allowed: installment_allowed,
      advance_payment: advance_payment,
      additional_informtion: additional_information,
      facilities: facilities,
      contact_name: contact_name,
      contact_number: contact_number,
      contact_email: email_address,
    });
    // console.log(postad);
    PostAd.create(postad, (err) => {
      if (!err) {
        PostAdApproval.findByIdAndDelete(id, async (err, doc) => {
          if (!err) {
            console.log("Accepted");
          } else {
            console.log("Error Occurred1" + err + " " + doc);
          }
          res.redirect("/postAdApprovals");
        });
      } else {
        console.log("Error Occurred while creating Post Ad" + err);
      }
    });
  } else {
    const rejected = RejectedAccount({
      property_type: property_type,
      property_title: property_title,
      city: city,
      rooms: rooms,
      address: address,
      availability_period: availabilty_period,
      monthly_rent: monthly_rent,
      currency: currency,
      installment_allowed: installment_allowed,
      advance_payment: advance_payment,
      additional_informtion: additional_information,
      facilities: facilities,
      contact_name: contact_name,
      contact_number: contact_number,
      contact_email: email_address,
    });
    // console.log(postad);
    RejectedAccount.create(rejected, (err, reject) => {
      if (!err) {
        res.redirect("/rejectAccount/" + reject._id+"&"+id);
        
      } else {
        console.log("Error Occurred while creating Post Ad" + err);
      }
    });
  }
});

router.get("/rejectAccount/:id", (req, res) => {
  const id = req.params.id;
  console.log("Here at /rejectAccount/:id " + id);
  res.render("denial", {
    id: id,
  });
});

router.post("/rejectAccount/reject", (req, res) => {
  const { reason, improvement, id } = req.body;
  console.log("Here at /rejectAccount/reject and id = " + id);
  const rejectionId = id.split("&")[0];
  const postId = id.split("&")[1];
  console.log(req.body);
  try {
    RejectedAccount.findByIdAndUpdate(
      rejectionId,
      {
        reason: reason,
        suggestion: improvement,
      },
      (err) => {
        if (!err) {
          console.log("Update Success");
          PostAdApproval.findByIdAndDelete(postId, (err, doc) => {
            if (!err) {
              console.log("Post Ad Deleted");
            } else {
              console.log("Error Occurred1" + err + " " + doc);
            }
          });
          RejectedAccount.findById(rejectionId, (err, doc)=>{
            if(!err)
            {
              console.log("email is "+ doc.contact_email);
              rejectionEmail(doc.contact_email,reason, improvement);
              res.redirect("/postAdApprovals");
            }
          })
        } else {
          console.log("Error");
          res.redirect("/postAdApprovals");
        }
      }
    );
  } catch (error) {
    console.log("Internal Server Error");
  }
});

module.exports = router;
