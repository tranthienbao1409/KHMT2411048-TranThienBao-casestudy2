const TaskShare = require('../models/TaskShare');
const User = require('../models/User');
const Notification = require('../models/Notification'); // Thêm import
const { sendEmail } = require('../services/emailService');
const { getShareTaskTemplate } = require('../utils/emailTemplates');

// @desc    Chia sẻ task cho người khác
exports.shareTask = async (req, res) => {
  try {
    const { userId, permission } = req.body;
    
    const userToShare = await User.findById(userId);
    if (!userToShare) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng này' });
    }

    const share = await TaskShare.create({
      taskId: req.task._id,
      userId: userId,
      permission: permission || 'viewer',
      sharedBy: req.user._id
    });

    // TRỌNG TÂM BUỔI 3: Gọi hàm gửi email chạy ngầm
    sendEmail({
      to: userToShare.email,
      subject: '[Task Manager] Ai đó vừa chia sẻ công việc với bạn',
      html: getShareTaskTemplate(req.task.title, req.user.fullName, share.permission)
    });

    // Tạo thông báo In-app chạy ngầm
    Notification.create({
      userId: userToShare._id,
      taskId: req.task._id,
      type: 'SHARE',
      title: 'Được chia sẻ công việc',
      message: `${req.user.fullName} vừa chia sẻ cho bạn công việc: ${req.task.title}`
    });

    res.status(201).json({ success: true, message: 'Chia sẻ thành công', data: share });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({ success: false, message: 'Người này đã được chia sẻ công việc rồi' });
    }
    res.status(500).json({ success: false, message: 'Lỗi khi chia sẻ công việc' });
  }
};
