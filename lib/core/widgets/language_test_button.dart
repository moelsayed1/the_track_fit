import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../services/language_service.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';

/// زر اختبار سريع للترجمة
class LanguageTestButton extends StatelessWidget {
  const LanguageTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final currentLanguage = languageState is LanguageLoaded 
            ? languageState.currentLanguage 
            : LanguageService.instance.currentLanguage;
        
        return FloatingActionButton(
          onPressed: () => _toggleLanguage(context),
          backgroundColor: currentLanguage == 'ar' ? Colors.blue : Colors.green,
          child: Text(
            currentLanguage == 'ar' ? 'EN' : 'AR',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  void _toggleLanguage(BuildContext context) {
    final currentLang = LanguageService.instance.currentLanguage;
    final newLang = currentLang == 'ar' ? 'en' : 'ar';
    
    // تغيير اللغة باستخدام Bloc
    context.read<LanguageBloc>().add(LanguageChanged(newLang));
    
    // إظهار رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newLang == 'ar' ? 'تم تغيير اللغة إلى العربية' : 'Language changed to English'
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Widget لعرض حالة الترجمة الحالية
class LanguageStatusWidget extends StatelessWidget {
  const LanguageStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final currentLanguage = languageState is LanguageLoaded 
            ? languageState.currentLanguage 
            : LanguageService.instance.currentLanguage;
        
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: currentLanguage == 'ar' ? Colors.blue.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: currentLanguage == 'ar' ? Colors.blue : Colors.green,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Language Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Current: $currentLanguage',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                'Direction: ${currentLanguage == 'ar' ? 'RTL' : 'LTR'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<LanguageBloc>().add(LanguageChanged('ar'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentLanguage == 'ar' ? Colors.blue : Colors.grey,
                    ),
                    child: Text('العربية'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LanguageBloc>().add(LanguageChanged('en'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentLanguage == 'en' ? Colors.green : Colors.grey,
                    ),
                    child: Text('English'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
