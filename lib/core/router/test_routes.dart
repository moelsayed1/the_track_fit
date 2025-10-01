import 'package:go_router/go_router.dart';
import '../widgets/localized_app.dart';

/// Routes لاختبار الترجمة
class TestRoutes {
  static const String languageTest = '/language-test';
  
  static List<RouteBase> get routes => [
    GoRoute(
      path: languageTest,
      name: 'languageTest',
      builder: (context, state) => const LanguageTestWidget(),
    ),
  ];
}
