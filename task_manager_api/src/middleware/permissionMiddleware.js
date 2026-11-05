const Task = require('../models/Task');
const TaskShare = require('../models/TaskShare');

// [CODE SIMPLIFICATION]
// Thay vì viết nát code trong từng controller, ta viết 1 hàm dùng chung.
// requiredRole có thể là 'viewer' (chỉ xem) hoặc 'editor' (được sửa/xoá)
exports.checkTaskPermission = (requiredRole = 'viewer') => {
  return async (req, res, next) => {
    try {
      const taskId = req.params.id;
      const userId = req.user._id;

      const task = await Task.findById(taskId);
      if (!task) {
        return res.status(404).json({ success: false, message: 'Không tìm thấy công việc' });
      }

      // 1. Quyền Tối Cao: Người tạo ra task (createdBy)
      if (task.createdBy.toString() === userId.toString()) {
        req.task = task; // Truyền task đi tiếp để controller đỡ phải query lại
        return next();
      }

      // 2. Quyền Người thực hiện: Người được giao việc (assignee) -> Mặc định có quyền edit
      if (task.assigneeIds.some(id => id.toString() === userId.toString())) {
        req.task = task;
        return next();
      }

      // 3. Quyền Chia sẻ: Kiểm tra xem có được share không
      const share = await TaskShare.findOne({ taskId, userId });
      if (!share) {
        return res.status(403).json({ success: false, message: 'Bạn không có quyền truy cập công việc này' });
      }

      // Nếu API yêu cầu quyền 'editor' nhưng user chỉ được share quyền 'viewer' -> Chặn
      if (requiredRole === 'editor' && share.permission !== 'editor') {
        return res.status(403).json({ success: false, message: 'Bạn chỉ có quyền xem, không được phép chỉnh sửa' });
      }

      req.task = task; // Cho qua
      next();
    } catch (error) {
      res.status(500).json({ success: false, message: 'Lỗi kiểm tra quyền phân quyền' });
    }
  };
};
