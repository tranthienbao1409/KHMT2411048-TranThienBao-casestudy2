import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';
import '../utils/constants.dart';

class NotificationService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<AppNotification>> getNotifications() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('${Constants.baseUrl}/notifications'), headers: headers);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List list = data['data'] ?? [];
      return list.map((e) => AppNotification.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi tải thông báo');
    }
  }

  Future<int> getUnreadCount() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('${Constants.baseUrl}/notifications/unread-count'), headers: headers);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['count'] ?? 0;
    }
    return 0;
  }

  Future<void> markAsRead(String id) async {
    final headers = await _getHeaders();
    await http.patch(Uri.parse('${Constants.baseUrl}/notifications/$id/read'), headers: headers);
  }

  Future<void> markAllAsRead() async {
    final headers = await _getHeaders();
    await http.patch(Uri.parse('${Constants.baseUrl}/notifications/read-all'), headers: headers);
  }
}
