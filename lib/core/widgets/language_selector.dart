import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../bloc/language/language_bloc.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final l10n = AppLocalizations.of(context)!;
        final currentLanguage = languageState is LanguageLoaded 
            ? languageState.currentLanguage 
            : 'ar';
        
        return Container(
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
              Text(
                l10n.selectLanguage, // 👈 من ARB بدل الهارد كود
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLanguageOption(
                    context: context,
                    languageCode: 'en',
                    languageName: l10n.english, // 👈 من ARB
                    flag: '🇺🇸',
                    isSelected: currentLanguage == 'en',
                  ),
                  SizedBox(width: 16.w),
                  _buildLanguageOption(
                    context: context,
                    languageCode: 'ar',
                    languageName: l10n.arabic, // 👈 من ARB
                    flag: '🇸🇦',
                    isSelected: currentLanguage == 'ar',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String languageCode,
    required String languageName,
    required String flag,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        // 👈 استخدام Bloc بدل LanguageService مباشرة
        context.read<LanguageBloc>().add(LanguageChanged(languageCode));
        
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.languageChanged),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: 20.sp),
            ),
            SizedBox(width: 8.w),
            Text(
              languageName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of how to use the language service in any widget
class ExampleLocalizedWidget extends StatelessWidget {
  const ExampleLocalizedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageService = LanguageService.instance;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: languageService.crossAxisAlignment,
        children: [
          Text(
            l10n.welcome,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.home,
            style: TextStyle(fontSize: 18.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.workout,
            style: TextStyle(fontSize: 18.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.exercise,
            style: TextStyle(fontSize: 18.sp),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              // Example API call with language parameter
              _makeApiCall(context);
            },
            child: Text(l10n.loading),
          ),
        ],
      ),
    );
  }

  void _makeApiCall(BuildContext context) async {
    final languageService = LanguageService.instance;
    
    // Example of how API calls automatically include language parameter
    // The ApiService will automatically add ?lang=en or ?lang=ar to requests
    try {
      // This is just an example - replace with your actual API service
      // final response = await ApiService().get('/api/some-endpoint');
      // The language parameter will be automatically added
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('API call made with language: ${languageService.currentLanguage}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
