const User = require('../models/User');

// @desc    Tìm kiếm user (để hiện lên danh sách cho lúc Giao việc/Chia sẻ)
// @route   GET /api/users/search?q=keyword
// @access  Private
exports.searchUsers = async (req, res) => {
  try {
    const keyword = req.query.q;
    if (!keyword) {
      return res.status(200).json({ success: true, data: [] });
    }

    // Tìm user có fullName hoặc email chứa từ khoá (Không phân biệt hoa thường)
    const users = await User.find({
      $or: [
        { fullName: { $regex: keyword, $options: 'i' } },
        { email: { $regex: keyword, $options: 'i' } }
      ]
    }).select('fullName email avatarUrl');

    res.status(200).json({ success: true, data: users });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi tìm kiếm người dùng' });
  }
};
