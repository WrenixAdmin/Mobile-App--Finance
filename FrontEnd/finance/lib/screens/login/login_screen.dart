import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../home/home_screen.dart';
import 'register_screen.dart';
import '../../components/custom_text_filed.dart';
import '../../components/custom_button.dart';
import 'package:finance/utils/style.dart';
import '../../service/auth_service.dart';
import '../../config/api_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(ApiConfig.loginUrl);
    final body = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Save auth data
          await AuthService.saveAuthData(
            data['data']['token'],
            data['data']['email'],
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
          _navigateToHome();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Login failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Login',
                style: AppStyles.title,
              ),
              const SizedBox(height: 10),
              const Text(
                'Login now to track all your expenses and income at a place!',
                style: AppStyles.subtitle,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Ex: abc@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Your Password',
                hintText: 'Enter your password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: 'Login',
                      onPressed: _loginUser,
                    ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Continue with Google'),
                onPressed: () {
                  // Handle Google login logic
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}