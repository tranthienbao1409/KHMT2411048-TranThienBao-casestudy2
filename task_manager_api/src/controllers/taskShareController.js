const TaskShare = require('../models/TaskShare');
const User = require('../models/User');

// @desc    Chia sẻ task cho người khác
// @route   POST /api/tasks/:id/shares
// @access  Private (Chỉ Editor mới được share)
exports.shareTask = async (req, res) => {
  try {
    const { userId, permission } = req.body; // permission = 'viewer' hoặc 'editor'
    
    // Kiểm tra user có tồn tại không
    const userToShare = await User.findById(userId);
    if (!userToShare) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng này' });
    }

    // Tạo bản ghi Share mới. Nhờ unique index trong Model, nếu share 2 lần nó sẽ báo lỗi văng vào catch
    const share = await TaskShare.create({
      taskId: req.task._id,
      userId: userId,
      permission: permission || 'viewer',
      sharedBy: req.user._id
    });

    res.status(201).json({ success: true, message: 'Chia sẻ thành công', data: share });
  } catch (error) {
    // 11000 là mã lỗi của MongoDB khi dính Unique trùng lặp
    if (error.code === 11000) {
      return res.status(400).json({ success: false, message: 'Người này đã được chia sẻ công việc rồi' });
    }
    res.status(500).json({ success: false, message: 'Lỗi khi chia sẻ công việc' });
  }
};
