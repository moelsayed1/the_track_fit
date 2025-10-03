import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../bloc/language/language_bloc.dart';
import '../services/language_service.dart';

class LanguageToggleButton extends StatelessWidget {
  final EdgeInsets padding;
  final double borderRadius;

  const LanguageToggleButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final currentLanguage = languageState is LanguageLoaded
            ? languageState.currentLanguage
            : LanguageService.instance.currentLanguage;

        return GestureDetector(
          onTap: () => _toggleLanguage(context),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Builder(
              builder: (context) {
                return Text(
                  _getLanguageLabel(currentLanguage),
                  style: TextStyle(
                    fontFamily: currentLanguage != 'ar' ? 'Cairo' : 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _getLanguageLabel(String currentLanguage) {
    return currentLanguage == 'ar' ? 'EN' : 'العربية';
  }

  void _toggleLanguage(BuildContext context) {
    // Get current language from BLoC state if available, otherwise fallback to service
    final languageState = context.read<LanguageBloc>().state;
    final currentLang = languageState is LanguageLoaded
        ? languageState.currentLanguage
        : LanguageService.instance.currentLanguage;

    final newLang = currentLang == 'ar' ? 'en' : 'ar';

    // Change language using Bloc
    context.read<LanguageBloc>().add(LanguageChanged(newLang));

    // Show success message
    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newLang == 'ar'
                ? "تم تغيير اللغة الي العربية"
                : l10n.languageChangedToEnglish,
            style: TextStyle(
              color: Colors.white,
              fontFamily: newLang == 'ar' ? 'Cairo' : 'Poppins',
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}
