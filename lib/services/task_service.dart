import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class TaskService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Task>> fetchTasks({String? scope}) async {
    final headers = await _getHeaders();
    String url = '${Constants.baseUrl}/tasks';
    if (scope != null) url += '?scope=$scope';

    final response = await http.get(Uri.parse(url), headers: headers);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List tasksData = data['data'] ?? [];
      return tasksData.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception(data['message'] ?? 'Lỗi khi tải danh sách công việc');
    }
  }

  Future<Task> createTask({
    required String title,
    required String description,
    required String priority,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/tasks'),
      headers: headers,
      body: jsonEncode({
        'title': title,
        'description': description,
        'priority': priority,
        'status': 'todo',
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return Task.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Lỗi khi tạo công việc');
    }
  }

  Future<Task> updateTask(String taskId, Map<String, dynamic> updateData) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/tasks/$taskId'),
      headers: headers,
      body: jsonEncode(updateData),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return Task.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Lỗi khi cập nhật công việc');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/tasks/$taskId'),
      headers: headers,
    );

    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Lỗi khi xoá công việc');
    }
  }
}
