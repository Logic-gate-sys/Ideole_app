# Flutter Theme Configuration - Setup Guide

## ✅ Completed

The Ideole Flutter theme system is now configured with:

- ✅ **Complete color system** - Material Design 3 semantic colors (10+ color slots)
- ✅ **Typography system** - Eb Garamond (headlines) + Manrope (body/labels)
- ✅ **Spacing constants** - 8pt grid system with semantic naming
- ✅ **Border radius values** - Rounded, adaptive, and specialty radiuses
- ✅ **Shadow/elevation system** - 5 elevation levels + semantic shadows
- ✅ **Dimension constants** - Buttons, avatars, icons, responsive breakpoints
- ✅ **Theme data** - Complete Material 3 theme with all widget styling
- ✅ **Comprehensive documentation** - README, best practices, examples

## 📦 Files Created/Updated

```
lib/core/theme/
├── app_colors.dart          ✨ Material Design 3 color palette
├── app_text_styles.dart     ✨ Typography (headlines, body, labels)
├── app_theme.dart           ✨ Theme data & widget styling
├── app_spacing.dart         ✨ Spacing constants (new)
├── app_radius.dart          ✨ Border radius values (new)
├── app_shadows.dart         ✨ Elevation & shadows (new)
├── app_dimensions.dart      ✨ Sizing constants (new)
├── app_fonts.dart           ✨ Font configuration (new)
├── index.dart               ✨ Barrel exports (new)
├── THEME_README.md          ✨ Complete documentation (new)
└── SETUP_GUIDE.md           ✨ Setup & next steps (new)
```

## 🚀 Next Steps

### 1. Configure Fonts

The theme uses two Google Fonts:
- **Eb Garamond** (Serif, Italic) - Headlines
- **Manrope** (Sans-serif) - Body & Labels

**Option A: Use Google Fonts Package (Recommended)**

Add to `pubspec.yaml`:
```yaml
dependencies:
  google_fonts: ^7.0.0
```

Update `lib/core/theme/app_theme.dart` line 8:
```dart
fontFamily: GoogleFonts.manrope().fontFamily,
```

**Option B: Local Fonts**

Follow instructions in `app_fonts.dart` to download and bundle fonts locally.

### 2. Apply Theme in main.dart

```dart
import 'package:frontend_app/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ideole',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
```

### 3. Test the Theme

Create a test screen:

```dart
import 'package:frontend_app/core/theme/index.dart';

class ThemeShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Showcase'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxl,
          children: [
            // Colors
            Text('Colors', style: AppTextStyles.headlineLarge),
            Row(
              spacing: AppSpacing.lg,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  color: AppColors.primary,
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: AppColors.secondary,
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: AppColors.tertiary,
                ),
              ],
            ),
            
            // Typography
            Text('Typography', style: AppTextStyles.headlineLarge),
            Text('Headline Large', style: AppTextStyles.headlineLarge),
            Text('Body Large', style: AppTextStyles.bodyLarge),
            Text('Label Small', style: AppTextStyles.labelSmall),
            
            // Buttons
            Text('Buttons', style: AppTextStyles.headlineLarge),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            
            // Cards
            Text('Cards', style: AppTextStyles.headlineLarge),
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('Card Content', style: AppTextStyles.titleLarge),
              ),
            ),
            
            // Shadows
            Text('Elevations', style: AppTextStyles.headlineLarge),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.cardRadius,
                boxShadow: AppShadows.elevation2,
              ),
              child: Center(
                child: Text('Elevation 2', style: AppTextStyles.labelLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 4. Import Theme in Widgets

Single import for all theme constants:

```dart
import 'package:frontend_app/core/theme/index.dart';

// Now you can use:
// - AppColors.primary
// - AppTextStyles.headlineLarge
// - AppSpacing.xl
// - AppRadius.cardRadius
// - AppShadows.elevation2
// - AppDimensions.buttonHeightMedium
```

Or specific imports:

```dart
import 'package:frontend_app/core/theme/app_colors.dart';
import 'package:frontend_app/core/theme/app_spacing.dart';
```

## 📊 Color Quick Reference

| Semantic          | Value      | Light           |
|------------------|-----------|-----------------|
| Primary          | #C2652A   | Burnt Orange    |
| Secondary        | #78706A   | Gray-Brown      |
| Tertiary         | #8C3C3C   | Deep Rust       |
| Error            | #C0392B   | Red             |
| Success          | #10B981   | Green           |
| Warning          | #F59E0B   | Amber           |
| Info             | #3B82F6   | Blue            |
| Surface          | #FAF5EE   | Off-white       |
| On Surface       | #3A302A   | Dark Brown      |

## 📏 Spacing Quick Reference

| Variable         | Value | Use Case                  |
|-----------------|-------|---------------------------|
| `xs`            | 2dp   | Micro-spacing             |
| `sm`            | 4dp   | Compact spacing           |
| `md`            | 8dp   | Small gaps                |
| `lg`            | 12dp  | Element gaps              |
| `xl`            | 16dp  | Standard padding          |
| `xxl`           | 24dp  | Section spacing           |
| `xxxl`          | 32dp  | Major spacing             |

## 🔵 Radius Quick Reference

| Variable         | Value   | Use Case              |
|-----------------|---------|----------------------|
| `xs`            | 2dp     | Tags, badges          |
| `sm`            | 4dp     | Chips                 |
| `md`            | 8dp     | Standard containers   |
| `lg`            | 12dp    | Cards, buttons        |
| `xl`            | 16dp    | Large containers      |
| `xxl`           | 24dp    | Bottom sheets         |
| `full`          | 9999dp  | Pills, circles        |

## 🌑 Dark Theme (Future)

Dark theme support is prepared but not fully implemented. To complete:

1. Create dark color variants in `AppColors`
2. Update `AppTheme.darkTheme` with dark colors
3. Use `darkTheme: AppTheme.darkTheme` in MaterialApp

## 📚 File Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart          # 150+ lines
│   │   ├── app_text_styles.dart     # 200+ lines
│   │   ├── app_theme.dart           # 400+ lines
│   │   ├── app_spacing.dart         # 50+ lines (new)
│   │   ├── app_radius.dart          # 80+ lines (new)
│   │   ├── app_shadows.dart         # 150+ lines (new)
│   │   ├── app_dimensions.dart      # 120+ lines (new)
│   │   ├── app_fonts.dart           # 60+ lines (new)
│   │   ├── index.dart               # Exports
│   │   ├── THEME_README.md          # Documentation
│   │   └── SETUP_GUIDE.md           # This file
│   ├── config/
│   ├── constants/
│   ├── services/
│   └── widgets/
```

## 💡 Best Practices

✅ **Always use theme constants**
```dart
// Good
padding: EdgeInsets.all(AppSpacing.xl),
color: AppColors.primary,

// Avoid
padding: EdgeInsets.all(16),
color: Color(0xFFC2652A),
```

✅ **Use semantic naming**
```dart
// Good
padding: EdgeInsets.symmetric(
  horizontal: AppSpacing.screenPadding,
  vertical: AppSpacing.normalPadding,
)

// Avoid
padding: EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xl,
)
```

✅ **Compose text styles**
```dart
// Good
style: AppTextStyles.bodyLarge.copyWith(
  color: AppColors.error,
  fontWeight: FontWeight.bold,
)

// Avoid
style: const TextStyle(
  fontFamily: 'Manrope',
  fontSize: 16,
  color: Color(0xFFC0392B),
  fontWeight: FontWeight.bold,
)
```

## 🔗 Resources

- [Material Design 3 Documentation](https://m3.material.io/)
- [Flutter Material Package](https://api.flutter.dev/flutter/material/material-library.html)
- [Google Fonts Package](https://pub.dev/packages/google_fonts)
- [Ideole Design System](../../../design-system.md)

## ✨ Summary

Your Flutter app now has a **production-ready Material Design 3 theme** that:

- Maintains visual consistency across screens
- Supports responsive design
- Provides typography hierarchy
- Implements semantic color system
- Enables dark mode (when ready)
- Follows Material Design guidelines
- Is fully documented and easy to extend

**Next task**: Build UI components (buttons, cards, input fields, etc.) using these theme constants!

---

**Questions?** See `THEME_README.md` for detailed documentation and examples.
