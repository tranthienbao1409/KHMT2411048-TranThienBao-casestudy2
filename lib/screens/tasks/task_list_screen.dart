import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/notification_provider.dart'; // Import provider thông báo
import '../../widgets/task_card.dart';
import '../profile/profile_screen.dart';
import '../notifications/notification_screen.dart'; // Import màn hình thông báo
import 'task_detail_screen.dart'; 

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // State cho thanh Search & Lọc
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, todo, in_progress, completed

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
      // Load đếm số thông báo chưa đọc
      Provider.of<NotificationProvider>(context, listen: false).fetchUnreadCount();
    });
  }

  // Hàm tạo Chip Filter nhỏ nhỏ xinh xinh
  Widget _buildFilterChip(String label, String filterValue) {
    final isSelected = _selectedFilter == filterValue;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = selected ? filterValue : 'all';
        });
      },
      selectedColor: primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? primaryColor : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  // [THÊM MỚI] Hàm hiển thị Hộp thoại Tạo công việc
  void _showCreateTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedPriority = 'medium';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder( // Dùng StatefulBuilder để thay đổi trạng thái Dropdown trong Dialog
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Thêm công việc mới'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Tiêu đề công việc *'),
                      validator: (val) => val!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Mô tả chi tiết'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: const InputDecoration(labelText: 'Độ ưu tiên'),
                      items: const [
                        DropdownMenuItem(value: 'low', child: Text('Thấp (Màu xanh)')),
                        DropdownMenuItem(value: 'medium', child: Text('Trung bình (Màu cam)')),
                        DropdownMenuItem(value: 'high', child: Text('Cao (Màu đỏ)')),
                      ],
                      onChanged: (val) => setState(() => selectedPriority = val!),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final provider = Provider.of<TaskProvider>(context, listen: false);
                    final success = await provider.createTask(
                      titleController.text,
                      descController.text,
                      selectedPriority,
                    );
                    
                    if (success) {
                      if (!mounted) return;
                      Navigator.pop(ctx); // Đóng hộp thoại
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tạo công việc thành công!')),
                      );
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.error!), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                child: const Text('Tạo mới'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Công việc của tôi'),
        actions: [
          // Cái chuông thông báo
          Consumer<NotificationProvider>(
            builder: (context, notif, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationScreen()),
                      ).then((_) {
                        // Khi từ màn hình thông báo quay lại, update lại số đếm chuông
                        notif.fetchUnreadCount();
                      });
                    },
                  ),
                  if (notif.unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          notif.unreadCount > 99 ? '99+' : '${notif.unreadCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            }
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          )
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (taskProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(taskProvider.error!),
                  TextButton(
                    onPressed: () => taskProvider.loadTasks(),
                    child: const Text('Thử lại'),
                  )
                ],
              ),
            );
          }

          // [THÊM MỚI] Logic Tìm kiếm (Search) & Lọc (Filter) bằng code Dart 
          var filteredTasks = taskProvider.tasks;
          
          if (_searchQuery.isNotEmpty) {
            filteredTasks = filteredTasks.where((t) => 
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
              t.description.toLowerCase().contains(_searchQuery.toLowerCase())
            ).toList();
          }
          
          if (_selectedFilter != 'all') {
            filteredTasks = filteredTasks.where((t) => t.status == _selectedFilter).toList();
          }

          return Column(
            children: [
              // Thanh Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm công việc...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),

              // Dải Chip để Lọc (Filter)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip('Tất cả', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Cần làm', 'todo'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Đang làm', 'in_progress'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Đã xong', 'completed'),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Danh sách
              Expanded(
                child: filteredTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text('Không tìm thấy công việc nào', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => taskProvider.loadTasks(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return TaskCard(
                            task: task,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
                              );
                            },
                          );
                        },
                      ),
                    ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
