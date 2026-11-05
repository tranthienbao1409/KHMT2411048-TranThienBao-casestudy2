const Task = require('../models/Task');
const TaskShare = require('../models/TaskShare');

// @desc    Lấy danh sách công việc mà user có quyền truy cập
// @route   GET /api/tasks
// @access  Private (Require Token)
exports.getTasks = async (req, res) => {
  try {
    const userId = req.user._id;
    // Bộ lọc tùy chọn từ query string (VD: ?status=todo&priority=high)
    const { status, priority, scope } = req.query;

    // 1. Tìm TẤT CẢ các task mà user có quyền (Tạo, Được Giao, Được Share)

    // - Các task được share cho user này
    const sharedTasks = await TaskShare.find({ userId }).select('taskId');
    const sharedTaskIds = sharedTasks.map(share => share.taskId);

    // Xây dựng câu query linh hoạt
    let query = {
      $or: [
        { createdBy: userId }, // Task do mình tạo
        { assigneeIds: userId }, // Task mình được giao
        { _id: { $in: sharedTaskIds } } // Task mình được chia sẻ
      ]
    };

    // Lọc theo yêu cầu của Frontend (Scope Filter)
    if (scope === 'created') {
      query = { createdBy: userId };
    } else if (scope === 'assigned') {
      query = { assigneeIds: userId };
    } else if (scope === 'shared') {
      query = { _id: { $in: sharedTaskIds } };
    }

    // Lọc theo Trạng thái & Ưu tiên
    if (status) query.status = status;
    if (priority) query.priority = priority;

    // Thực thi query, populate (join) bảng User để lấy tên người tạo
    const tasks = await Task.find(query)
      .populate('createdBy', 'fullName avatarUrl')
      .populate('primaryAssigneeId', 'fullName avatarUrl')
      .sort({ createdAt: -1 }); // Sắp xếp mới nhất lên đầu

    res.status(200).json({ success: true, count: tasks.length, data: tasks });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi lấy danh sách công việc' });
  }
};

// @desc    Tạo công việc mới
// @route   POST /api/tasks
// @access  Private (Require Token)
exports.createTask = async (req, res) => {
  try {
    const { title, description, startDate, dueDate, priority, status } = req.body;

    const task = await Task.create({
      title,
      description,
      startDate,
      dueDate,
      priority,
      status,
      createdBy: req.user._id, // Gán người tạo là user đang đăng nhập
    });

    res.status(201).json({ success: true, data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Lấy chi tiết 1 công việc
// @route   GET /api/tasks/:id
// @access  Private (Require Token & Permission)
exports.getTask = async (req, res) => {
  // req.task đã được middleware checkTaskPermission gán sẵn
  try {
    const task = await Task.findById(req.task._id)
      .populate('createdBy', 'fullName email')
      .populate('assigneeIds', 'fullName email')
      .populate('primaryAssigneeId', 'fullName email');

    res.status(200).json({ success: true, data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Cập nhật công việc
// @route   PUT /api/tasks/:id
// @access  Private (Require Token & Editor Permission)
exports.updateTask = async (req, res) => {
  try {
    const { title, description, startDate, dueDate, priority, status } = req.body;

    // req.task đã được middleware bắt lại rồi, chỉ việc dùng
    const task = await Task.findByIdAndUpdate(
      req.task._id,
      { title, description, startDate, dueDate, priority, status },
      { new: true, runValidators: true } // new: true trả về doc mới sau khi update
    );

    res.status(200).json({ success: true, data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Xoá công việc
// @route   DELETE /api/tasks/:id
// @access  Private (Require Token & Editor Permission)
exports.deleteTask = async (req, res) => {
  try {
    await Task.findByIdAndDelete(req.task._id);

    // Nhớ xoá luôn cả các share liên quan đến task này cho sạch DB
    await TaskShare.deleteMany({ taskId: req.task._id });

    res.status(200).json({ success: true, message: 'Đã xoá công việc' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
