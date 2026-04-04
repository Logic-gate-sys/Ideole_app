# Authentication Feature Documentation

This document provides a comprehensive guide to the Ideole authentication system, including screens, controllers, services, and validation utilities.

## Overview

The auth feature provides complete authentication flows for user registration, login, password reset, and OTP verification. All screens are built with the Material Design 3 theme system and follow the Ideole design specifications.

## Architecture

```
auth/
├── controllers/          # State management (ChangeNotifier)
│   └── auth_controller.dart
├── services/            # API integration
│   └── auth_service.dart
├── screens/             # UI screens
│   ├── sign_in_screen.dart
│   ├── signup_screen.dart
│   ├── forgot_password_screen.dart
│   └── otp_verification_screen.dart
└── utils/               # Utilities
    └── validators.dart
```

## Screens

### 1. Sign In Screen (`sign_in_screen.dart`)

**Purpose:** User login with existing credentials

**Features:**
- Email validation
- Password input with visibility toggle
- "Remember me" checkbox
- Error message display
- Forgot password link
- Social login buttons (Google, Apple - placeholders)
- Sign up navigation
- Slide-in header animation

**Flow:**
1. User enters email and password
2. Form validation via `AuthValidators.validateEmail()` and basic password check
3. `AuthController.login()` is called
4. On success: Navigate to home screen
5. On error: Display error snackbar

**Theme Usage:**
- Colors: `AppColors.primary`, `AppColors.error`, `AppColors.surface`
- Typography: `AppTextStyles.displayLarge`, `AppTextStyles.bodyMedium`
- Spacing: `AppSpacing.lg`, `AppSpacing.xl`, `AppSpacing.xxxl`
- Radius: `AppRadius.md`

### 2. Sign Up Screen (`signup_screen.dart`)

**Purpose:** New user registration

**Features:**
- Full name validation
- Email validation
- Password validation with strength indicator
- Confirm password validation
- Terms of Service checkbox
- Password strength visual feedback (weak/fair/good/strong)
- Animated header

**Validation:**
- Name: 2-50 characters
- Email: Valid email format
- Password: 8+ chars, uppercase, lowercase, number
- Confirm Password: Must match password field

**Flow:**
1. User fills in: name, email, password, confirm password
2. Agrees to terms
3. `AuthController.signup()` is called with credentials
4. On success: Navigate to OTP verification screen
5. User verification completes → Home screen

**Password Strength Levels:**
- **Empty**: No password entered
- **Weak**: Less than 8 characters
- **Fair**: 8+ chars + 2 criteria (uppercase, lowercase, number, special)
- **Good**: 8+ chars + 3 criteria
- **Strong**: 8+ chars + 4 criteria

### 3. Forgot Password Screen (`forgot_password_screen.dart`)

**Purpose:** Initiate password reset process

**Features:**
- Email input validation
- Success state with confirmation message
- Automatic navigation to OTP verification
- Back navigation

**Flow:**
1. User enters email address
2. `AuthValidators.validateEmail()` validates format
3. API call to send reset code
4. Show success state with email confirmation
5. Auto-navigate to OTP verification screen
6. User enters 6-digit OTP
7. User creates new password
8. Success message and return to Sign In

### 4. OTP Verification Screen (`otp_verification_screen.dart`)

**Purpose:** Verify one-time password for account setup or password reset

**Features:**
- 6-digit OTP input fields
- Auto-advance to next field on entry
- Resend code button with countdown timer (60s)
- Error handling
- Support for multiple purposes (password_reset, signup_verification)
- Automatic navigation after verification

**OTP Input:**
- 6 individual text field inputs
- Auto-focus to next field on digit entry
- Auto-focus to previous field on backspace
- Numeric keyboard only

**Resend Logic:**
- 60-second countdown timer
- Resend button disabled during countdown
- Displays remaining seconds
- Shows "Resend Code" when timer expires

**Flow Options:**
1. **Password Reset Flow:**
   - → Reset Password Screen (create new password)
   - → Success message
   - → Return to Sign In

2. **Signup Verification Flow:**
   - → Callback function execution
   - → Navigate to home or previous screen

### 5. Reset Password Screen (`otp_verification_screen.dart` - ResetPasswordScreen class)

**Purpose:** Create new password after OTP verification

**Features:**
- New password input with visibility toggle
- Confirm password input with visibility toggle
- Password validation
- Error handling
- Success confirmation

**Flow:**
1. User enters new password (must meet requirements)
2. Confirms password (must match)
3. Submit to API
4. Show success snackbar
5. Navigate to Sign In screen

## Controllers & Services

### AuthController (`controllers/auth_controller.dart`)

**Type:** ChangeNotifier pattern

**Properties:**
- `isLoading`: bool - Loading state during API calls
- `error`: String? - Current error message
- `user`: User? - Logged-in user data
- `isAuthenticated`: bool - Gets current auth state

**Methods:**
- `login(email, password)`: Future<bool>
- `signup(name, email, password)`: Future<bool>
- `logout()`: Future<void>
- `clearError()`: void

**Usage:**
```dart
final authController = context.read<AuthController>();
final success = await authController.login(email, password);
if (success) {
  // Handle success
}
```

### AuthService (`services/auth_service.dart`)

**Purpose:** API integration for authentication

**Methods:**
- `login(email, password)`: Future<User>
- `signup(name, email, password)`: Future<User>
- `verifyOtp(email, otp)`: Future<bool>
- `resetPassword(email, otp, newPassword)`: Future<bool>
- `resendOtp(email)`: Future<void>

**Token Management:**
- Token is automatically saved to `TokenStorage` on login/signup
- Token is sent in Authorization header for authenticated requests

## Validators (`utils/validators.dart`)

### AuthValidators

**Static Methods:**

1. **validateEmail(value: String?): String?**
   - Checks: Not empty, valid email format
   - Returns: Error message or null if valid

2. **validatePassword(value: String?): String?**
   - Checks: Not empty, 8+ characters, uppercase, lowercase, number
   - Returns: Error message or null if valid

3. **validatePasswordStrength(value: String?): PasswordStrength**
   - Returns enum: empty, weak, fair, good, strong
   - Used for strength indicator UI

4. **validateName(value: String?): String?**
   - Checks: Not empty, 2-50 characters
   - Returns: Error message or null if valid

5. **validateConfirmPassword(value, password): String?**
   - Checks: Not empty, matches password parameter
   - Returns: Error message or null if valid

6. **validateRequired(value, fieldName): String?**
   - Generic validator for any required field
   - Returns: Error message or null if valid

### PasswordStrength Enum

```dart
enum PasswordStrength {
  empty,      // value: 0
  weak,       // value: 1
  fair,       // value: 2
  good,       // value: 3
  strong,     // value: 4
}

// Extensions:
strength.label      // "Empty", "Weak", "Fair", "Good", "Strong"
strength.value      // 0-4 for progress indicators
```

## Theme Integration

All screens use the centralized theme system for consistency:

### Colors Used
- `AppColors.primary` - Primary actions, links (#C2652A)
- `AppColors.error` - Error states and messages
- `AppColors.surface` - Background
- `AppColors.surfaceVariant` - Input backgrounds
- `AppColors.onSurface` - Primary text color
- `AppColors.onSurfaceVariant` - Secondary text, hints
- `AppColors.outlineVariant` - Borders, dividers
- `AppColors.tertiary`, `AppColors.secondary` - Accent colors

### Typography Styles
- `AppTextStyles.displayLarge` - Screen titles
- `AppTextStyles.displayMedium` - Secondary headers
- `AppTextStyles.bodyLarge` - Descriptions
- `AppTextStyles.bodyMedium` - Form labels, body text
- `AppTextStyles.bodySmall` - Helper text, errors
- `AppTextStyles.labelMedium` - Links, buttons

### Spacing (8pt grid)
- `AppSpacing.sm` (4pt) - Small gaps
- `AppSpacing.md` (8pt) - Medium gaps
- `AppSpacing.lg` (16pt) - Large gaps
- `AppSpacing.xl` (24pt) - Extra large
- `AppSpacing.xxxl` (32pt) - Header spacing

### Border Radius
- `AppRadius.xs` (2pt) - Minimal radius
- `AppRadius.md` (12pt) - Default radius
- `AppRadius.lg` (16pt) - Large radius

## Usage Examples

### Navigate to Sign In
```dart
Navigator.of(context).pushReplacementNamed('/auth/signin');
```

### Navigate to Forgot Password
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const ForgotPasswordScreen(),
  ),
);
```

### Access Auth Controller
```dart
final authController = context.read<AuthController>();
final user = authController.user;
final isLoading = authController.isLoading;
```

### Validate Form Input
```dart
final nameError = AuthValidators.validateName(_nameController.text);
final emailError = AuthValidators.validateEmail(_emailController.text);
final passwordError = AuthValidators.validatePassword(_passwordController.text);
final strength = AuthValidators.validatePasswordStrength(_passwordController.text);
```

## Error Handling

All screens handle errors consistently:

1. **Sign In/Sign Up Errors:**
   - Displayed via SnackBar with red background
   - Shows error message from API or validator
   - Allows user to retry

2. **OTP Verification Errors:**
   - Displayed in error container above buttons
   - Shows validation errors
   - Allows user to retry or request new code

3. **Network Errors:**
   - Wrapped in try-catch blocks
   - Generic error message shown to user
   - Exception logged for debugging

## Animation

- Header elements slide in from top with fade
- Uses `AnimationController` with 800ms duration
- `CurvedAnimation` with easeOut curve for natural motion
- Improves perceived performance and UX

## Testing

To test the authentication flow:

1. **Sign Up Flow:**
   - Enter valid name, email, password
   - Verify password strength indicator
   - Check that passwords must match
   - Confirm terms checkbox is required

2. **Sign In Flow:**
   - Use credentials from signup
   - Test "Remember me" checkbox
   - Test forgot password link

3. **Forgot Password Flow:**
   - Enter email
   - Verify OTP code entry
   - Complete password reset

4. **Form Validation:**
   - Test each field with invalid inputs
   - Verify error messages appear
   - Verify form submit is disabled until valid

## Future Enhancements

- [ ] Social login integration (Google, Apple)
- [ ] Biometric authentication (fingerprint, face)
- [ ] User profile picture upload on signup
- [ ] Email verification before password reset
- [ ] Rate limiting for OTP attempts
- [ ] Multi-factor authentication (MFA)
- [ ] Session management and auto-logout
- [ ] Password expiry and forced reset

## Common Issues & Solutions

**Issue:** Form validation not working
- **Solution:** Ensure `FormKey.currentState!.validate()` is called before submission

**Issue:** Password strength indicator not updating
- **Solution:** Call `setState()` in `onChanged` callbacks or use reactive state management

**Issue:** OTP fields not advancing automatically
- **Solution:** Check that `FocusScope.of(context).nextFocus()` is called after digit entry

**Issue:** Navigation not working after signup
- **Solution:** Verify OTP is successfully verified before popping routes

## References

- [Flutter Form Widget](https://api.flutter.dev/flutter/widgets/Form-class.html)
- [Provider State Management](https://pub.dev/packages/provider)
- [Material Design 3 Spec](https://m3.material.io/)
- [Ideole Theme System](../../../core/theme/THEME_README.md)
