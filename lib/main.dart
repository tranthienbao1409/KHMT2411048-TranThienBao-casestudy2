import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Khai báo bộ màu chuẩn Momo + Beige
    final Color momoPink = const Color(0xFFA50064);
    final Color beigeBackground = const Color(0xFFF9F6F0);

    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: beigeBackground, // Nền mặc định cho mọi màn hình
        colorScheme: ColorScheme.light(
          primary: momoPink,      // Màu chủ đạo cho Appbar, Button...
          secondary: momoPink,    // Màu phụ trợ (FloatingActionButton...)
          background: beigeBackground,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: beigeBackground,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: momoPink),
          titleTextStyle: TextStyle(
            color: momoPink, 
            fontSize: 22, 
            fontWeight: FontWeight.bold
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: momoPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: momoPink,
          ),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
