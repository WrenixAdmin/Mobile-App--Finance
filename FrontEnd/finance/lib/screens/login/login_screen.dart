import 'package:finance/screens/login/register_screen.dart';
import 'package:finance/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:finance/utils/colors.dart'; // Ensure this path is correct
import '../../components/custom_text_filed.dart'; // Import the custom text field widget
import '../../components/custom_button.dart'; // Import the custom button widget

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  style:AppStyles.title,
              ),
              const SizedBox(height: 10),
              const Text(
                'Login now to track all your expenses and income at a place!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                labelText: 'Email',
                hintText: 'Ex: abc@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                labelText: 'Your Password',
                hintText: 'Enter your password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Login',
                onPressed: () {
                  // Handle login logic
                },
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

                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
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