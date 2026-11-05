import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserSelector extends StatefulWidget {
  final String taskId;
  final bool isSharing; // true = Share (cần chọn quyền), false = Assign (Giao việc)

  const UserSelector({super.key, required this.taskId, required this.isSharing});

  @override
  State<UserSelector> createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  final UserService _userService = UserService();
  List<User> _users = [];
  bool _isLoading = false;
  String _selectedPermission = 'viewer'; // Mặc định khi share là viewer

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() => _users = []);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final results = await _userService.searchUsers(query);
      setState(() => _users = results);
    } catch (e) {
      // Bỏ qua lỗi tìm kiếm
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleSelectUser(User user) async {
    try {
      if (widget.isSharing) {
        await _userService.shareTask(widget.taskId, user.id, _selectedPermission);
      } else {
        await _userService.assignTask(widget.taskId, user.id);
      }
      
      if (!mounted) return;
      Navigator.pop(context); // Đóng BottomSheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isSharing ? 'Đã chia sẻ cho ${user.fullName}' : 'Đã giao việc cho ${user.fullName}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isSharing ? 'Chia sẻ công việc' : 'Giao việc cho...',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Tìm tên hoặc email',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            onChanged: _search,
          ),
          if (widget.isSharing) ...[
            const SizedBox(height: 16),
            const Text('Quyền truy cập:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Radio<String>(
                  value: 'viewer',
                  groupValue: _selectedPermission,
                  onChanged: (val) => setState(() => _selectedPermission = val!),
                ),
                const Text('Chỉ xem (Viewer)'),
                const SizedBox(width: 16),
                Radio<String>(
                  value: 'editor',
                  groupValue: _selectedPermission,
                  onChanged: (val) => setState(() => _selectedPermission = val!),
                ),
                const Text('Chỉnh sửa (Editor)'),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text(user.fullName[0].toUpperCase())),
                        title: Text(user.fullName),
                        subtitle: Text(user.email),
                        trailing: ElevatedButton(
                          onPressed: () => _handleSelectUser(user),
                          child: const Text('Chọn'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
