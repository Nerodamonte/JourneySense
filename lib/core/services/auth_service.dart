import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:5062/api/auth';

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Lưu token vào SharedPreferences với null safety
        final prefs = await SharedPreferences.getInstance();

        // Sử dụng safe access với ?.toString() để tránh lỗi null
        if (data['accessToken'] != null) {
          await prefs.setString('access_token', data['accessToken']);
        }
        if (data['refreshToken'] != null) {
          await prefs.setString('refresh_token', data['refreshToken']);
        }
        if (data['userId'] != null) {
          await prefs.setString('user_id', data['userId'].toString());
        }
        if (data['email'] != null) {
          await prefs.setString('email', data['email']);
        }
        // Role có thể là enum number hoặc string
        if (data['role'] != null) {
          await prefs.setString('user_role', data['role'].toString());
        }

        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('Login Exception: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Send Register OTP
  Future<Map<String, dynamic>> sendRegisterOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'OTP sent successfully',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Verify Register OTP
  Future<Map<String, dynamic>> verifyRegisterOtp(String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Lưu register token vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        if (data['registerToken'] != null) {
          await prefs.setString('register_token', data['registerToken']);
        }

        return {'success': true, 'registerToken': data['registerToken']};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Invalid OTP'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Resend Register OTP
  Future<Map<String, dynamic>> resendRegisterOtp(String email) async {
    return await sendRegisterOtp(email);
  }

  // Set Password
  Future<Map<String, dynamic>> setPassword(
    String password,
    String confirmPassword,
  ) async {
    try {
      // Lấy register token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final registerToken = prefs.getString('register_token');

      if (registerToken == null || registerToken.isEmpty) {
        return {
          'success': false,
          'message': 'Register token not found. Please verify OTP again.',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/register/set-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $registerToken',
        },
        body: jsonEncode({
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Xóa register token sau khi hoàn tất
        await prefs.remove('register_token');

        return {
          'success': true,
          'message': data['message'] ?? 'Password set successfully',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to set password',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Get Access Token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Get Register Token
  Future<String?> getRegisterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('register_token');
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
