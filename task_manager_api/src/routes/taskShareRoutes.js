const express = require('express');
const { shareTask } = require('../controllers/taskShareController');
const { protect } = require('../middleware/authMiddleware');
const { checkTaskPermission } = require('../middleware/permissionMiddleware');

const router = express.Router({ mergeParams: true });

router.use(protect);

// POST /api/tasks/:id/shares
router.post('/', checkTaskPermission('editor'), shareTask);

module.exports = router;
