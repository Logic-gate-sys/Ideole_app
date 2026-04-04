/// Font Configuration for Ideole Design System
/// Uses Google Fonts for easy font management
/// 
/// To use Google Fonts:
/// 1. Add google_fonts package to pubspec.yaml:
///    google_fonts: ^7.0.0
/// 
/// 2. Update AppTheme to use GoogleFonts in fontFamily:
///    fontFamily: GoogleFonts.manrope().fontFamily,
/// 
/// Fonts used:
/// - Eb Garamond (serif) - Headlines
/// - Manrope (sans-serif) - Body & Labels
library;

class AppFonts {
  // Font family names (as defined in pubspec.yaml or google_fonts)
  static const String headlineFamily = 'EbGaramond';
  static const String bodyFamily = 'Manrope';
  static const String labelFamily = 'Manrope';

  // Alternative: If using google_fonts package
  static const String googleHeadlineFamily = 'Eb Garamond';
  static const String googleBodyFamily = 'Manrope';
  static const String googleLabelFamily = 'Manrope';
}

/// Setup Instructions for Custom Fonts (Alternative to Google Fonts)
///
/// If you prefer to bundle fonts locally:
///
/// 1. Create folders:
///    - assets/fonts/
///    - assets/fonts/eb-garamond/
///    - assets/fonts/manrope/
///
/// 2. Download font files from:
///    - Eb Garamond: https://fonts.google.com/specimen/EB+Garamond
///    - Manrope: https://fonts.google.com/specimen/Manrope
///
/// 3. Update pubspec.yaml:
///    flutter:
///      fonts:
///        - family: EbGaramond
///          fonts:
///            - asset: assets/fonts/eb-garamond/EbGaramond-Regular.ttf
///            - asset: assets/fonts/eb-garamond/EbGaramond-Bold.ttf
///              weight: 700
///            - asset: assets/fonts/eb-garamond/EbGaramond-Italic.ttf
///              style: italic
///        - family: Manrope
///          fonts:
///            - asset: assets/fonts/manrope/Manrope-Light.ttf
///              weight: 300
///            - asset: assets/fonts/manrope/Manrope-Regular.ttf
///            - asset: assets/fonts/manrope/Manrope-Medium.ttf
///              weight: 500
///            - asset: assets/fonts/manrope/Manrope-SemiBold.ttf
///              weight: 600
///            - asset: assets/fonts/manrope/Manrope-Bold.ttf
///              weight: 700
///
/// 4. Run `flutter clean` and `flutter pub get`
///
/// 5. Update AppTextStyles.headlineFont and AppTextStyles.bodyFont
///    to match the family names above.
