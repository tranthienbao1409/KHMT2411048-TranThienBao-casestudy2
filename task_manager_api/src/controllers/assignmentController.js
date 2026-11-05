const Task = require('../models/Task');
const User = require('../models/User');

// @desc    Giao việc cho một người
// @route   POST /api/tasks/:id/assignees
// @access  Private (Chỉ người có quyền Editor mới được giao việc)
exports.assignTask = async (req, res) => {
  try {
    const { userId } = req.body;
    
    // Kiểm tra user được giao có tồn tại không
    const userToAssign = await User.findById(userId);
    if (!userToAssign) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng này' });
    }

    // req.task đã được xác thực quyền qua permissionMiddleware
    const task = req.task;

    // Kiểm tra xem đã giao chưa để tránh trùng lặp
    if (task.assigneeIds.includes(userId)) {
      return res.status(400).json({ success: false, message: 'Người này đã được giao công việc rồi' });
    }

    // Đẩy userId vào mảng assignees
    task.assigneeIds.push(userId);
    // Nếu đây là người đầu tiên được giao, set luôn làm primaryAssignee
    if (!task.primaryAssigneeId) {
      task.primaryAssigneeId = userId;
    }

    await task.save();
    
    res.status(200).json({ success: true, message: 'Giao việc thành công', data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi giao việc' });
  }
};
