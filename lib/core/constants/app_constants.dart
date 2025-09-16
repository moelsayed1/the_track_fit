class AppConstants {
  // App information
  static const String appName = 'Track Fit';
  static const String appVersion = '1.0.0';
  
  // Animation durations
  static const Duration splashDuration = Duration(seconds: 5);
  static const Duration fadeInDuration = Duration(milliseconds: 1500);
  static const Duration transitionDuration = Duration(milliseconds: 500);
  
  // Dimensions (will be made responsive with ScreenUtil)
  static const double buttonHeight = 56.0;
  static const double buttonBorderRadius = 30.0;
  static const double logoSize = 120.0;
  
  // Responsive breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  // Padding and margins
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Font sizes
  static const double smallTextSize = 12.0;
  static const double normalTextSize = 14.0;
  static const double mediumTextSize = 16.0;
  static const double largeTextSize = 18.0;
  static const double titleTextSize = 24.0;
  static const double headingTextSize = 28.0;
  
  // Font families (using system defaults for now)
  // static const String primaryFont = 'Poppins';
  static const String secondaryFont = 'Arial';
  
  // Asset paths (imported from app_assets.dart)
  // Use AppAssets class for all asset paths
  
  // API Configuration
  static const String baseUrl = 'https://thetrackfit.com'; 
  static const String registerEndpoint = '/api/register';
  static const String loginEndpoint = '/api/login';
  static const String logoutEndpoint = '/api/logout';
  static const String sendOtpEndpoint = '/api/send-otp';
  static const String verifyOtpEndpoint = '/api/verify-otp';
  static const String resetPasswordEndpoint = '/api/reset-password';
  static const String updateProfileEndpoint = '/api/update';
  static const String mainGoalOptionEndpoint = '/api/main-goal-option';
  static const String getAllExercisesEndpoint = '/api/get-all-exercises';
  static const String getExercisesCategoryEndpoint = '/api/get-exercises-category';
  static const String getExercisesByLocationEndpoint = '/api/get-exercises-filter';
  static const String getExercisesByEquipmentEndpoint = '/api/get-exercises-filter';
  static const String getExercisesByDayEndpoint = '/api/get-exercises-by-day';
  static const String newProductsEndpoint = '/api/new-products';
  static const String storeInCartEndpoint = '/api/store-in-cart';
  static const String getCartItemsEndpoint = '/api/get-cart';
  static const String removeFromCartEndpoint = '/api/remove-from-cart';
  static const String storeSaleEndpoint = '/api/store-sale';
  static const String getShippingGovernmentsEndpoint = '/api/get-shipping-governments';
  
  // API Helper Methods
  static String getNewProductsUrl({int perPage = 10, int page = 1}) {
    return '$newProductsEndpoint?per_page=$perPage&page=$page';
  }
} 