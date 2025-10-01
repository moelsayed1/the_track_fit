import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/core/utils/font_helper.dart';
import 'package:the_track_fit/core/bloc/language/language_bloc.dart';

/// مثال بسيط لتوضيح كيفية عمل الخط الديناميكي
class FontExampleScreen extends StatelessWidget {
  const FontExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Font Example',
          style: TextStyle(fontFamily: context.fontFamily),
        ),
        actions: [
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              final currentLang = state is LanguageLoaded ? state.currentLanguage : 'en';
              return TextButton(
                onPressed: () {
                  final newLang = currentLang == 'ar' ? 'en' : 'ar';
                  context.read<LanguageBloc>().add(LanguageChanged(newLang));
                },
                child: Text(
                  currentLang == 'ar' ? 'English' : 'العربية',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: context.fontFamily,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مؤشر اللغة والخط الحالي
            BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, state) {
                final currentLang = state is LanguageLoaded ? state.currentLanguage : 'en';
                final currentFont = currentLang == 'ar' ? 'Cairo' : 'Poppins';
                
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: currentLang == 'ar' ? Colors.blue : Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current Language: $currentLang',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: context.fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current Font: $currentFont',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: context.fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // نصوص باللغة الإنجليزية
            Text(
              'English Text (Poppins Font):',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: context.fontFamily,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Hello World! This is English text.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: context.fontFamily,
              ),
            ),
            Text(
              'The quick brown fox jumps over the lazy dog.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: context.fontFamily,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // نصوص باللغة العربية
            Text(
              'النصوص العربية (خط Cairo):',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: context.fontFamily,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'مرحباً بالعالم! هذا نص عربي.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: context.fontFamily,
              ),
            ),
            Text(
              'الخط السريع البني يقفز فوق الكلب الكسول.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: context.fontFamily,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // استخدام FontHelper مباشرة
            Text(
              'Using FontHelper.createTextStyle():',
              style: FontHelper.createTextStyle(
                context,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This text uses FontHelper.createTextStyle() method',
              style: FontHelper.createTextStyle(
                context,
                fontSize: 16,
                color: Colors.purple,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // معلومات إضافية
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Font Rules:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: context.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Arabic (ar) → Cairo Font',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: context.fontFamily,
                    ),
                  ),
                  Text(
                    '• English (en) → Poppins Font',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: context.fontFamily,
                    ),
                  ),
                  Text(
                    '• Default → Poppins Font',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: context.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
