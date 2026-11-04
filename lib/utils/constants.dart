import 'dart:io';

class Constants {
  // Máy ảo Android dùng 10.0.2.2, máy ảo iOS dùng 127.0.0.1 để trỏ về localhost
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://127.0.0.1:3000/api';
  }
}
