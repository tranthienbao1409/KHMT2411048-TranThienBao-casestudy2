import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Biến cờ (flag) để theo dõi xem đang ở bước nào
  bool _isOtpSent = false;

  void _handleSendOtp() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập email')));
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.forgotPassword(_emailController.text.trim());
    
    if (success && mounted) {
      setState(() => _isOtpSent = true); // Đổi UI sang màn nhập OTP
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mã OTP đã được gửi vào email!')));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.error ?? 'Lỗi'), backgroundColor: Colors.red));
    }
  }

  void _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.resetPassword(
        _emailController.text.trim(),
        _otpController.text.trim(),
        _newPasswordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công. Vui lòng đăng nhập lại!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Bay về màn hình đăng nhập
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.error ?? 'Lỗi'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Khôi phục mật khẩu')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  _isOtpSent ? Icons.mark_email_read : Icons.lock_reset, 
                  size: 80, color: primaryColor
                ),
                const SizedBox(height: 24),
                Text(
                  _isOtpSent ? 'Nhập mã OTP' : 'Quên mật khẩu?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  _isOtpSent 
                    ? 'Mã OTP 6 số đã được gửi tới email của bạn.' 
                    : 'Nhập email đã đăng ký để nhận mã xác minh OTP.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),

                // Bước 1: Chỉ nhập Email
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    enabled: !_isOtpSent, // Đã gửi thì khóa ô email lại không cho sửa
                    decoration: InputDecoration(
                      labelText: 'Email của bạn',
                      prefixIcon: Icon(Icons.email, color: primaryColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: _isOtpSent ? Colors.grey.shade100 : Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Bước 2: Nhập OTP và Pass mới (Chỉ hiện khi đã bấm gửi OTP)
                if (_isOtpSent) ...[
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Mã OTP (6 số)',
                        prefixIcon: Icon(Icons.pin, color: primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val!.length != 6 ? 'Mã OTP phải đúng 6 số' : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu mới',
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val!.length < 6 ? 'Tối thiểu 6 ký tự' : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Nút Bấm thay đổi theo trạng thái
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    if (auth.isLoading) {
                      return Center(child: CircularProgressIndicator(color: primaryColor));
                    }
                    return ElevatedButton(
                      onPressed: _isOtpSent ? _handleResetPassword : _handleSendOtp,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isOtpSent ? 'Đặt lại mật khẩu' : 'Gửi mã OTP', style: const TextStyle(fontSize: 18)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
