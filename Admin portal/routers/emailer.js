const nodemailer = require("nodemailer");
// async..await is not allowed in global scope, must use a wrapper
async function sendEmail(email_to) {
  // create reusable transporter object using the default SMTP transport
  let transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    service: "Gmail",
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
      user: "t0867519@gmail.com", // generated ethereal user
      pass: "rahthxitpjenbtpl", // generated ethereal password
    },
  });

  let info = transporter.sendMail(
    {
      from: '"Tabassum" <t0867519@gmail.com>',
      to: email_to,
      subject: "Complaint Received - Query",
      text:
        "We are sorry to hear that you have a complaint regarding a query. We value your feedback and take all complaints seriously.Please provide us with your room number and a detailed description of the issue so that we can investigate and resolve the matter as soon as possible.If you have any additional information or documentation that you would like to share, please feel free to attach it to this email.\nWe appreciate your patience and understanding as we work to address your complaint. Please do not hesitate to contact us if you have any further questions or concerns\n" +
        "Best regards\n" +
        "Team Second Home", // html body
    },
    (err) => {
      if (!err) {
        return 200;
      } else {
        return 404;
      }
    }
  );
}

async function sendEmailVisitScheduled(email_to, visit_date, visit_time) {
  let transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    service: "Gmail",
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
      user: "t0867519@gmail.com", // generated ethereal user
      pass: "rahthxitpjenbtpl", // generated ethereal password
    },
  });

  let info = transporter.sendMail(
    {
      from: '"Tabassum" <t0867519@gmail.com>',
      to: email_to,
      subject: "Visit Received - Query",
      text:
        "Book A visit has been scheduled on " +
        visit_date +
        " at " +
        visit_time, // html body
    },
    (err) => {
      if (!err) {
        return 200;
      } else {
        return 404;
      }
    }
  );
}

async function rejectionEmail(email_to, reason, suggestion) {
  let transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    service: "Gmail",
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
      user: "t0867519@gmail.com", // generated ethereal user
      pass: "rahthxitpjenbtpl", // generated ethereal password
    },
  });

  let info = transporter.sendMail(
    {
      from: '"Tabassum" <t0867519@gmail.com>',
      to: email_to,
      subject: "Account Rejection - Query",
      text:
        "Your Accont has been rejected due to following reason " +
        reason +
        ". You need to look at the following suggestion " +
        suggestion, // html body
    },
    (err) => {
      if (!err) {
        return 200;
      } else {
        return 404;
      }
    }
  );
}

async function complainResolved(email_to, resolution_description) {
  let transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    service: "Gmail",
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
      user: "t0867519@gmail.com", // generated ethereal user
      pass: "rahthxitpjenbtpl", // generated ethereal password
    },
  });

  let info = transporter.sendMail(
    {
      from: '"Tabassum" <t0867519@gmail.com>',
      to: email_to,
      subject: "Dispute Resolved - Query",
      text:
        "Your dispute has been resolved and resolution is" +
        resolution_description, // html body
    },
    (err) => {
      if (!err) {
        return 200;
      } else {
        return 404;
      }
    }
  );
}

module.exports = { sendEmail, sendEmailVisitScheduled, rejectionEmail, complainResolved };
