const express = require('express');
const { getTasks, createTask, getTask, updateTask, deleteTask } = require('../controllers/taskController');
const { protect } = require('../middleware/authMiddleware');
const { checkTaskPermission } = require('../middleware/permissionMiddleware');

// Import sub-routes
const assignmentRoutes = require('./assignmentRoutes');
const taskShareRoutes = require('./taskShareRoutes');

const router = express.Router();

// Bất kỳ API nào liên quan đến Task đều phải Đăng nhập (protect)
router.use(protect);

// Móc (Mount) sub-routes vào taskRoutes
router.use('/:id/assignees', assignmentRoutes);
router.use('/:id/shares', taskShareRoutes);

// Routes chung (Lấy danh sách, Tạo mới)
router.route('/')
  .get(getTasks)
  .post(createTask);

// Routes cụ thể cho 1 Task (Cần check phân quyền)
router.route('/:id')
  .get(checkTaskPermission('viewer'), getTask) // Bất cứ ai liên quan đều xem được
  .put(checkTaskPermission('editor'), updateTask) // Phải có quyền editor mới sửa được
  .delete(checkTaskPermission('editor'), deleteTask); // Phải có quyền editor mới xoá được

module.exports = router;
