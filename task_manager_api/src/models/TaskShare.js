const mongoose = require('mongoose');

const taskShareSchema = new mongoose.Schema(
  {
    taskId: { type: mongoose.Schema.Types.ObjectId, ref: 'Task', required: true },
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    permission: { type: String, enum: ['viewer', 'editor'], default: 'viewer' },
    sharedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  },
  { timestamps: true }
);

// [TRỌNG TÂM CODE REVIEW]
// Tạo unique compound index để đảm bảo 1 Task chỉ được share cho 1 User tối đa 1 lần.
// Tránh rác DB nếu gọi API share nhiều lần liên tiếp.
taskShareSchema.index({ taskId: 1, userId: 1 }, { unique: true });

module.exports = mongoose.model('TaskShare', taskShareSchema);
