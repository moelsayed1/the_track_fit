import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../bloc/language/language_bloc.dart';
import '../helpers/api_localization_helper.dart';

/// مثال عملي لاستخدام النظام في التطبيق الحقيقي
class RealWorldUsageExample extends StatefulWidget {
  const RealWorldUsageExample({super.key});

  @override
  State<RealWorldUsageExample> createState() => _RealWorldUsageExampleState();
}

class _RealWorldUsageExampleState extends State<RealWorldUsageExample> {
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  /// مثال لاستخدام الترجمة مع بيانات API الحقيقية
  Future<void> _loadExercises() async {
    setState(() => _isLoading = true);
    
    try {
      // محاكاة استجابة API حقيقية
      final apiResponse = {
        'status': 'success',
        'data': [
          {
            'id': 1,
            'ar_name': '1 تمرين',
            'en_name': 'Exercise 1',
            'ar_description': null,
            'en_description': 'A basic upper body exercise',
            'ar_category': 'تمارين القوة',
            'en_category': 'Strength Training',
            'gif': 'exercises/gifs/exercise1.gif',
            'sets': 3,
            'reps': 8,
          },
          {
            'id': 2,
            'ar_name': '2 تمرين',
            'en_name': 'Exercise 2',
            'ar_description': null,
            'en_description': 'A cardio workout',
            'ar_category': 'تمارين القلب',
            'en_category': 'Cardio Training',
            'gif': 'exercises/gifs/exercise2.gif',
            'sets': 4,
            'reps': 12,
          },
        ]
      };

      // 👈 تطبيق الترجمة على بيانات API
      final processedResponse = await ApiLocalizationHelper.processApiResponse(
        apiResponse,
        specificFields: ['name', 'description', 'category'],
      );

      setState(() {
        _exercises = List<Map<String, dynamic>>.from(processedResponse['data'] ?? []);
      });
    } catch (e) {
      print('Error loading exercises: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final l10n = AppLocalizations.of(context)!;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.home), // 👈 من ARB بدل الهارد كود
            actions: [
              // 👈 زر تغيير اللغة
              IconButton(
                icon: Icon(Icons.language),
                onPressed: () => _showLanguageDialog(context),
              ),
            ],
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // 👈 النصوص الثابتة من ARB
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.yourActivity, // 👈 من ARB
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: 8),
                          Text(
                            l10n.dailyGoal, // 👈 من ARB
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 16),
                          // مؤشر اللغة الحالية
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: languageState is LanguageLoaded && languageState.isArabic 
                                  ? Colors.blue 
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              languageState is LanguageLoaded && languageState.isArabic 
                                  ? l10n.arabic 
                                  : l10n.english,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 👈 بيانات API المترجمة
                    Expanded(
                      child: ListView.builder(
                        itemCount: _exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = _exercises[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${exercise['id']}'),
                              ),
                              title: Text(
                                exercise['name'] ?? '', // 👈 مترجم تلقائياً
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(exercise['description'] ?? ''), // 👈 مترجم تلقائياً
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        exercise['category'] ?? '', // 👈 مترجم تلقائياً
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${exercise['sets']} ${l10n.sets} x ${exercise['reps']} ${l10n.reps}', // 👈 مختلط
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  /// 👈 حوار تغيير اللغة
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
              title: Text(l10n.language),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text(l10n.english),
                    value: 'en',
                    groupValue: currentLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LanguageBloc>().add(LanguageChanged(value));
                        Navigator.pop(context);
                        _loadExercises(); // إعادة تحميل البيانات باللغة الجديدة
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.arabic),
                    value: 'ar',
                    groupValue: currentLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LanguageBloc>().add(LanguageChanged(value));
                        Navigator.pop(context);
                        _loadExercises(); // إعادة تحميل البيانات باللغة الجديدة
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// مثال لاستخدام الترجمة في Repository
class LocalizedExerciseRepository {
  /// جلب التمارين مع الترجمة التلقائية
  Future<List<Map<String, dynamic>>> getExercises() async {
    try {
      // محاكاة استدعاء API
      final apiResponse = {
        'data': [
          {
            'id': 1,
            'ar_name': 'تمرين الضغط',
            'en_name': 'Push Up',
            'ar_description': null,
            'en_description': 'A basic upper body exercise',
          }
        ]
      };

      // 👈 معالجة البيانات مع الترجمة
      final processedResponse = await ApiLocalizationHelper.processApiResponse(
        apiResponse,
        specificFields: ['name', 'description'],
      );

      return List<Map<String, dynamic>>.from(processedResponse['data'] ?? []);
    } catch (e) {
      throw Exception('Failed to load exercises: $e');
    }
  }
}

/// مثال لاستخدام الترجمة في Widget بسيط
class SimpleLocalizedWidget extends StatelessWidget {
  const SimpleLocalizedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final l10n = AppLocalizations.of(context)!;
        
        return Column(
          children: [
            // 👈 النصوص الثابتة من ARB
            Text(l10n.home),
            Text(l10n.workout),
            Text(l10n.package),
            Text(l10n.report),
            Text(l10n.profile),
            Text(l10n.dailyGoal),
            Text(l10n.yourActivity),
            Text(l10n.newProducts),
            Text(l10n.showAllProducts),
            SizedBox(height: 20),
            
            // 👈 مؤشر اللغة الحالية
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: languageState is LanguageLoaded && languageState.isArabic 
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Current Language: ${languageState is LanguageLoaded ? languageState.currentLanguage : 'Unknown'}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
