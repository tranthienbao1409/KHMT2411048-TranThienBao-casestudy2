const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST || 'smtp.gmail.com',
  port: process.env.SMTP_PORT || 587,
  secure: false,
  auth: {
    user: process.env.SMTP_USER, 
    pass: process.env.SMTP_PASS, 
  },
});

exports.sendEmail = async ({ to, subject, html }) => {
  try {
    const mailOptions = {
      from: `"Task Manager" <${process.env.SMTP_USER}>`,
      to: to,
      subject: subject,
      html: html,
    };

    // Gửi ngầm không đợi (fire-and-forget) để tránh block API
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error('Lỗi khi gửi email chạy ngầm:', error);
      } else {
        console.log('Email đã được gửi thành công:', info.response);
      }
    });

  } catch (error) {
    console.error('Lỗi cấu hình gửi email:', error);
  }
};
