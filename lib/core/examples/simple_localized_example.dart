import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_track_fit/core/widgets/localized_text.dart';
import 'package:the_track_fit/core/bloc/language/language_bloc.dart';

/// Simple example showing LocalizedText usage
class SimpleLocalizedExample extends StatelessWidget {
  const SimpleLocalizedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      appBar: AppBar(
        title: LocalizedText(
          'Font Test',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF28A228),
      ),
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          final currentLanguage = languageState is LanguageLoaded 
              ? languageState.currentLanguage 
              : 'ar';
          
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current language indicator
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
                  child: LocalizedText(
                    'Current Language: $currentLanguage',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF28A228),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Arabic text example
                LocalizedHeading(
                  currentLanguage == 'ar' 
                      ? 'مرحباً بك في التطبيق' 
                      : 'Welcome to the App',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF28A228),
                ),
                
                SizedBox(height: 16.h),
                
                // Body text example
                LocalizedBodyText(
                  currentLanguage == 'ar' 
                      ? 'هذا نص تجريبي لاختبار خط Cairo في اللغة العربية. النص يجب أن يظهر بوضوح وبشكل جميل.' 
                      : 'This is a sample text to test the Poppins font in English. The text should appear clearly and beautifully.',
                  fontSize: 16,
                  height: 1.5,
                  color: const Color(0xFF1E1E1E),
                ),
                
                SizedBox(height: 24.h),
                
                // Button examples
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<LanguageBloc>().add(LanguageChanged('ar'));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentLanguage == 'ar' 
                              ? const Color(0xFF28A228) 
                              : Colors.grey[400],
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: LocalizedButtonText(
                          'العربية',
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
                          backgroundColor: currentLanguage == 'en' 
                              ? const Color(0xFF28A228) 
                              : Colors.grey[400],
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: LocalizedButtonText(
                          'English',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24.h),
                
                // Font info
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
                        'Font Information',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF28A228),
                      ),
                      SizedBox(height: 8.h),
                      LocalizedCaption(
                        currentLanguage == 'ar' 
                            ? 'الخط المستخدم: Cairo' 
                            : 'Font Used: Cairo',
                        fontSize: 14,
                        color: const Color(0xFF1E1E1E),
                      ),
                      SizedBox(height: 4.h),
                      LocalizedCaption(
                        currentLanguage == 'ar' 
                            ? 'الخط المستخدم: Poppins' 
                            : 'Font Used: Poppins',
                        fontSize: 14,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
