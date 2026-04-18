import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/index.dart';
import '../../../core/widgets/index.dart';
import '../controllers/auth_controller.dart';
import '../utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AnimationController _animationController;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agreedToTerms = false;

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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You must agree to the Terms of Service',
            style:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.onError),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authController = context.read<AuthController>();

    try {
      final user = await authController.signup(
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted && user != null) {
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceFirst('Exception: ', ''),
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.onError),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _handleSignInNavigation() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: _handleSignInNavigation,
        ),
      ),
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
                  _buildForm(),
                  SizedBox(height: AppSpacing.lg),

                  // Terms checkbox
                  _buildTermsCheckbox(),
                  SizedBox(height: AppSpacing.xxxl),

                  // Sign Up Button
                  AppButton(
                    label: 'Create Account',
                    variant: AppButtonVariant.filled,
                    size: AppButtonSize.large,
                    isFullWidth: true,
                    isLoading: authController.isLoading,
                    onPressed:
                        authController.isLoading ? null : _handleSignUp,
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Sign In Link
                  _buildSignInPrompt(),
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
              'Create Account',
              style: AppTextStyles.displayLarge,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Join Ideole and start exploring innovative ideas',
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

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Name
          AppInput(
            label: 'First Name',
            hint: 'Enter your first name',
            controller: _firstNameController,
            keyboardType: TextInputType.name,
            validator: AuthValidators.validateName,
          ),
          SizedBox(height: AppSpacing.lg),

          // Last Name
          AppInput(
            label: 'Last Name',
            hint: 'Enter your last name',
            controller: _lastNameController,
            keyboardType: TextInputType.name,
            validator: AuthValidators.validateName,
          ),
          SizedBox(height: AppSpacing.lg),

          // Username
          AppInput(
            label: 'Username',
            hint: 'Choose a unique username',
            controller: _usernameController,
            keyboardType: TextInputType.text,
            validator: AuthValidators.validateUsername,
          ),
          SizedBox(height: AppSpacing.lg),

          // Email
          AppInput(
            label: 'Email Address',
            hint: 'you@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.validateEmail,
          ),
          SizedBox(height: AppSpacing.lg),

          // Password with strength indicator
          AppInput(
            label: 'Password',
            hint: 'Create a strong password',
            obscureText: !_showPassword,
            controller: _passwordController,
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
            validator: AuthValidators.validatePassword,
          ),
          SizedBox(height: AppSpacing.md),

          // Password strength indicator
          _buildPasswordStrengthIndicator(),
          SizedBox(height: AppSpacing.lg),

          // Confirm Password
          AppInput(
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            obscureText: !_showConfirmPassword,
            controller: _confirmPasswordController,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _showConfirmPassword = !_showConfirmPassword;
                });
              },
              child: Icon(
                _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
            ),
            validator: (value) {
              return AuthValidators.validateConfirmPassword(
                value,
                _passwordController.text,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = AuthValidators.validatePasswordStrength(
      _passwordController.text,
    );

    Color barColor = AppColors.outline;
    switch (strength) {
      case PasswordStrength.weak:
        barColor = AppColors.error;
        break;
      case PasswordStrength.fair:
        barColor = AppColors.tertiary;
        break;
      case PasswordStrength.good:
        barColor = AppColors.secondary;
        break;
      case PasswordStrength.strong:
        barColor = AppColors.primary;
        break;
      case PasswordStrength.empty:
        barColor = AppColors.outlineVariant;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Password strength: ',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            Text(
              strength.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: barColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          child: LinearProgressIndicator(
            value: strength.value / 4,
            minHeight: 6,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) {
              setState(() {
                _agreedToTerms = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurface,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInPrompt() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurface,
          ),
          children: [
            const TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Sign in',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              recognizer: (TapGestureRecognizer()
                ..onTap = _handleSignInNavigation),
            ),
          ],
        ),
      ),
    );
  }
}
