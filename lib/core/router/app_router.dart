import 'package:go_router/go_router.dart';
import 'package:the_track_fit/features/cart/presentation/screens/cart_screen.dart';
import 'package:the_track_fit/features/home/presentation/widgets/home_screen_feature.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding2_screen.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding3_screen.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding4_screen.dart';
import 'package:the_track_fit/features/plan/presentation/screens/plan_screen.dart';
import 'package:the_track_fit/features/plan/presentation/widgets/premium_plan.dart';
import 'package:the_track_fit/features/plan/presentation/widgets/subscribtion_done.dart';
import 'package:the_track_fit/features/profile/presentation/widgets/edit_profile.dart';
import 'package:the_track_fit/features/profile/presentation/widgets/main_goal.dart';
import 'package:the_track_fit/features/profile/presentation/widgets/notification.dart';
import 'package:the_track_fit/features/profile/presentation/widgets/payment_info.dart';
import 'package:the_track_fit/features/profile/presentation/widgets/subscription.dart';
import 'package:the_track_fit/features/profile/presentation/widgets/update_payment_method.dart';
import 'package:the_track_fit/features/profile/presentation/widgets/change_password_profile.dart';
import 'package:the_track_fit/features/questions/weight/ui/widgets/question_done.dart';
import 'package:the_track_fit/features/report/presentation/screens/report_screen.dart';
import 'package:the_track_fit/features/scan_meals/presentation/screens/meal_screen.dart';
import 'package:the_track_fit/features/scan_meals/presentation/screens/widgets/scan_your_meal.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/features/workout/presentation/widgets/esercise_detail.dart';
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
import '../../features/questions/age/ui/age_screen.dart';
import '../../features/questions/fitness_level/ui/fitness_level_screen.dart';
import '../../features/questions/height/ui/height_screen.dart';
import '../../features/questions/weight/ui/weight_screen.dart';
import '../../features/questions/target_weight/ui/target_weight_screen.dart';
import '../../features/questions/main_goal/ui/main_goal_screen.dart';
import '../../features/questions/activity_level/ui/activity_level_screen.dart';
import '../../features/questions/training_types/ui/training_types_screen.dart';
import '../../features/questions/equipment/ui/equipment_screen.dart';
import '../../features/questions/diet_system/ui/diet_system_screen.dart';
import '../../features/questions/health_status/ui/health_status_screen.dart';
import '../../features/questions/special_diet/ui/special_diet_screen.dart';
import '../../features/questions/injury/ui/injury_screen.dart';
import '../../features/questions/additional_goals/ui/additional_goals_screen.dart';
import '../../features/plans/presentation/screens/promotional_offer_screen.dart';
import '../../features/store/presentation/ui/screens/store_screen.dart';
import '../../features/store/presentation/ui/screens/product_detail_screen.dart';
import '../../features/store/domain/models/product.dart';
import '../../features/workout/presentation/screens/workout_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/plan/presentation/widgets/checkout_plan_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/widgets/favourite_exercise.dart';


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
  static const String ageQuestion = '/age-question';
  static const String genderQuestion = '/gender-question';
  static const String fitnessLevel = '/fitness-level';
  static const String heightQuestion = '/height-question';
  static const String weightQuestion = '/weight-question';
  static const String targetWeightQuestion = '/target-weight-question';
  static const String mainGoalQuestion = '/main-goal-question';
  static const String activityLevelQuestion = '/activity-level-question';
  static const String trainingTypesQuestion = '/training-types-question';
  static const String equipmentQuestion = '/equipment-question';
  static const String dietSystemQuestion = '/diet-system-question';
  static const String healthStatusQuestion = '/health-status-question';
  static const String specialDietQuestion = '/special-diet-question';
  static const String injuryQuestion = '/injury-question';
  static const String additionalGoalsQuestion = '/additional-goals-question';
  static const String questionDone = '/question-done';
  static const String plan = '/plan';
  static const String promotionalOffer = '/promotional-offer';
  static const String store = '/store';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String workout = '/workout';
  static const String exerciseDetail = '/exercise-detail';
  static const String checkout = '/checkout';
  static const String meal = '/meal';
  static const String scanYourMeal = '/scan-your-meal';
  static const String report = '/report';
  static const String planSubscription = '/plan-subscription';
  static const String checkoutPlan = '/checkout-plan';
  static const String subscribtionDone = '/subscribtion-done';
  static const String premiumPlan = '/premium-plan';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String subscription = '/subscription';
  static const String paymentInfo = '/payment-info';
  static const String updatePaymentMethod = '/update-payment-method';
  static const String changePassword = '/change-password';
  static const String notification = '/notification';
  static const String mainGoal = '/main-goal';
  static const String favouriteExercise = '/favourite-exercise';
  
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
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? 'user@example.com';
          final otp = state.uri.queryParameters['otp'] ?? '123456';
          return NewPasswordScreen(email: email, otp: otp);
        },
      ),
      GoRoute(
        path: resetPasswordDone,
        name: 'resetPasswordDone',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            return ResetPasswordDone(
              text: extra['text'] as String,
              isFromCheckout: extra['isFromCheckout'] as bool? ?? false,
            );
          } else {
            return ResetPasswordDone(
              text: extra as String,
              isFromCheckout: false,
            );
          }
        },
      ),
      GoRoute(
        path: ageQuestion,
        name: 'ageQuestion',
        builder: (context, state) => const AgeQuestionScreen(),
      ),
      // GoRoute(
      //   path: genderQuestion,
      //   name: 'genderQuestion',
      //   builder: (context, state) => const GenderQuestionScreen(),
      // ),
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
        path: targetWeightQuestion,
        name: 'targetWeightQuestion',
        builder: (context, state) => const TargetWeightQuestionScreen(),
      ),
      GoRoute(
        path: mainGoalQuestion,
        name: 'mainGoalQuestion',
        builder: (context, state) => const MainGoalQuestionScreen(),
      ),
      GoRoute(
        path: activityLevelQuestion,
        name: 'activityLevelQuestion',
        builder: (context, state) => const ActivityLevelQuestionScreen(),
      ),
      GoRoute(
        path: trainingTypesQuestion,
        name: 'trainingTypesQuestion',
        builder: (context, state) => const TrainingTypesQuestionScreen(),
      ),
      GoRoute(
        path: equipmentQuestion,
        name: 'equipmentQuestion',
        builder: (context, state) => const EquipmentQuestionScreen(),
      ),
      GoRoute(
        path: dietSystemQuestion,
        name: 'dietSystemQuestion',
        builder: (context, state) => const DietSystemQuestionScreen(),
      ),
      GoRoute(
        path: healthStatusQuestion,
        name: 'healthStatusQuestion',
        builder: (context, state) => const HealthStatusQuestionScreen(),
      ),
      GoRoute(
        path: specialDietQuestion,
        name: 'specialDietQuestion',
        builder: (context, state) => const SpecialDietQuestionScreen(),
      ),
      GoRoute(
        path: injuryQuestion,
        name: 'injuryQuestion',
        builder: (context, state) => const InjuryQuestionScreen(),
      ),
      GoRoute(
        path: additionalGoalsQuestion,
        name: 'additionalGoalsQuestion',
        builder: (context, state) => const AdditionalGoalsQuestionScreen(),
      ),
      GoRoute(
        path: questionDone,
        name: 'questionDone',
        builder: (context, state) => const QuestionDone(),
      ),
      GoRoute(
        path: plan,
        name: 'plan',
        builder: (context, state) => const PlanSubscriptionScreen(),
      ),
      GoRoute(
        path: checkoutPlan,
        name: 'checkoutPlan',
        builder: (context, state) => const CheckoutPlanScreen(),
      ),
      GoRoute(
        path: premiumPlan,
        name: 'premiumPlan',
        builder: (context, state) => const PremiumPlan(),
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
        path: workout,
        name: 'workout',
        builder: (context, state) => const WorkoutScreen(),
        
      ),
      GoRoute(
        path: exerciseDetail,
        name: 'exerciseDetail',
        builder: (context, state) {
          if (state.extra == null) {
            // Return to workout screen if no exercise data
            return const ExerciseDetail(exercise: Exercise(id: 'default', title: 'Exercise name', subtitle: 'Exercise subtitle', imagePath: 'assets/images/exercise_image.png', type: 'Exercise type'));
          }
          return ExerciseDetail(exercise: state.extra as Exercise);
        },
      ),
      GoRoute(
        path: meal,
        name: 'meal',
        builder: (context, state) => const MealScreen(),
      ),
      GoRoute(
        path: checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: report,
        name: 'report',
        builder: (context, state) => const ReportScreen(),
      ),
      GoRoute(
        path: planSubscription,
        name: 'planSubscription',
        builder: (context, state) => const PlanSubscriptionScreen(),
      ),
      GoRoute(
        path: subscribtionDone,
        name: 'subscribtionDone',
        builder: (context, state) => const SubscribtionDone(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: editProfile,
        name: 'editProfile',
        builder: (context, state) => const EditProfile(),
      ),
      GoRoute(
        path: scanYourMeal,
        name: 'scanYourMeal',
        builder: (context, state) => const ScanYourMeal(),
      ),
      GoRoute(
        path: subscription,
        name: 'subscription',
        builder: (context, state) => const Subscription(),
      ),
      GoRoute(
        path: paymentInfo,
        name: 'paymentInfo',
        builder: (context, state) => const PaymentInfo(),
      ),
      GoRoute(
        path: updatePaymentMethod,
        name: 'updatePaymentMethod',
        builder: (context, state) => const UpdatePaymentMethod(),
      ),
      GoRoute(
        path: changePassword,
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordProfile(),
      ),
      GoRoute(
        path: notification,
        name: 'notification',
        builder: (context, state) => const NotificationProfile(),
      ),
      GoRoute(
        path: mainGoal,
        name: 'mainGoal',
        builder: (context, state) => const MainGoalProfile(),
      ),
      GoRoute(
        path: favouriteExercise,
        name: 'favouriteExercise',
        builder: (context, state) => const FavouriteExerciseProfile(),
      ),
      GoRoute(
        path: productDetail,
        name: 'productDetail',
        builder: (context, state) {
          // Check if we have valid product data
          if (state.extra == null) {
            // Return ProductDetailScreen with default product if no data
            final defaultProduct = Product(
              id: 'default',
              name: 'Product name',
              price: 20.0,
              imageUrl: 'assets/images/product_image.png',
              isFavorite: false,
            );
            return ProductDetailScreen(product: defaultProduct);
          }
          
          try {
            final productData = state.extra as Map<String, dynamic>;
            final product = productData['product'];
            
            if (product == null) {
              // Return to store if product is null
              final defaultProduct = Product(
                id: 'default',
                name: 'Product name',
                price: 20.0,
                imageUrl: 'assets/images/product_image.png',
                isFavorite: false,
              );
              return ProductDetailScreen(product: defaultProduct);
            }
            
            return ProductDetailScreen(product: product);
          } catch (e) {
            // Return to store on any error
            final defaultProduct = Product(
              id: 'default',
              name: 'Product name',
              price: 20.0,
              imageUrl: 'assets/images/product_image.png',
              isFavorite: false,
            );
            return ProductDetailScreen(product: defaultProduct);
          }
        },
      ),
    ],
  );
} 