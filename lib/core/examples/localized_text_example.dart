import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_track_fit/core/widgets/localized_text.dart';
import 'package:the_track_fit/core/bloc/language/language_bloc.dart';

/// Example screen showing how to use LocalizedText widgets
class LocalizedTextExample extends StatelessWidget {
  const LocalizedTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      appBar: AppBar(
        title: LocalizedText(
          'Font Examples',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF28A228),
        elevation: 0,
      ),
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          final currentLanguage = languageState is LanguageLoaded 
              ? languageState.currentLanguage 
              : 'ar';
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language indicator
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      LocalizedText(
                        'Current Language: $currentLanguage',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF28A228),
                      ),
                      SizedBox(height: 8.h),
                      LocalizedText(
                        currentLanguage == 'ar' 
                            ? 'الخط المستخدم: Cairo' 
                            : 'Font Used: Cairo',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Heading examples
                LocalizedText(
                  'Heading Examples',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E1E),
                ),
                SizedBox(height: 16.h),
                
                LocalizedHeading(
                  currentLanguage == 'ar' 
                      ? 'عنوان رئيسي بالعربية' 
                      : 'Main Heading in English',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF28A228),
                ),
                
                SizedBox(height: 12.h),
                
                LocalizedHeading(
                  currentLanguage == 'ar' 
                      ? 'عنوان فرعي بالعربية' 
                      : 'Sub Heading in English',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E1E1E),
                ),
                
                SizedBox(height: 24.h),
                
                // Body text examples
                LocalizedText(
                  'Body Text Examples',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E1E),
                ),
                SizedBox(height: 16.h),
                
                LocalizedBodyText(
                  currentLanguage == 'ar' 
                      ? 'هذا نص تجريبي باللغة العربية لاختبار خط Cairo. النص يجب أن يظهر بوضوح وبشكل جميل مع الخط العربي المناسب.' 
                      : 'This is a sample text in English to test the Poppins font. The text should appear clearly and beautifully with the appropriate English font.',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF1E1E1E),
                  height: 1.5,
                ),
                
                SizedBox(height: 12.h),
                
                LocalizedBodyText(
                  currentLanguage == 'ar' 
                      ? 'نص بخط متوسط بالعربية' 
                      : 'Medium weight text in English',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E1E1E),
                ),
                
                SizedBox(height: 24.h),
                
                // Caption examples
                LocalizedText(
                  'Caption Examples',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E1E),
                ),
                SizedBox(height: 16.h),
                
                LocalizedCaption(
                  currentLanguage == 'ar' 
                      ? 'نص توضيحي صغير بالعربية' 
                      : 'Small caption text in English',
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                
                SizedBox(height: 24.h),
                
                // Button text examples
                LocalizedText(
                  'Button Text Examples',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E1E),
                ),
                SizedBox(height: 16.h),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<LanguageBloc>().add(LanguageChanged('ar'));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF28A228),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: LocalizedButtonText(
                          currentLanguage == 'ar' 
                              ? 'العربية' 
                              : 'Arabic',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<LanguageBloc>().add(LanguageChanged('en'));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: LocalizedButtonText(
                          currentLanguage == 'ar' 
                              ? 'الإنجليزية' 
                              : 'English',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24.h),
                
                // Custom text examples
                LocalizedText(
                  'Custom Text Examples',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E1E),
                ),
                SizedBox(height: 16.h),
                
                LocalizedText(
                  currentLanguage == 'ar' 
                      ? 'نص مخصص مع تنسيق خاص' 
                      : 'Custom text with special formatting',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF28A228),
                  decoration: TextDecoration.underline,
                  letterSpacing: 1.2,
                ),
                
                SizedBox(height: 12.h),
                
                LocalizedText(
                  currentLanguage == 'ar' 
                      ? 'نص مع مسافات مخصصة' 
                      : 'Text with custom spacing',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF1E1E1E),
                  height: 2.0,
                  letterSpacing: 0.5,
                ),
                
                SizedBox(height: 24.h),
                
                // Font family comparison
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF28A228)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocalizedText(
                        'Font Family Comparison',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF28A228),
                      ),
                      SizedBox(height: 12.h),
                      LocalizedText(
                        currentLanguage == 'ar' 
                            ? 'العربية: Cairo Font' 
                            : 'Arabic: Cairo Font',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E1E1E),
                      ),
                      SizedBox(height: 8.h),
                      LocalizedText(
                        currentLanguage == 'ar' 
                            ? 'الإنجليزية: Poppins Font' 
                            : 'English: Poppins Font',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
