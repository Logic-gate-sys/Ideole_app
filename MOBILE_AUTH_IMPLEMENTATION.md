# Auth Feature - Implementation Guide

**Status**: ✅ Complete  
**Date**: April 4, 2026  
**Screens**: Sign In, Sign Up  
**API Integration**: Full (login, register)

---

## Architecture Overview

The Auth feature follows a **modular, layered architecture**:

```
Screens (UI)
    ↓ Consumer<AuthController>
Controllers (State Management)
    ↓ Uses
Services (Business Logic - API calls, validation)
    ↓ Uses
Models (Data structures)
    ↓ Uses
Utilities (API client, Storage)
```

---

## File Structure

```
lib/
├── models/
│   ├── user.dart              # User model
│   └── auth.dart              # Auth response, exceptions
├── services/
│   ├── api_service.dart       # HTTP client
│   ├── auth_service.dart      # Auth business logic
│   └── storage_service.dart   # Local storage (tokens, user)
├── shared/widgets/
│   ├── sahara_buttons.dart    # Button components
│   └── sahara_text_field.dart # Text input components
└── features/auth/
    ├── controllers/
    │   └── auth_controller.dart  # State management (ChangeNotifier)
    └── screens/
        ├── auth_screen.dart      # Auth wrapper (toggles Sign In/Up)
        ├── sign_in_screen.dart   # Sign in form
        └── sign_up_screen.dart   # Sign up form
```

---

## Component Breakdown

### **1. Models** (`models/`)

#### `user.dart` - User Model
Represents a user profile:
- Properties: id, email, name, bio, location, avatarUrl, role, timestamps
- Methods: `fromJson()`, `toJson()`, `copyWith()`
- Used in: Auth responses, profile screens

#### `auth.dart` - Auth Models
- `AuthResponse`: JWT tokens + user profile from backend
- `AuthException`: Custom exception for auth errors
- `ValidationException`: Custom exception for form validation errors

### **2. Services** (`services/`)

#### `api_service.dart` - HTTP Client
**Responsibility**: Handle all HTTP communication
**Methods**:
- `get(endpoint, token?, queryParams?)` → `Future<Map<String, dynamic>>`
- `post(endpoint, body, token?)` → `Future<Map<String, dynamic>>`
- `put(endpoint, body, token)` → `Future<Map<String, dynamic>>`
- `delete(endpoint, token)` → `Future<Map<String, dynamic>>`

**Features**:
- Centralized base URL (`http://localhost:3000/api`)
- Automatic token injection in Authorization header
- Error handling with status code mapping
- Timeout handling (30 seconds)
- Network error handling

**Example Usage**:
```dart
final response = await ApiService.post(
  '/auth/login',
  body: {'email': 'user@example.com', 'password': 'password123'},
);
```

#### `auth_service.dart` - Auth Business Logic
**Responsibility**: Authentication operations with validation
**Methods**:
- `register()` → Validates input + calls API + saves tokens
- `login()` → Validates email/password + calls API + saves tokens
- `refreshToken()` → Refresh expired JWT token
- `logout()` → Calls logout API + clears local data
- `getCurrentUser()` → Get cached user from storage
- `isAuthenticated()` → Check if tokens exist
- `getAccessToken()` → Get current access token

**Validation**:
- Email format validation
- Password strength: min 6 chars, 1 uppercase, 1 number
- Password confirmation match
- Required field checks

**Flow**:
```
register/login input
  ↓ Client-side Zod-style validation
  ↓ If valid: Call ApiService
  ↓ If success: Save tokens + user to StorageService
  ↓ Return AuthResponse
  ↓ If error: Throw ValidationException or AuthException
```

#### `storage_service.dart` - Local Storage
**Responsibility**: Persistent storage of tokens and user data
**Uses**: SharedPreferences
**Methods**:
- `init()` → Initialize SharedPreferences (call on app start)
- `saveTokens(accessToken, refreshToken)` → Store tokens
- `getAccessToken()` → Retrieve access token
- `getRefreshToken()` → Retrieve refresh token
- `saveUser(user)` → Cache user profile
- `getCachedUser()` → Retrieve cached user
- `isAuthenticated()` → Check if logged in
- `clearAuth()` → Remove tokens and user
- `clearAll()` → Clear all app data

**Singleton Pattern**: Only one instance exists (`StorageService()`)

**Data Stored**:
```
access_token      → JWT token for API requests
refresh_token     → Token for refreshing access token
user_data         → JSON-encoded User object
user_id           → User's ID for quick lookup
```

### **3. Reusable Components** (`shared/widgets/`)

#### `sahara_text_field.dart`
**SaharaTextField**: Text input following Sahara design
- Props: label, hint, controller, onChanged, validator, keyboardType, maxLines, obscureText, prefixIcon, suffixIcon, errorText
- Features:
  - Focus state styling (color change on focus)
  - Error state with red border + message
  - Label above field
  - Optional prefix/suffix icons
  - Uses Sahara colors and typography

**SaharaPasswordField**: Password-specific input
- Extends SaharaTextField
- Show/hide password toggle button
- Masked by default

#### `sahara_buttons.dart`
**PrimaryButton**: Filled button (primary action)
- Props: label, onPressed, isLoading, isEnabled, width, padding
- Features:
  - Terracotta (#C2652A) background
  - Shows spinner while loading
  - Disables when isLoading or isEnabled=false
  - Full width by default

**SecondaryButton**: Outlined button (secondary action)
- Props: label, onPressed, isLoading, isEnabled, width, padding
- Features:
  - Outlined style with border
  - Same loading/enabled behavior as Primary

**TextLinkButton**: Text-only with underline (low priority)
- Props: label, onPressed, isEnabled
- Features:
  - No background, no border
  - Primary color text with underline on hover
  - Used for "Forgot password?", "Sign in/up" links

### **4. Controllers** (`features/auth/controllers/`)

#### `auth_controller.dart` - State Management
**Pattern**: ChangeNotifier (Provider pattern)
**Responsibility**: Manage auth state and coordinate between UI and services

**State Variables**:
```dart
User? _user;                      // Current authenticated user
bool _isLoading;                   // Loading state for async operations
String? _errorMessage;             // Error message to display
bool _isAuthenticated;             // Is user logged in
```

**Getters**: user, isLoading, errorMessage, isAuthenticated

**Methods**:
- `init()` → Initialize on app launch (check cached login)
- `register()` → Call AuthService.register() + update state
- `login()` → Call AuthService.login() + update state
- `logout()` → Call AuthService.logout() + clear state
- `refreshToken()` → Refresh JWT token
- `clearError()` → Clear error message

**State Flow**:
```
User taps "Sign In"
  ↓ [authController.login(email, password)]
  ↓ _isLoading = true; notifyListeners()  // UI shows spinner
  ↓ [AuthService.login()] → [ApiService.post()] → [StorageService.saveTokens()]
  ↓ _user = response.user; _isAuthenticated = true
  ↓ _isLoading = false; notifyListeners()  // UI updates, spinner disappears
  ↓ Parent widget detects isAuthenticated changed
  ↓ Navigate to MainApp (Feed screen)
```

**Error Handling**:
- Catches ValidationException → shows validation message
- Catches Exception → shows friendly error message
- Error messages: "Invalid email or password", "No internet connection", etc.

### **5. Screens** (`features/auth/screens/`)

#### `auth_screen.dart` - Auth Wrapper
**Purpose**: Toggle between Sign In and Sign Up
**Props**: onAuthSuccess callback
**Internal State**:
- `_showSignIn: bool` → Controls which screen to show
- `_toggleAuthMode()` → Switch between Sign In and Sign Up

#### `sign_in_screen.dart` - Sign In Form
**Purpose**: Authenticate existing user
**Props**: 
- `onSignUpPressed` → Navigate to Sign Up
- `onSuccess` → Called after successful login

**Fields**:
- Email (validated format)
- Password (hidden)
- "Forgot password?" link (TODO)

**Form Validation** (local):
- Email required + format check
- Password required

**API Integration**:
```
User fills email + password
  ↓ Validation (local)
  ↓ [authController.login(email, password)]
  ↓ Display loading spinner
  ↓ API POST /api/auth/login
  ↓ On success: Call onSuccess() → parent navigates to MainApp
  ↓ On error: Show error message in red box
```

**UI Features**:
- Responsive layout (scrollable for small screens)
- Error messages displayed in red container
- Loading indicator on button
- Toggle to Sign Up screen

#### `sign_up_screen.dart` - Sign Up Form
**Purpose**: Register new user account
**Props**: 
- `onSignInPressed` → Navigate to Sign In
- `onSuccess` → Called after successful registration

**Fields**:
- Full Name (required)
- Email (required, validated format)
- Password (required, validated strength: 6+ chars, 1 uppercase, 1 number)
- Confirm Password (must match)
- Bio (optional)

**Form Validation** (local):
- All required fields checked
- Password strength checked (6+ chars, uppercase, number)
- Password confirmation match
- Terms agreement checkbox required

**API Integration**:
```
User fills form + agrees to terms
  ↓ Validation (local)
  ↓ [authController.register(...)]
  ↓ Display loading spinner
  ↓ API POST /api/auth/register
  ↓ On success: Call onSuccess() → parent navigates to MainApp
  ↓ On error: Show error (e.g., "Email already exists")
```

**UI Features**:
- Helper text for password requirements
- Bio field is multiline textarea
- Terms agreement checkbox with links
- Error messages inline above fields
- Transitions to Sign In form

---

## API Integration

### **Endpoints Used**

#### POST /api/auth/register
**Request**:
```json
{
  "email": "user@example.com",
  "password": "Password123",
  "name": "John Doe",
  "bio": "Optional bio text"
}
```

**Response** (200 OK):
```json
{
  "accessToken": "jwt_token_here",
  "refreshToken": "refresh_token_here",
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "name": "John Doe",
    "bio": "Optional bio text",
    "role": "user",
    "createdAt": "2026-04-04T...",
    "updatedAt": "2026-04-04T..."
  }
}
```

#### POST /api/auth/login
**Request**:
```json
{
  "email": "user@example.com",
  "password": "Password123"
}
```

**Response** (200 OK): Same as register

#### POST /api/auth/refresh
**Request**:
```json
{
  "refreshToken": "refresh_token_here"
}
```

**Response** (200 OK):
```json
{
  "accessToken": "new_jwt_token",
  "refreshToken": "new_refresh_token_or_same"
}
```

#### POST /api/auth/logout
**Request**: Empty body (token in header)
**Response** (200 OK):
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

### **Error Handling**

| Status | Error | Handled By |
|--------|-------|-----------|
| 400 | Validation error | AuthService validation + API response |
| 401 | Invalid credentials | ApiService catches → "Invalid email or password" |
| 409 | Email conflict | "Email already registered" |
| 500 | Server error | "Server error: ..." |

---

## How It All Works Together: Sign In Flow

```
┌─ App Starts ──────────────────────────────┐
│                                           │
│ 1. [StorageService.init()]                │
│    └─ Load SharedPreferences              │
│                                           │
│ 2. [AuthController.init()]                │
│    └─ Check if tokens exist               │
│    └─ Load cached user                    │
│                                           │
│ 3. If authenticated → Show MainApp        │
│    Else → Show AuthScreen                 │
│                                           │
└─────────────────────────────────────────┘
        ↓
┌─ User Sees SignInScreen ──────────────────┐
│                                           │
│ User enters: email, password              │
│ Taps "Sign In" button → _handleSignIn()   │
│                                           │
│ 1. Validate inputs (email/password exist) │
│ 2. Call [authController.login()]          │
│    └─ Sets _isLoading = true              │
│    └─ Calls [authService.login()]         │
│ 3. AuthService validates:                 │
│    └─ Email format valid                  │
│    └─ Password not empty                  │
│ 4. AuthService calls [apiService.post()]  │
│    └─ POST /api/auth/login                │
│    └─ Body: {email, password}             │
│ 5. Backend validates + returns tokens     │
│ 6. AuthService calls [storageService]     │
│    └─ Save access token                   │
│    └─ Save refresh token                  │
│    └─ Save user data                      │
│ 7. AuthController updates state:          │
│    └─ _user = response.user               │
│    └─ _isAuthenticated = true             │
│    └─ _isLoading = false                  │
│    └─ notifyListeners()                   │
│ 8. UI rebuilds (spinner removed)          │
│ 9. Consumer detects isAuthenticated       │
│    └─ Calls widget.onSuccess()            │
│ 10. Parent navigates to MainApp           │
│                                           │
└─────────────────────────────────────────┘
```

---

## Sign Up Flow (differs at token saving)

```
User fills Sign Up form
  ↓
Validates all fields locally
  ↓
[authController.register(email, password, name, bio)]
  ↓
[authService.register()]
  ↓
[apiService.post] → POST /api/auth/register
  ↓
Get response: {accessToken, refreshToken, user}
  ↓
[storageService.saveTokens] + [storageService.saveUser]
  ↓
Update controller state
  ↓
Navigate to MainApp (same as Sign In flow)
```

---

## Implementation Checklist

✅ **Models**:
- [x] User model with fromJson/toJson
- [x] AuthResponse model
- [x] Custom exceptions (AuthException, ValidationException)

✅ **Services**:
- [x] ApiService (HTTP client with error handling)
- [x] StorageService (SharedPreferences wrapper, singleton)
- [x] AuthService (register, login, logout, validation)

✅ **Components**:
- [x] SaharaTextField (text input with focus states)
- [x] SaharaPasswordField (password input with show/hide)
- [x] PrimaryButton (filled button)
- [x] SecondaryButton (outlined button)
- [x] TextLinkButton (text-only button)

✅ **State Management**:
- [x] AuthController (ChangeNotifier with register, login, logout, error handling)

✅ **Screens**:
- [x] AuthScreen (wrapper that toggles between Sign In/Up)
- [x] SignInScreen (email/password form)
- [x] SignUpScreen (full registration form)

---

## Next Steps: Integration with Main App

To use Auth in your main app.dart:

```dart
import 'package:provider/provider.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/screens/auth_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  await StorageService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _authController.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>.value(
      value: _authController,
      child: MaterialApp(
        home: Consumer<AuthController>(
          builder: (context, authController, _) {
            // Show Auth or MainApp based on authentication state
            if (authController.isAuthenticated) {
              return MainApp();  // Your bottom tab navigation
            } else {
              return AuthScreen(
                onAuthSuccess: () {
                  // Already navigated by controller
                  // Just ensure UI reflects authenticated state
                },
              );
            }
          },
        ),
      ),
    );
  }
}
```

---

## Testing Locally

**Update ApiService base URL** in `services/api_service.dart`:
```dart
// For local backend
static const String baseUrl = 'http://localhost:3000/api';

// For emulator/device testing
static const String baseUrl = 'http://10.0.2.2:3000/api';  // Android emulator
// or
static const String baseUrl = 'http://localhost:3000/api';  // iOS simulator
```

**Test Registration**:
1. Tap "Create Account" on Sign In screen
2. Fill: Name, Email (unique), Password (6+, uppercase, number), Confirm
3. Agree to terms
4. Tap "Create Account"
5. Should navigate to Feed screen

**Test Login**:
1. Go back to Sign In (tap "Sign in" link)
2. Fill: Email (your registered email), Password
3. Tap "Sign In"
4. Should navigate to Feed screen

**Test Logout** (once Feed is implemented):
1. In Settings screen (Profile tab)
2. Tap "Logout"
3. Should return to Sign In screen

---

## Error Scenarios Handled

1. **Network Error** → "No internet connection. Check your network."
2. **Invalid Email** → "Invalid email format"
3. **Weak Password** → "Password must be at least 6 characters with 1 uppercase and 1 number"
4. **Password Mismatch** → "Passwords do not match"
5. **Wrong Credentials** → "Invalid email or password"
6. **Email Already Exists** → "Email already registered. Please sign in instead."
7. **Request Timeout** → "Request timed out. Please try again."
8. **Server Error** → "Server error: [message from backend]"

---

## Architecture Benefits

✅ **Modularity**: Each layer (services, controllers, screens) is independent  
✅ **Reusability**: Buttons, text fields used across screens  
✅ **Testability**: Services can be unit tested without UI  
✅ **Maintainability**: Changes to API only affect ApiService  
✅ **Scalability**: Easy to add password reset, 2FA, OAuth later  
✅ **Error Handling**: Comprehensive error catching and user-friendly messages  
✅ **State Persistence**: Tokens saved locally, auto-login on app restart  
✅ **Clean Code**: Separation of concerns, single responsibility principle  

---

This is a production-ready auth system that integrates seamlessly with your Ideole backend! 🎉
