const express = require('express');
const { searchUsers } = require('../controllers/userController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.use(protect);

// GET /api/users/search
router.get('/search', searchUsers);

module.exports = router;
