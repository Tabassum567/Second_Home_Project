const express = require("express");
const router = express.Router();
const adminpostAdApproval = require("../model/adminpostAdApproval");
const postAd = require("../model/postAd");
const postAdImages = require("../model/postAdImages");
const Rooms = require("../model/rooms");

const cloudinary = require("../utils/cloudinary");

router.get("/postAd", async (req, res) => {
  postAd.aggregate(
    [
      {
        $lookup: {
          from: "propertyimages",
          localField: "property_id",
          foreignField: "property_id",
          as: "propertyData",
        },
      },
    ],
    (err, data) => {
      if (!err) {
        res.status(200).send({ ads: data });
      } else {
        res.status(400).send({ message: "Error" });
      }
    }
  );
});

router.post("/postAd/:email_address", async (req, res) => {
  const email_address = req.params.email_address;

  const operations = [];

  const {
    property_type,
    city,
    rooms,
    property_title,
    address,
    availability_period,
    monthly_rent,
    currency,
    installment_allowed,
    advance_payment,
    additional_informtion,
    facilities,
    contact_name,
    contact_number,
    contact_email,
    image,
    private_room,
    shared_room,
  } = req.body;

  try {
    const postad = adminpostAdApproval({
      property_type: property_type,
      city: city,
      property_title: property_title,
      address: address,
      availability_period: availability_period,
      monthly_rent: monthly_rent,
      currency: currency,
      installment_allowed: installment_allowed,
      advance_payment: advance_payment,
      additional_informtion: additional_informtion,
      facilities: facilities,
      contact_name: contact_name,
      contact_number: contact_number,
      contact_email: contact_email,
    });

    await adminpostAdApproval.create(postad, (err, doc) => {
      if (!err) {
        shared_room.forEach((element) => {
          const room = Rooms({
            property_id: doc._id,
            room_type: "shared",
            bed_number: element,
            available: element,
          });
          operations.push({ insertOne: { document: room } });
        });
        const room = Rooms({
          property_id: doc._id,
          room_type: "private",
          bed_number: private_room,
          available: private_room,
        });
        operations.push({ insertOne: { document: room } });
        Rooms.bulkWrite(operations, (err) => {
          if (!err) {
            console.log("Data posted");
          } else {
            console.log(err);
            res.status(400).send({ message: "Error Occurred In saving Rooms" });
          }
        });
        // Images Upload
        image.forEach(async (picture) => {
          await cloudinary.uploader
            .upload(
              picture,
              {
                folder: "Property",
              },
              (err, response) => {
                if (!err) {
                  console.log("Image uploaded");
                  const property_image = new postAdImages({
                    property_id: doc._id,
                    picture_url: response.secure_url,
                    public_id: response.public_id,
                  });
                  postAdImages.create(property_image, (err) => {
                    if (!err) {
                      console.log("Image Uploaded Sucessfully");
                    } else {
                      console.log(
                        "Image Uploaded ~ Error Occurred while saving"
                      );
                      res.status(400).send({
                        message: "Image Uploaded ~ Error Occurred while saving",
                      });
                    }
                  });
                } else {
                  console.log("Error Uploading Images " + err);
                }
              }
            )
            .catch((err) => {
              console.log("Error in Uploading Images " + err);
            });
        });
        res.status(200).send({ message: "Images Uploaded Sucessfully" });
      } else {
        console.log(err);
        res
          .status(400)
          .send({ message: "Error Occurred in saving Property type" });
      }
    });
  } catch (error) {
    console.log("Data Error" + error);
    res.status(400).send({ message: "Error" });
  }
});

module.exports = router;
