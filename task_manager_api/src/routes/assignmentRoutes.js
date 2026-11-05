const express = require('express');
const { assignTask } = require('../controllers/assignmentController');
const { protect } = require('../middleware/authMiddleware');
const { checkTaskPermission } = require('../middleware/permissionMiddleware');

// mergeParams: true giúp lấy được :id của task từ file taskRoutes truyền qua
const router = express.Router({ mergeParams: true });

router.use(protect);

// POST /api/tasks/:id/assignees
router.post('/', checkTaskPermission('editor'), assignTask);

module.exports = router;
