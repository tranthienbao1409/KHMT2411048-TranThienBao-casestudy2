const Task = require('../models/Task');
const User = require('../models/User');
const Notification = require('../models/Notification'); // Thêm import
const { sendEmail } = require('../services/emailService');
const { getAssignTaskTemplate } = require('../utils/emailTemplates');

// @desc    Giao việc cho một người
exports.assignTask = async (req, res) => {
  try {
    const { userId } = req.body;
    
    const userToAssign = await User.findById(userId);
    if (!userToAssign) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng này' });
    }

    const task = req.task;

    if (task.assigneeIds.includes(userId)) {
      return res.status(400).json({ success: false, message: 'Người này đã được giao công việc rồi' });
    }

    task.assigneeIds.push(userId);
    if (!task.primaryAssigneeId) {
      task.primaryAssigneeId = userId;
    }

    await task.save();
    
    // TRỌNG TÂM BUỔI 3: Gọi hàm gửi email chạy ngầm
    sendEmail({
      to: userToAssign.email,
      subject: '[Task Manager] Bạn có một công việc mới',
      html: getAssignTaskTemplate(task.title, req.user.fullName)
    });

    // Tạo thông báo In-app chạy ngầm
    Notification.create({
      userId: userToAssign._id,
      taskId: task._id,
      type: 'ASSIGNMENT',
      title: 'Được giao việc mới',
      message: `${req.user.fullName} vừa giao cho bạn công việc: ${task.title}`
    });

    res.status(200).json({ success: true, message: 'Giao việc thành công', data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi giao việc' });
  }
};
