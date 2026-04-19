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
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

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
    if (_isSubmitting) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You must agree to the Terms of Service',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onError),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authController = context.read<AuthController>();
    if (authController.isLoading) {
      return;
    }

    _isSubmitting = true;

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
        Navigator.of(context).pop();
      }
    } catch (e) {
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
    } finally {
      _isSubmitting = false;
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
                  SizedBox(height: AppSpacing.xl),

                  // Form
                  _buildForm(authController),
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
                    onPressed: authController.isLoading ? null : _handleSignUp,
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
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.2),
          end: Offset.zero,
        ).animate(animation),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create your account', style: AppTextStyles.displayLarge),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Set up your Ideole profile in under a minute.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.35,
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
          if (authController.error != null) ...[
            _buildErrorBanner(authController.error!),
            SizedBox(height: AppSpacing.lg),
          ],

          AppCard(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  title: 'Personal info',
                  subtitle: 'How people will see you.',
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        label: 'First name',
                        hint: 'First name',
                        controller: _firstNameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: AuthValidators.validateName,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppInput(
                        label: 'Last name',
                        hint: 'Last name',
                        controller: _lastNameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: AuthValidators.validateName,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                AppInput(
                  label: 'Username',
                  hint: 'Choose a username',
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: AuthValidators.validateUsername,
                ),
                SizedBox(height: AppSpacing.md),
                AppInput(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: AuthValidators.validateEmail,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          AppCard(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  title: 'Security',
                  subtitle: 'Keep your account protected.',
                ),
                SizedBox(height: AppSpacing.md),
                AppInput(
                  label: 'Password',
                  hint: 'At least 8 characters',
                  obscureText: true,
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    setState(() {});
                  },
                  validator: AuthValidators.validatePassword,
                ),
                SizedBox(height: AppSpacing.md),
                _buildPasswordStrengthIndicator(),
                SizedBox(height: AppSpacing.md),
                AppInput(
                  label: 'Confirm password',
                  hint: 'Type password again',
                  obscureText: true,
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: _handleSignUp,
                  validator: (value) {
                    return AuthValidators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
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
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
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
              'Strength: ',
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
                    text: 'Terms',
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
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface),
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
