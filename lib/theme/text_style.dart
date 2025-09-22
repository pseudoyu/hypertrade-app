import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

// Font sizes
const double fontSizeXS = 10.0;
const double fontSizeS = 12.0;
const double fontSizeM = 14.0;
const double fontSizeL = 16.0;
const double fontSizeXL = 18.0;
const double fontSizeXXL = 20.0;
const double fontSizeXXXL = 24.0;
const double fontSizeDisplay = 32.0;

// Font weights
const FontWeight fontWeightLight = FontWeight.w300;
const FontWeight fontWeightRegular = FontWeight.w400;
const FontWeight fontWeightMedium = FontWeight.w500;
const FontWeight fontWeightSemiBold = FontWeight.w600;
const FontWeight fontWeightBold = FontWeight.w700;
const FontWeight fontWeightBlack = FontWeight.w900;

// Heading styles
TextStyle headingLarge = GoogleFonts.openSans(
  fontSize: fontSizeXXXL,
  fontWeight: fontWeightBold,
  color: textPrimary,
  letterSpacing: -0.5,
);

TextStyle headingMedium = GoogleFonts.openSans(
  fontSize: fontSizeXXL,
  fontWeight: fontWeightBold,
  color: textPrimary,
  letterSpacing: -0.25,
);

TextStyle headingSmall = GoogleFonts.openSans(
  fontSize: fontSizeXL,
  fontWeight: fontWeightSemiBold,
  color: textPrimary,
);

// Body text styles
TextStyle bodyLarge = GoogleFonts.openSans(
  fontSize: fontSizeL,
  fontWeight: fontWeightRegular,
  color: textPrimary,
);

TextStyle bodyMedium = GoogleFonts.openSans(
  fontSize: fontSizeM,
  fontWeight: fontWeightRegular,
  color: textPrimary,
);

TextStyle bodySmall = GoogleFonts.openSans(
  fontSize: fontSizeS,
  fontWeight: fontWeightRegular,
  color: textSecondary,
);

// Label styles
TextStyle labelLarge = GoogleFonts.openSans(
  fontSize: fontSizeM,
  fontWeight: fontWeightMedium,
  color: textPrimary,
  letterSpacing: 0.1,
);

TextStyle labelMedium = GoogleFonts.openSans(
  fontSize: fontSizeS,
  fontWeight: fontWeightMedium,
  color: textSecondary,
  letterSpacing: 0.5,
);

TextStyle labelSmall = GoogleFonts.openSans(
  fontSize: fontSizeXS,
  fontWeight: fontWeightMedium,
  color: textSecondary,
  letterSpacing: 0.5,
);

// Button styles
TextStyle buttonLarge = GoogleFonts.openSans(
  fontSize: fontSizeL,
  fontWeight: fontWeightSemiBold,
  color: textLight,
  letterSpacing: 0.1,
);

TextStyle buttonMedium = GoogleFonts.openSans(
  fontSize: fontSizeM,
  fontWeight: fontWeightSemiBold,
  color: textLight,
  letterSpacing: 0.1,
);

TextStyle buttonSmall = GoogleFonts.openSans(
  fontSize: fontSizeS,
  fontWeight: fontWeightSemiBold,
  color: textLight,
  letterSpacing: 0.1,
);

// Status text styles
TextStyle successText = GoogleFonts.openSans(
  fontSize: fontSizeM,
  fontWeight: fontWeightMedium,
  color: success,
);

TextStyle errorText = GoogleFonts.openSans(
  fontSize: fontSizeM,
  fontWeight: fontWeightMedium,
  color: error,
);

TextStyle warningText = GoogleFonts.openSans(
  fontSize: fontSizeM,
  fontWeight: fontWeightMedium,
  color: warning,
);

TextStyle infoText = GoogleFonts.openSans(
  fontSize: fontSizeM,
  fontWeight: fontWeightMedium,
  color: info,
);

// For backward compatibility
TextStyle lightText = GoogleFonts.openSans(
  fontSize: fontSizeS,
  fontWeight: fontWeightLight,
  color: textPrimary,
);

TextStyle regularText = GoogleFonts.openSans(
  fontSize: fontSizeM,
  fontWeight: fontWeightRegular,
  color: textPrimary,
);

TextStyle mediumText = GoogleFonts.openSans(
  fontSize: fontSizeL,
  fontWeight: fontWeightMedium,
  color: textPrimary,
);

TextStyle semiboldText = GoogleFonts.openSans(
  fontSize: fontSizeXL,
  fontWeight: fontWeightSemiBold,
  color: textPrimary,
);

TextStyle boldText = GoogleFonts.openSans(
  fontSize: fontSizeXXL,
  fontWeight: fontWeightBold,
  color: textPrimary,
);

TextStyle blackText = GoogleFonts.openSans(
  fontSize: fontSizeXXXL,
  fontWeight: fontWeightBlack,
  color: textPrimary,
);

List<String> fontFamilyFallbackList = [
  "open sans",
  "PingFang SC",
  "Microsoft YaHei",
  "system-ui",
  "Segoe UI",
  "Roboto",
  "Ubuntu",
  "Noto Sans SC",
  "Cantarell",
  "sans-serif",
  "BlinkMacSystemFont",
  "Helvetica Neue",
  "Hiragino Sans GB",
  "Heiti SC"
];
