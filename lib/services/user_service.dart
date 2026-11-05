import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class UserService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Tìm kiếm User theo tên hoặc email
  Future<List<User>> searchUsers(String keyword) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/users/search?q=$keyword'),
      headers: headers,
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List usersData = data['data'] ?? [];
      return usersData.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception(data['message'] ?? 'Lỗi khi tìm kiếm người dùng');
    }
  }

  // API Giao việc (Assign)
  Future<void> assignTask(String taskId, String userId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/tasks/$taskId/assignees'),
      headers: headers,
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Lỗi khi giao việc');
    }
  }

  // API Chia sẻ quyền (Share)
  Future<void> shareTask(String taskId, String userId, String permission) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/tasks/$taskId/shares'),
      headers: headers,
      body: jsonEncode({'userId': userId, 'permission': permission}),
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Lỗi khi chia sẻ công việc');
    }
  }
}
