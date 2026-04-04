import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../controllers/auth_controller.dart';
import '../../../shared/widgets/sahara_text_field.dart';
import '../../../shared/widgets/sahara_buttons.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onSignInPressed;
  final VoidCallback onSuccess;

  const SignUpScreen({
    Key? key,
    required this.onSignInPressed,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp(AuthController authController) async {
    // Clear previous errors
    setState(() {
      _firstNameError = null;
      _lastNameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Validate inputs
    if (_firstNameController.text.isEmpty) {
      setState(() => _firstNameError = 'First name is required');
      return;
    }

    if (_lastNameController.text.isEmpty) {
      setState(() => _lastNameError = 'Last name is required');
      return;
    }

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return;
    }

    if (_passwordController.text.length < 8) {
      setState(
        () => _passwordError = 'Password must be at least 8 characters',
      );
      return;
    }

    if (!RegExp(r'[A-Z]').hasMatch(_passwordController.text)) {
      setState(
        () =>
            _passwordError = 'Password must contain at least one uppercase letter',
      );
      return;
    }

    if (!RegExp(r'[0-9]').hasMatch(_passwordController.text)) {
      setState(
        () => _passwordError = 'Password must contain at least one number',
      );
      return;
    }

    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() =>
          _confirmPasswordError = 'Passwords do not match');
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
        ),
      );
      return;
    }

    // Attempt registration
    final success = await authController.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
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
                        'Create Account',
                        style: SaharaTypography.displaySmall.copyWith(
                          color: SaharaColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join Ideole to share your vision',
                        style: SaharaTypography.bodyLarge.copyWith(
                          color: SaharaColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // First name field
                  SaharaTextField(
                    label: 'First Name',
                    hint: 'John',
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    onChanged: (_) {
                      setState(() => _firstNameError = null);
                    },
                    errorText: _firstNameError,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 16),

                  // Last name field
                  SaharaTextField(
                    label: 'Last Name',
                    hint: 'Doe',
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    onChanged: (_) {
                      setState(() => _lastNameError = null);
                    },
                    errorText: _lastNameError,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 24),

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
                  const SizedBox(height: 8),
                  Text(
                    'At least 8 characters, 1 uppercase letter, and 1 number',
                    style: SaharaTypography.bodySmall.copyWith(
                      color: SaharaColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm password field
                  SaharaPasswordField(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    onChanged: (_) {
                      setState(() => _confirmPasswordError = null);
                    },
                    errorText: _confirmPasswordError,
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

                  // Terms agreement checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                        activeColor: SaharaColors.primary,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: SaharaTypography.bodySmall.copyWith(
                              color: SaharaColors.onSurface,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: SaharaTypography.bodySmall.copyWith(
                                  color: SaharaColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: SaharaTypography.bodySmall.copyWith(
                                  color: SaharaColors.onSurface,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: SaharaTypography.bodySmall.copyWith(
                                  color: SaharaColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Sign up button
                  PrimaryButton(
                    label: 'Create Account',
                    isLoading: authController.isLoading,
                    onPressed: () => _handleSignUp(authController),
                  ),
                  const SizedBox(height: 24),

                  // Sign in prompt
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: SaharaTypography.bodyMedium.copyWith(
                          color: SaharaColors.onSurface,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: TextLinkButton(
                              label: 'Sign in',
                              onPressed: widget.onSignInPressed,
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
