const express = require('express');
const { register, login, forgotPassword, resetPassword, updateProfile, changePassword } = require('../controllers/authController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

// Public routes
router.post('/register', register);
router.post('/login', login);
router.post('/forgot-password', forgotPassword);
router.post('/reset-password', resetPassword);

// Protected routes (Cần đăng nhập)
router.put('/me', protect, updateProfile);
router.put('/change-password', protect, changePassword);

module.exports = router;
