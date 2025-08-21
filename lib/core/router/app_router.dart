import 'package:go_router/go_router.dart';
import 'package:the_track_fit/features/cart/presentation/screens/cart_screen.dart';
import 'package:the_track_fit/features/home/presentation/widgets/home_screen_feature.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding2_screen.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding3_screen.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding4_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding1_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_pageview_screen.dart';
import '../../features/auth/signup/presentation/signup_screen.dart';
import '../../features/auth/login/presentation/screens/login_screen.dart';
import '../../features/auth/forget_password/presentation/ui/forget_password_screen.dart';
import '../../features/auth/otp/presentation/ui/otp_screen.dart';
import '../../features/auth/new_password/presentation/ui/new_password_screen.dart';
import '../../features/auth/new_password/presentation/widgets/reset_password_done.dart';
import '../../features/questions/gender_question/presentation/ui/gender_question_screen.dart';
import '../../features/questions/fitness_level/ui/fitness_level_screen.dart';
import '../../features/questions/height/ui/height_screen.dart';
import '../../features/questions/weight/ui/weight_screen.dart';
import '../../features/plans/presentation/screens/plan_screen.dart';
import '../../features/plans/presentation/screens/promotional_offer_screen.dart';
import '../../features/store/presentation/ui/screens/store_screen.dart';
import '../../features/store/presentation/ui/screens/product_detail_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String onboarding3 = '/onboarding3';
  static const String onboarding4 = '/onboarding4';
  static const String home = '/home';
  static const String homeFeature= '/homeFeature';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String forgetPassword = '/forget-password';
  static const String otp = '/otp';
  static const String newPassword = '/new-password';
  static const String resetPasswordDone = '/reset-password-done';
  static const String genderQuestion = '/gender-question';
  static const String fitnessLevel = '/fitness-level';
  static const String heightQuestion = '/height-question';
  static const String weightQuestion = '/weight-question';
  static const String plan = '/plan';
  static const String promotionalOffer = '/promotional-offer';
  static const String store = '/store';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPageViewScreen(),
      ),
      GoRoute(
        path: onboarding1,
        name: 'onboarding1',
        builder: (context, state) => const Onboarding1Screen(),
      ),
      GoRoute(
        path: onboarding2,
        name: 'onboarding2',
        builder: (context, state) => const Onboarding2Screen(),
      ),
      GoRoute(
        path: onboarding3,
        name: 'onboarding3',
        builder: (context, state) => const Onboarding3Screen(),
      ),
      GoRoute(
        path: onboarding4,
        name: 'onboarding4',
        builder: (context, state) => const Onboarding4Screen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: homeFeature,
        name: 'homeFeature',
        builder: (context, state) => const HomeScreenFeature(),
      ),
      GoRoute(
        path: signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: forgetPassword,
        name: 'forgetPassword',
        builder: (context, state) => const ForgetPasswordScreen(),
      ),
      GoRoute(
        path: otp,
        name: 'otp',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? 'user@example.com';
          return OtpScreen(email: email);
        },
      ),
      GoRoute(
        path: newPassword,
        name: 'newPassword',
        builder: (context, state) => const NewPasswordScreen(),
      ),
      GoRoute(
        path: resetPasswordDone,
        name: 'resetPasswordDone',
        builder: (context, state) => ResetPasswordDone(
          text: state.extra as String,
        ),
      ),
      GoRoute(
        path: genderQuestion,
        name: 'genderQuestion',
        builder: (context, state) => const GenderQuestionScreen(),
      ),
      GoRoute(
        path: fitnessLevel,
        name: 'fitnessLevel',
        builder: (context, state) => const FitnessLevelScreen(),
      ),
      GoRoute(
        path: heightQuestion,
        name: 'heightQuestion',
        builder: (context, state) => const HeightQuestionScreen(),
      ),
      GoRoute(
        path: weightQuestion,
        name: 'weightQuestion',
        builder: (context, state) => const WeightQuestionScreen(),
      ),
      GoRoute(
        path: plan,
        name: 'plan',
        builder: (context, state) => const PlanScreen(),
      ),
      GoRoute(
        path: promotionalOffer,
        name: 'promotionalOffer',
        builder: (context, state) => const PromotionalOfferScreen(),
      ),
      GoRoute(
        path: store,
        name: 'store',
        builder: (context, state) => const StoreScreen(),
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: productDetail,
        name: 'productDetail',
        builder: (context, state) {
          // Check if we have valid product data
          if (state.extra == null) {
            // Redirect to store if no data
            return const StoreScreen();
          }
          
          try {
            final productData = state.extra as Map<String, dynamic>;
            final product = productData['product'];
            
            if (product == null) {
              // Return to store if product is null
              return const StoreScreen();
            }
            
            return ProductDetailScreen(product: product);
          } catch (e) {
            // Return to store on any error
            return const StoreScreen();
          }
        },
      ),
    ],
  );
} 