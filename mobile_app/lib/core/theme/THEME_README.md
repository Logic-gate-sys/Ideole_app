# Ideole Design System - Flutter Theme Configuration

Complete Material Design 3 theme configuration matching the Ideole design system with warm earthy tones and elegant typography.

## 📋 Overview

The Ideole theme system is organized into modular files, each handling a specific aspect of the design:

- **app_colors.dart** - Complete Material Design 3 color palette
- **app_text_styles.dart** - Typography system (headlines, body, labels)
- **app_theme.dart** - Theme data and widget styling
- **app_spacing.dart** - Consistent spacing/padding constants
- **app_radius.dart** - Border radius values
- **app_shadows.dart** - Elevation and shadow effects
- **app_dimensions.dart** - Common sizing (buttons, avatars, etc.)

## 🎨 Color System

The palette is based on the Material Design 3 semantic color system with warm, earthy tones:

### Primary Colors
- **Primary**: `#C2652A` (Burnt Orange) - Main brand color
- **On Primary**: `#FFFFFF` (White) - Text on primary
- **Primary Container**: `#E08850` - Lighter variant
- **On Primary Container**: `#FBE8D8` - Text on container

### Secondary Colors  
- **Secondary**: `#78706A` (Warm Gray-Brown)
- **On Secondary**: `#FFFFFF`
- **Secondary Container**: `#EAE2DA`

### Tertiary Colors
- **Tertiary**: `#8C3C3C` (Deep Rust)
- **On Tertiary**: `#FFFFFF`
- **Tertiary Container**: `#D47070`

### Neutral Colors
- **Surface**: `#FAF5EE` (Off-white with warm tone)
- **On Surface**: `#3A302A` (Dark Brown)
- **Surface Variant**: `#ECE6DC` (Light Beige)

### Semantic Colors
- **Error**: `#C0392B` (Deep Red)
- **Success**: `#10B981` (Green)
- **Warning**: `#F59E0B` (Amber)
- **Info**: `#3B82F6` (Blue)

### Usage

```dart
import 'package:frontend_app/core/theme/app_colors.dart';

// Use color constants
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.onPrimary),
  ),
)
```

## 🔤 Typography

### Font Families
- **Headlines**: Eb Garamond (serif, italic) for elegant emphasis
- **Body & Labels**: Manrope (sans-serif) for readability

### Text Styles

#### Headings
- **Display Large**: 57sp, italic (page titles)
- **Display Medium**: 45sp, italic
- **Display Small**: 36sp, italic
- **Headline Large**: 32sp, bold, italic
- **Headline Medium**: 28sp, bold, italic
- **Headline Small**: 24sp, bold, italic

#### Body Text
- **Body Large**: 16sp (main content)
- **Body Medium**: 14sp (secondary content)
- **Body Small**: 12sp (tertiary content)

#### Labels
- **Label Large**: 14sp (buttons, chips)
- **Label Medium**: 12sp
- **Label Small**: 11sp (captions)

### Usage

```dart
import 'package:frontend_app/core/theme/app_text_styles.dart';

// Use predefined text styles
Text(
  'Section Title',
  style: AppTextStyles.headlineMedium,
)

// Modify existing styles
Text(
  'Custom Text',
  style: AppTextStyles.bodyLarge.copyWith(
    color: Colors.red,
    fontWeight: FontWeight.bold,
  ),
)

// Use convenience methods
Text(
  'Emphasized',
  style: AppTextStyles.bold(AppTextStyles.bodyMedium),
)
```

## 📐 Spacing

Consistent spacing system based on 8pt grid:

- **xs**: 2dp (micro spacing)
- **sm**: 4dp
- **md**: 8dp
- **lg**: 12dp
- **xl**: 16dp (standard)
- **xxl**: 24dp
- **xxxl**: 32dp
- **huge**: 48dp
- **giant**: 64dp

### Semantic Spacing
- `screenPadding` - Screen edge padding (16dp)
- `sectionGap` - Between major sections (24dp)
- `elementGap` - Between elements (12dp)
- `cardPaddingMedium` - Card internal padding (16dp)

### Usage

```dart
import 'package:frontend_app/core/theme/app_spacing.dart';

Padding(
  padding: EdgeInsets.all(AppSpacing.xl),
  child: Column(
    spacing: AppSpacing.lg,
    children: [
      // List items with consistent gaps
    ],
  ),
)
```

## 🔵 Border Radius

Material Design 3 compliant corner radius values:

- **xs**: 2dp (small tags, input borders)
- **sm**: 4dp (chips, badges)
- **md**: 8dp (standard containers)
- **lg**: 12dp (cards, buttons)
- **xl**: 16dp (dialogs, large containers)
- **xxl**: 24dp (bottom sheets, hero sections)
- **full**: 9999dp (pills, circles)

### Usage

```dart
import 'package:frontend_app/core/theme/app_radius.dart';

Container(
  decoration: BoxDecoration(
    borderRadius: AppRadius.cardRadius,
    color: Colors.white,
  ),
)

// Use specific values
ClipRRect(
  borderRadius: AppRadius.topRadius,
  child: Image.network(url),
)
```

## 🌑 Shadows & Elevation

Material Design 3 elevation system with 5 levels:

- **elevation0**: No shadow (flat)
- **elevation1**: Subtle (smallest elements)
- **elevation2**: Light (cards, chips)
- **elevation3**: Medium (standard containers)
- **elevation4**: High (floating elements, FAB)
- **elevation5**: Very high (modals, dialogs)

### Semantic Shadows
- `cardShadow` - For cards (elevation2)
- `fabShadow` - For FAB (elevation4)
- `modalShadow` - For modals (elevation5)
- `bottomSheetShadow` - For bottom sheets
- `navBarShadow` - For bottom nav bar
- `primaryShadow` - Colored shadow (primary)
- `errorShadow` - Colored shadow (error)

### Usage

```dart
import 'package:frontend_app/core/theme/app_shadows.dart';

Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: AppShadows.cardShadow,
  ),
)

// Elevated card
Card(
  elevation: 4,
  shadowColor: Colors.transparent,
  child: Container(
    decoration: BoxDecoration(
      boxShadow: AppShadows.elevation4,
    ),
  ),
)
```

## 📏 Dimensions

Common sizing constants for UI components:

### Icons
- `iconSm`: 20dp
- `iconMd`: 24dp (standard)
- `iconLg`: 28dp
- `iconXl`: 32dp

### Avatars
- `avatarSm`: 36dp
- `avatarMd`: 48dp (standard)
- `avatarLg`: 64dp

### Buttons
- `buttonHeightSmall`: 32dp
- `buttonHeightMedium`: 40dp
- `buttonHeightLarge`: 48dp
- `buttonHeightXl`: 56dp

### Input Fields
- `inputHeightSmall`: 36dp
- `inputHeightMedium`: 48dp (standard)
- `inputHeightLarge`: 56dp

### Responsive Breakpoints
- Mobile: max 600dp
- Tablet: 600-960dp
- Desktop: 960dp+

### Usage

```dart
import 'package:frontend_app/core/theme/app_dimensions.dart';

// Button with standard height
ElevatedButton(
  onPressed: () {},
  child: Container(
    height: AppDimensions.buttonHeightMedium,
    child: const Text('Click Me'),
  ),
)

// Avatar with standard size
CircleAvatar(
  radius: AppDimensions.avatarMd / 2,
  backgroundImage: NetworkImage(imageUrl),
)

// Responsive grid
GridView(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: MediaQuery.of(context).size.width > 
        AppDimensions.tabletMinWidth ? 3 : 2,
  ),
)
```

## 🎯 Theme Application

Apply the theme in your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:frontend_app/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ideole',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Add when ready
      home: const HomePage(),
    );
  }
}
```

## 🚀 Quick Start Guide

### Import All Theme Constants

```dart
// Single import for everything
import 'package:frontend_app/core/theme/index.dart';

// Or specific imports
import 'package:frontend_app/core/theme/app_colors.dart';
import 'package:frontend_app/core/theme/app_spacing.dart';
import 'package:frontend_app/core/theme/app_radius.dart';
```

### Build a Card Component

```dart
Card(
  elevation: 0,
  color: AppColors.surface,
  shape: RoundedRectangleBorder(
    borderRadius: AppRadius.cardRadius,
    side: BorderSide(color: AppColors.outlineVariant),
  ),
  child: Container(
    decoration: BoxDecoration(
      boxShadow: AppShadows.elevation2,
    ),
    padding: EdgeInsets.all(AppSpacing.xl),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.lg,
      children: [
        Text(
          'Card Title',
          style: AppTextStyles.headlineSmall,
        ),
        Text(
          'Card content goes here',
          style: AppTextStyles.bodyMedium,
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action'),
        ),
      ],
    ),
  ),
)
```

### Build a Button Component

```dart
SizedBox(
  height: AppDimensions.buttonHeightMedium,
  width: double.infinity,
  child: ElevatedButton(
    onPressed: onPressed,
    child: Text(
      'Button Label',
      style: AppTextStyles.labelLarge.copyWith(
        color: AppColors.onPrimary,
      ),
    ),
  ),
)
```

### Create Custom Colors

```dart
// Light variant
Container(
  color: AppColors.primaryFixed,
  padding: EdgeInsets.all(AppSpacing.xl),
)

// With opacity
Container(
  color: AppColors.primary.withOpacity(0.1),
)

// Text color combinations
Text(
  'Subtle text',
  style: TextStyle(color: AppColors.onSurfaceVariant),
)
```

## 📱 Responsive Design

The theme supports responsive layouts:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final columns = constraints.maxWidth > AppDimensions.tabletMinWidth ? 3 : 2;
    return GridView.count(
      crossAxisCount: columns,
      mainAxisSpacing: AppSpacing.xl,
      crossAxisSpacing: AppSpacing.xl,
      children: items,
    );
  },
)
```

## 🔄 Future Dark Theme

The `AppTheme.darkTheme` is available for implementing dark mode. Current placeholder included for future development.

## 📚 Best Practices

1. **Always use centralized constants** - Never hardcode colors, spacing, or sizes
2. **Use semantic naming** - Prefer `AppSpacing.screenPadding` over `AppSpacing.xl`
3. **Compose styles** - Use `.copyWith()` for variations instead of creating new styles
4. **Maintain hierarchy** - Use the correct text style for content hierarchy
5. **Shadow consistency** - Use `AppShadows` for depth instead of custom shadows
6. **Responsive values** - Use `AppDimensions` for breakpoints and sizing

## 🐛 Troubleshooting

### Text not displaying?
Check that font families (Eb Garamond, Manrope) are added to `pubspec.yaml`

### Colors look different?
Ensure `useMaterial3: true` in ThemeData

### Shadows not visible?
Make sure background is lighter than shadow color

## 📖 References

- [Material Design 3 Guidelines](https://m3.material.io)
- [Flutter Material Package](https://api.flutter.dev/flutter/material/material-library.html)
- [Ideole Design System](../../../design/design-system.md)
