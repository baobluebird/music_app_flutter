import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInService {
  static Future<Map<String, dynamic>> signIn(String email, String password) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.21:3003/api/user/sign-in'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        // Handle other status codes (e.g., display an error message)
        print('Error: ${response.statusCode}');
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      return {'status': 'error', 'message': 'Network error'};
    }
  }
}

class SignUpService {
  static Future<Map<String, dynamic>> signUp(String name, String email, String password, String confirmPassword) async {
    final Map<String, dynamic> requestBody = {
      "name": name,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.21:3003/api/user/sign-up'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        // Handle other status codes (e.g., display an error message)
        print('Error: ${response.statusCode}');
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      return {'status': 'error', 'message': 'Network error'};
    }
  }
}

class ForgotPasswordService {
  static Future<Map<String, dynamic>> sendEmail(String email) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.21:3003/api/user/forgot-password'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        // Handle other status codes (e.g., display an error message)
        print('Error: ${response.statusCode}');
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      return {'status': 'error', 'message': 'Network error'};
    }
  }
}

class VerifyCodeService {
  static Future<Map<String, dynamic>> verifyCode(String code) async {
    final Map<String, dynamic> requestBody = {
      "code": code,
    };
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.21:3003/api/user/verify-code'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        // Handle other status codes (e.g., display an error message)
        print('Error: ${response.statusCode}');
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      return {'status': 'error', 'message': 'Network error'};
    }
  }
}

class ResetPassService {
  static Future<Map<String, dynamic>> resetPass(String idUser, String password, String confirmPassword) async {
    final Map<String, dynamic> requestBody = {
      "password": password,
      "confirmPassword": confirmPassword,
    };
    var url = 'http://192.168.1.21:3003/api/user/update-pass/$idUser';
    print(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        // Handle other status codes (e.g., display an error message)
        print('Error: ${response.statusCode}');
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      return {'status': 'error', 'message': 'Network error'};
    }
  }
}

class DecodeTokenService {
  static Future<Map<String, dynamic>> decodeToken(String token) async {
    final Map<String, dynamic> requestBody = {
      "token": token,
    };
    var url = 'http://192.168.1.21:3003/api/user/send-token';
    print(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        // Handle other status codes (e.g., display an error message)
        print('Error: ${response.statusCode}');
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      return {'status': 'error', 'message': 'Network error'};
    }
  }
}

class LogoutService {
  static Future<Map<String, dynamic>> logout(String token) async {
    final Map<String, dynamic> requestBody = {
      "token": token,
    };
    var url = 'http://192.168.1.21:3003/api/user/log-out';
    print(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        // Handle other status codes (e.g., display an error message)
        print('Error: ${response.statusCode}');
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      return {'status': 'error', 'message': 'Network error'};
    }
  }
}
