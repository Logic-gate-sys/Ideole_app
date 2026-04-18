import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/index.dart';
import '../../../core/widgets/index.dart';
import '../controllers/auth_controller.dart';
import '../utils/validators.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authController = context.read<AuthController>();

    try {
      final user = await authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted && user != null) {
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      // Error is handled by controller
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceFirst('Exception: ', ''),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onError,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _handleSignUpNavigation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Consumer<AuthController>(
            builder: (context, authController, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with animation
                  _buildHeader(),
                  SizedBox(height: AppSpacing.xxxl),

                  // Form
                  _buildForm(authController),
                  SizedBox(height: AppSpacing.xxxl),

                  // Sign In Button
                  AppButton(
                    label: 'Sign In',
                    variant: AppButtonVariant.filled,
                    size: AppButtonSize.large,
                    isFullWidth: true,
                    isLoading: authController.isLoading,
                    onPressed:
                        authController.isLoading ? null : _handleSignIn,
                  ),
                  SizedBox(height: AppSpacing.xxxl),

                  // Sign Up Link
                  _buildSignUpPrompt(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: Opacity(
        opacity: _animationController.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: AppTextStyles.displayLarge.copyWith(
                height: 1.2,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Sign in to your Ideole account to continue exploring and collaborating',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(AuthController authController) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error message display
          if (authController.error != null) ...[
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      authController.error!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
          ],

          // Email field
          AppInput(
            label: 'Email Address',
            hint: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: AuthValidators.validateEmail,
          ),
          SizedBox(height: AppSpacing.lg),

          // Password field with toggle
          AppInput(
            label: 'Password',
            hint: 'Enter your password',
            obscureText: !_showPassword,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurface,
          ),
          children: [
            const TextSpan(text: 'Don\'t have an account? '),
            TextSpan(
              text: 'Sign up',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              recognizer: (TapGestureRecognizer()
                ..onTap = _handleSignUpNavigation),
            ),
          ],
        ),
      ),
    );
  }
}
