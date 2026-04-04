import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../controllers/auth_controller.dart';
import '../../../shared/widgets/sahara_text_field.dart';
import '../../../shared/widgets/sahara_buttons.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onSignUpPressed;
  final VoidCallback onSuccess;

  const SignInScreen({
    Key? key,
    required this.onSignUpPressed,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn(AuthController authController) async {
    // Clear previous errors
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Validate inputs
    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return;
    }

    // Attempt login
    final success = await authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        return Scaffold(
          backgroundColor: SaharaColors.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back',
                        style: SaharaTypography.displaySmall.copyWith(
                          color: SaharaColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to your Ideole account',
                        style: SaharaTypography.bodyLarge.copyWith(
                          color: SaharaColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Email field
                  SaharaTextField(
                    label: 'Email Address',
                    hint: 'you@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) {
                      setState(() => _emailError = null);
                    },
                    errorText: _emailError,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 24),

                  // Password field
                  SaharaPasswordField(
                    label: 'Password',
                    controller: _passwordController,
                    onChanged: (_) {
                      setState(() => _passwordError = null);
                    },
                    errorText: _passwordError,
                  ),
                  const SizedBox(height: 16),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextLinkButton(
                      label: 'Forgot password?',
                      onPressed: () {
                        // TODO: Navigate to password reset screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset coming soon'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Error message
                  if (authController.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SaharaColors.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: SaharaColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              authController.errorMessage!,
                              style: SaharaTypography.bodySmall.copyWith(
                                color: SaharaColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (authController.errorMessage != null)
                    const SizedBox(height: 24),

                  // Sign in button
                  PrimaryButton(
                    label: 'Sign In',
                    isLoading: authController.isLoading,
                    onPressed: () => _handleSignIn(authController),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: SaharaColors.outlineVariant,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: SaharaTypography.bodySmall.copyWith(
                            color: SaharaColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: SaharaColors.outlineVariant,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign up prompt
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: SaharaTypography.bodyMedium.copyWith(
                          color: SaharaColors.onSurface,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: TextLinkButton(
                              label: 'Create one',
                              onPressed: widget.onSignUpPressed,
                            ),
                          ),
                        ],
                      ),
                    ),
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
