import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../bloc/language/language_bloc.dart';
import '../services/language_service.dart';
import '../../core/constants/constants.dart';
import '../../core/router/app_router.dart';

/// Widget منفصل لإدارة الترجمة مع Bloc
class LocalizedApp extends StatelessWidget {
  const LocalizedApp({super.key, required ThemeMode themeMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final currentLocale = languageState is LanguageLoaded
            ? Locale(languageState.currentLanguage)
            : LanguageService.instance.currentLocale;

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryGreen,
              secondary: AppColors.primaryGreenLight,
              surface: AppColors.surface,
              background: AppColors.background,
              onPrimary: AppColors.white,
              onSecondary: AppColors.white,
              onSurface: AppColors.white,
              onBackground: AppColors.white,
            ),
            textTheme: TextTheme(
              displayLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              displayMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              displaySmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              headlineLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              headlineMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              headlineSmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              titleLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              titleMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              titleSmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              bodyLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              bodyMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.gray,
              ),
              bodySmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.gray,
              ),
              labelLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              labelMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              labelSmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
            ),
          ),
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryGreen,
              secondary: AppColors.primaryGreenLight,
              surface: AppColors.surface,
              background: AppColors.background,
              onPrimary: AppColors.white,
              onSecondary: AppColors.white,
              onSurface: AppColors.white,
              onBackground: AppColors.white,
            ),
            textTheme: TextTheme(
              displayLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              displayMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              displaySmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              headlineLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              headlineMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              headlineSmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              titleLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              titleMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              titleSmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              bodyLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              bodyMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.gray,
              ),
              bodySmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.gray,
              ),
              labelLarge: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              labelMedium: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
              labelSmall: TextStyle(
                fontFamily: currentLocale.languageCode == 'ar'
                    ? 'Cairo'
                    : 'Poppins',
                color: AppColors.white,
              ),
            ),
          ),
          routerConfig: AppRouter.router,
          locale: currentLocale, // 👈 اللغة حسب الـ Bloc
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            return supportedLocales.contains(locale)
                ? locale
                : const Locale('ar');
          },
        );
      },
    );
  }
}

/// Widget لاختبار الترجمة
class LanguageTestWidget extends StatelessWidget {
  const LanguageTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final l10n = AppLocalizations.of(context)!;
        final currentLanguage = languageState is LanguageLoaded
            ? languageState.currentLanguage
            : 'ar';

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.home),
            actions: [
              IconButton(
                icon: Icon(Icons.language),
                onPressed: () => _showLanguageDialog(context),
              ),
            ],
          ),
          body: Column(
            children: [
              // مؤشر اللغة الحالية
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: currentLanguage == 'ar' ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Current Language: $currentLanguage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: currentLanguage == 'ar' ? 'Cairo' : 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // النصوص المترجمة
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildTextCard('Home', l10n.home),
                    _buildTextCard('Workout', l10n.workout),
                    _buildTextCard('Package', l10n.package),
                    _buildTextCard('Report', l10n.report),
                    _buildTextCard('Profile', l10n.profile),
                    _buildTextCard('Daily Goal', l10n.dailyGoal),
                    _buildTextCard('Your Activity', l10n.yourActivity),
                    _buildTextCard('New Products', l10n.newProducts),
                    _buildTextCard('Show All Products', l10n.showAllProducts),
                    _buildTextCard('Language', l10n.language),
                    _buildTextCard('English', l10n.english),
                    _buildTextCard('Arabic', l10n.arabic),
                    _buildTextCard('Settings', l10n.settings),
                    _buildTextCard('Notifications', l10n.notifications),
                    _buildTextCard('Logout', l10n.logout),
                    _buildTextCard('Loading', l10n.loading),
                    _buildTextCard('Cancel', l10n.cancel),
                    _buildTextCard('Save', l10n.save),
                    _buildTextCard('Delete', l10n.delete),
                    _buildTextCard('Edit', l10n.edit),
                    _buildTextCard('Add', l10n.add),
                    _buildTextCard('Search', l10n.search),
                    _buildTextCard('Filter', l10n.filter),
                    _buildTextCard('Sort', l10n.sort),
                    _buildTextCard('Refresh', l10n.refresh),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextCard(String englishText, String localizedText) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final currentLanguage = languageState is LanguageLoaded
            ? languageState.currentLanguage
            : 'ar';

        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
              englishText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Poppins', // English text always uses Poppins
              ),
            ),
            subtitle: Text(
              localizedText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: currentLanguage == 'ar' ? 'Cairo' : 'Poppins',
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;

        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            final currentLanguage = languageState is LanguageLoaded
                ? languageState.currentLanguage
                : 'ar';

            return AlertDialog(
              title: Text(
                l10n.language,
                style: TextStyle(
                  fontFamily: currentLanguage == 'ar' ? 'Cairo' : 'Poppins',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text(
                      l10n.english,
                      style: TextStyle(
                        fontFamily: currentLanguage == 'ar'
                            ? 'Cairo'
                            : 'Poppins',
                      ),
                    ),
                    value: 'en',
                    groupValue: currentLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LanguageBloc>().add(
                          LanguageChanged(value),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(
                      l10n.arabic,
                      style: TextStyle(
                        fontFamily: currentLanguage == 'ar'
                            ? 'Cairo'
                            : 'Poppins',
                      ),
                    ),
                    value: 'ar',
                    groupValue: currentLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LanguageBloc>().add(
                          LanguageChanged(value),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(
                      fontFamily: currentLanguage == 'ar' ? 'Cairo' : 'Poppins',
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
