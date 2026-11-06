const Notification = require('../models/Notification');

exports.getNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find({ userId: req.user._id })
      .sort({ createdAt: -1 })
      .limit(50); // Tránh trả về quá nhiều
    res.status(200).json({ success: true, data: notifications });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi lấy danh sách thông báo' });
  }
};

exports.getUnreadCount = async (req, res) => {
  try {
    const count = await Notification.countDocuments({ userId: req.user._id, isRead: false });
    res.status(200).json({ success: true, count });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi đếm thông báo' });
  }
};

exports.markAsRead = async (req, res) => {
  try {
    await Notification.findOneAndUpdate(
      { _id: req.params.id, userId: req.user._id },
      { isRead: true }
    );
    res.status(200).json({ success: true, message: 'Đã đánh dấu đọc' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi cập nhật thông báo' });
  }
};

exports.markAllAsRead = async (req, res) => {
  try {
    await Notification.updateMany(
      { userId: req.user._id, isRead: false },
      { isRead: true }
    );
    res.status(200).json({ success: true, message: 'Đã đọc tất cả' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi cập nhật tất cả thông báo' });
  }
};
