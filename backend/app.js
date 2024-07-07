const express = require("express");
const bodyparser = require("body-parser");
const mongoose = require("mongoose");
const cors = require("cors");

const User = require("./model/user");
const Customer = require("./model/customer");

const app = express();

const loginRouter = require("./routes/login");
const registerRouter = require("./routes/register");
const complainRouter = require("./routes/complain");
const postAdRouter = require("./routes/postAdd");
const customerRouter = require("./routes/customer");
const ownerAgreementRouter = require("./routes/ownerAgreement");
const bookAVisitRouter = require("./routes/bookVisit");
const Rooms = require("./routes/room");
const PostListing = require("./routes/postListing");
const Booking = require("./routes/bookings");
const Document = require("./routes/document");
const Chat = require("./routes/chat");

mongoose.set("strictQuery", true);

app.use(express.json({ limit: "50mb" }));
app.use(bodyparser.urlencoded({ limit: "50mb", extended: true }));
app.use(cors());

app.use(loginRouter);
app.use(registerRouter);
app.use(complainRouter);
app.use(postAdRouter);
app.use(customerRouter);
app.use(ownerAgreementRouter);
app.use(bookAVisitRouter);
app.use(Rooms);
app.use(PostListing);
app.use(Booking);
app.use(Document);
app.use(Chat);

const databaseURL =
  // "mongodb+srv://tabassum:a0RaON1WB7r4YbrZ@cluster0.u0q2y.mongodb.net/second-home?retryWrites=true&w=majority";
  // "mongodb://localhost:27017/second-home?readPreference=primary&ssl=false";
  "mongodb://0.0.0.0:27017/second-home?readPreference=primary&ssl=false&directConnection=true";
//Register

app.listen(5000, (err) => {
  if (err) {
    console.log("Error Occurred");
  } else {
    console.log("Server is running on port 5000");
  }
});

mongoose.connect(databaseURL, (err) => {
  if (err) {
    console.log("Database Error occurred" + err);
  } else {
    console.log("Database Connected");
  }
});
