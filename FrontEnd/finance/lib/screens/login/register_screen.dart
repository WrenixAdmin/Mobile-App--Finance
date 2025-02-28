import 'package:finance/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:finance/utils/colors.dart'; // Ensure this path is correct
import '../../components/custom_text_filed.dart'; // Import the custom text field widget
import '../../components/custom_button.dart'; // Import the custom button widget

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                'Register',
                style: AppStyles.title,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              const Text(
                'Register now to track all your expenses and income at a place!',
                style: AppStyles.subtitle,
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
                labelText: 'Your Name',
                hintText: 'Enter your name',
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                labelText: 'Your Password',
                hintText: 'Enter your password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Register',
                onPressed: () {
                  // Handle registration logic
                },
              ),
              const SizedBox(height: 30),
              Text(
                'Already have an account?',
                style: AppStyles.subFooter,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}