const bodyParser = require("body-parser");
const express = require("express");
const app = express();
const mongoose = require("mongoose");

const login = require("./routers/login");
const postAd = require("./routers/postAdApproval");
const bookAVisit = require("./routers/bookAVisit");
const userData = require("./routers/usersData");
const complains = require("./routers/complain");
const consultant = require("./routers/consultant");
const advisor = require("./routers/advisor");

const databaseURL =
  // "mongodb+srv://tabassum:a0RaON1WB7r4YbrZ@cluster0.u0q2y.mongodb.net/second-home?retryWrites=true&w=majority";
  "mongodb://0.0.0.0:27017/second-home?readPreference=primary&ssl=false&directConnection=true";
mongoose.set("strictQuery", true);
app.set("view engine", "ejs");
app.use(express.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true }));
app.use(express.static("public"));

app.use(login);
app.use(postAd);
app.use(bookAVisit);
app.use(userData);
app.use(complains);
app.use(consultant);
app.use(advisor);

app.get("*", (req, res) => {
  res.render("404");
});
app.listen(8000, (err) => {
  if (err) {
    console.log("Error running in server " + err);
  } else {
    console.log("Server Running on port 8000");
  }
});

mongoose.connect(databaseURL, (err) => {
  if (err) {
    console.log("Could not connect to database" + err);
  } else {
    console.log("Succesfully Connected to database");
  }
});
