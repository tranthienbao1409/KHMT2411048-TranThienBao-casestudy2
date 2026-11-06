const express = require('express');
const { register, login, forgotPassword, resetPassword } = require('../controllers/authController');

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/forgot-password', forgotPassword); // Thêm mới
router.post('/reset-password', resetPassword); // Thêm mới

module.exports = router;
