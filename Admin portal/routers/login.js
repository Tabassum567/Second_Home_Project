const express = require("express");

const Users = require("../models/users");
const Posts = require("../models/postAd");

const router = express.Router();

router.get("/adminlogin", (req, res) => {
  res.render("loginn");
});

router.post("/adminlogin", (req, res) => {
  const { email_address, password } = req.body;
  console.log(email_address, password);
  Users.findOne({ email_address: email_address }, (err, user) => {
    console.log(user);
    if (!err) {
      if (user === null || user === undefined) {
        res.status(404).send("Admin not Found");
      } else {
        if (user.role === "A") {
          if (user.password === password) {
            res.redirect("/adminDashboard");
          } else {
            res.status(401).send("<h1>Unauthorized Access</h1>");
          }
        } else if (user.role === "Advisor") {
          console.log("Role is advisor");
          if (user.password === password) {
            res.redirect("/documentDetails");
          } else {
            res.status(401).send("<h1>Unauthorized Access</h1>");
          }
        }
      }
    } else {
      res.status(400).send({ message: "Error Occured " + err });
    }
  });
});

router.get("/adminDashboard", async (req, res) => {
  const user_num = await Users.count({ role: "Student" });
  const owner = await Users.count({ role: "Owner" });
  const ads = await Posts.count();
  console.log(user_num, owner, ads);
  res.render("dashboard", {
    user_num: user_num,
    owner_num: owner,
    post_num: ads,
  });
});
module.exports = router;
