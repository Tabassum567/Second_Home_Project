const express = require("express");

const router = express.Router();

const Document = require("../model/document");
const cloudinary = require("../utils/cloudinary");

router.get("/documents", (req, res) => {
  Document.find({}, (err, data) => {
    if (!err) {
      res.status(200).send({ message: "Success", data: data });
    } else {
      res.status(400).send({ message: "Error Occurred" });
    }
  });
});

router.post("/documents", async (req, res) => {
  var { emailAddress, image } = req.body;
  image = "data:image/jpeg;base64," + image;
  console.log(image.substring(0, 100));
  const result = await cloudinary.uploader
    .upload(image, {
      folder: "Documents",
    })
    .catch((err) => {
      if (err) {
        console.log("Error Occurred" + err);
        res.status(400).send({ message: "Error Occurred" });
      }
    });

  const document = new Document({
    email: emailAddress,
    picture_url: result.secure_url,
    public_id: result.public_id,
  });

  console.log("Success");
  Document.create(document, (err) => {
    if (!err) {
      res.status(200).send({ message: "Success" });
    } else {
      res.status(400).send({ message: "Error Occurred" });
    }
  });
});

module.exports = router;
