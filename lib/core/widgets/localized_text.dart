import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/language/language_bloc.dart';

/// Widget that automatically applies the correct font family based on current language
/// - Arabic: Cairo font family
/// - English: Poppins font family
class LocalizedText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;
  final TextDecoration? decoration;
  final double? height;
  final double? letterSpacing;
  final double? wordSpacing;

  const LocalizedText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.wordSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final currentLanguage = languageState is LanguageLoaded 
            ? languageState.currentLanguage 
            : 'ar';
        final fontFamily = currentLanguage == 'ar' ? 'Cairo' : 'Poppins';
        
        // Create base text style
        TextStyle textStyle = TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize?.sp,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration,
          height: height,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
        );

        // Merge with custom style if provided
        if (style != null) {
          textStyle = textStyle.merge(style);
        }

        return Center(
          child: Text(
            text,
            style: textStyle,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          ),
        );
      },
    );
  }
}

/// Widget that automatically applies the correct font family for headings
class LocalizedHeading extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

  const LocalizedHeading(
    this.text, {
    super.key,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }
}

/// Widget that automatically applies the correct font family for body text
class LocalizedBodyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;
  final double? height;

  const LocalizedBodyText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
      height: height,
    );
  }
}

/// Widget that automatically applies the correct font family for captions
class LocalizedCaption extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

  const LocalizedCaption(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }
}

/// Widget that automatically applies the correct font family for buttons
class LocalizedButtonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextStyle? style;

  const LocalizedButtonText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.color,
    this.textAlign,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      style: style,
    );
  }
}

/// Extension to easily get localized font family
extension LocalizedFontFamily on BuildContext {
  String get localizedFontFamily {
    final languageState = read<LanguageBloc>().state;
    if (languageState is LanguageLoaded) {
      return languageState.currentLanguage == 'ar' ? 'Cairo' : 'Poppins';
    }
    return 'Poppins';
  }
}

/// Extension to easily create localized text styles
extension LocalizedTextStyle on TextStyle {
  TextStyle localized(BuildContext context) {
    final languageState = context.read<LanguageBloc>().state;
    final fontFamily = languageState is LanguageLoaded 
        ? (languageState.currentLanguage == 'ar' ? 'Cairo' : 'Poppins')
        : 'Poppins';
    return copyWith(fontFamily: fontFamily);
  }
}
