import 'package:flutter/material.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController _controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text("Create Account", style: AppTextStyles.heading),
                  const SizedBox(height: 16),
                  Text(
                    "Sign up to start using the app",
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: nameController,
                    hintText: "Full Name",
                    errorText: _controller.error,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    errorText: _controller.error,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                    errorText: _controller.error,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: "Sign Up",
                    isLoading: _controller.isLoading,
                    onPressed: () async {
                      final user = await _controller.signup(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                      );

                      if (user != null) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
