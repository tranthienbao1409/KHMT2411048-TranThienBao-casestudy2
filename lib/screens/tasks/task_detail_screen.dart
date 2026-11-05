import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../../widgets/user_selector.dart'; // Thêm import

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // Hàm hiển thị hộp thoại xác nhận xoá (Chuẩn UX)
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: const Text('Bạn có chắc chắn muốn xoá công việc này không? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx); // Đóng hộp thoại
              
              final provider = Provider.of<TaskProvider>(context, listen: false);
              final success = await provider.deleteTask(widget.task.id);
              
              if (success && mounted) {
                Navigator.pop(context); // Quay lại màn hình list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xoá công việc thành công')),
                );
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(provider.error!), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Xoá ngay'),
          ),
        ],
      ),
    );
  }

  // Hàm chuyển đổi Trạng thái nhanh (TODO -> IN_PROGRESS -> COMPLETED)
  void _updateStatus(String newStatus) async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final success = await provider.updateTask(widget.task.id, {'status': newStatus});
    
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error!), backgroundColor: Colors.red),
      );
    } else {
      // Cập nhật lại UI ngay lập tức
      setState(() {}); 
    }
  }

  // Hiển thị BottomSheet
  void _showUserSelector(bool isSharing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: UserSelector(taskId: widget.task.id, isSharing: isSharing),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    
    // Lấy task mới nhất từ Provider để UI tự update khi trạng thái đổi
    final currentTask = Provider.of<TaskProvider>(context)
        .tasks
        .firstWhere((t) => t.id == widget.task.id, orElse: () => widget.task);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _confirmDelete,
            tooltip: 'Xoá công việc',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Text(
              currentTask.title,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 16),
            
            // Thông tin cơ bản (Badge)
            Row(
              children: [
                _buildChip('Ưu tiên: ${currentTask.priority}', Colors.orange),
                const SizedBox(width: 12),
                _buildChip(
                  currentTask.status == 'completed' ? 'Hoàn thành' : 
                  (currentTask.status == 'in_progress' ? 'Đang làm' : 'Cần làm'),
                  currentTask.status == 'completed' ? Colors.green : Colors.blue
                ),
              ],
            ),
            const Divider(height: 48, thickness: 1),

            // Mô tả
            const Text('Mô tả chi tiết:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              currentTask.description.isNotEmpty ? currentTask.description : 'Không có mô tả.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            
            const Divider(height: 48, thickness: 1),
            
            // Các nút hành động (Chuyển trạng thái, Giao việc, Chia sẻ)
            const Text('Hành động:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Dropdown đổi trạng thái nhanh
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300)
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: currentTask.status,
                  items: const [
                    DropdownMenuItem(value: 'todo', child: Text('Đánh dấu: Cần làm')),
                    DropdownMenuItem(value: 'in_progress', child: Text('Đánh dấu: Đang làm')),
                    DropdownMenuItem(value: 'completed', child: Text('Đánh dấu: Hoàn thành')),
                  ],
                  onChanged: (val) => _updateStatus(val!),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // [TODO: Chỗ này sẽ gắn Hộp thoại Giao việc và Chia sẻ ở bước sau]
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showUserSelector(false), // Gọi Dialog Assign
                    icon: const Icon(Icons.assignment_ind),
                    label: const Text('Giao việc'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showUserSelector(true), // Gọi Dialog Share
                    icon: const Icon(Icons.share),
                    label: const Text('Chia sẻ'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}
