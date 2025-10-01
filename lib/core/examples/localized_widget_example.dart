import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../helpers/api_localization_helper.dart';

/// Example widget demonstrating both static UI localization and API localization
class LocalizedWidgetExample extends StatefulWidget {
  const LocalizedWidgetExample({super.key});

  @override
  State<LocalizedWidgetExample> createState() => _LocalizedWidgetExampleState();
}

class _LocalizedWidgetExampleState extends State<LocalizedWidgetExample> {
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() => _isLoading = true);
    
    try {
      // Simulate API response with both Arabic and English fields
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

      // Process API response with localization
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
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        final l10n = AppLocalizations.of(context)!;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.home), // Static UI localization
            actions: [
              IconButton(
                icon: Icon(Icons.language),
                onPressed: () => _showLanguageDialog(context, languageService),
              ),
            ],
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Static UI localization examples
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.yourActivity, // Static UI localization
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: 8),
                          Text(
                            l10n.dailyGoal, // Static UI localization
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 16),
                          // Language indicator
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: languageService.isArabic ? Colors.blue : Colors.green,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              languageService.isArabic ? l10n.arabic : l10n.english,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // API localization examples
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
                                exercise['name'] ?? '', // API localization
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(exercise['description'] ?? ''), // API localization
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        exercise['category'] ?? '', // API localization
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${exercise['sets']} ${l10n.sets} x ${exercise['reps']} ${l10n.reps}', // Mixed localization
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

  void _showLanguageDialog(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.english),
                leading: Radio<String>(
                  value: 'en',
                  groupValue: languageService.currentLanguage,
                  onChanged: (value) {
                    if (value != null) {
                      languageService.changeLanguage(value);
                      Navigator.pop(context);
                      _loadExercises(); // Reload data with new language
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(l10n.arabic),
                leading: Radio<String>(
                  value: 'ar',
                  groupValue: languageService.currentLanguage,
                  onChanged: (value) {
                    if (value != null) {
                      languageService.changeLanguage(value);
                      Navigator.pop(context);
                      _loadExercises(); // Reload data with new language
                    }
                  },
                ),
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
  }
}

/// Example of using localization in a simple widget
class SimpleLocalizedWidget extends StatelessWidget {
  const SimpleLocalizedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        Text(l10n.home),
        Text(l10n.workout),
        Text(l10n.package),
        Text(l10n.report),
        Text(l10n.profile),
        Text(l10n.dailyGoal),
        Text(l10n.yourActivity),
        Text(l10n.newProducts),
        Text(l10n.showAllProducts),
      ],
    );
  }
}

/// Example of using API localization in a repository
class LocalizedExerciseRepository {
  Future<List<Map<String, dynamic>>> getExercises() async {
    try {
      // Simulate API call
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

      // Process with localization
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
