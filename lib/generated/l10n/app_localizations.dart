import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Fit'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @package.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get dailyGoal;

  /// No description provided for @workouts.
  ///
  /// In en, this message translates to:
  /// **'workouts'**
  String get workouts;

  /// No description provided for @showAllProducts.
  ///
  /// In en, this message translates to:
  /// **'Show all Products'**
  String get showAllProducts;

  /// No description provided for @newProducts.
  ///
  /// In en, this message translates to:
  /// **'New Products'**
  String get newProducts;

  /// No description provided for @yourActivity.
  ///
  /// In en, this message translates to:
  /// **'Your Activity'**
  String get yourActivity;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sets;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get reps;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureLogout;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @microphone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get microphone;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @specialDietHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your special diet requirements (optional)'**
  String get specialDietHint;

  /// No description provided for @injuryHint.
  ///
  /// In en, this message translates to:
  /// **'Describe any current or previous injuries (optional)'**
  String get injuryHint;

  /// No description provided for @buildingPlan.
  ///
  /// In en, this message translates to:
  /// **'We\'re building your personalized plan'**
  String get buildingPlan;

  /// No description provided for @journeyStarts.
  ///
  /// In en, this message translates to:
  /// **'Your journey starts in a few seconds.'**
  String get journeyStarts;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @scanYourMeal.
  ///
  /// In en, this message translates to:
  /// **'Scan Your Meal'**
  String get scanYourMeal;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @totalKcal.
  ///
  /// In en, this message translates to:
  /// **'Total 180 Kcal'**
  String get totalKcal;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @mealScannedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Meal scanned successfully!'**
  String get mealScannedSuccessfully;

  /// No description provided for @tapCameraToScan.
  ///
  /// In en, this message translates to:
  /// **'Tap the camera button to scan your meal'**
  String get tapCameraToScan;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @incomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get incomplete;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @brightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// No description provided for @contrast.
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get contrast;

  /// No description provided for @opacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get opacity;

  /// No description provided for @transparency.
  ///
  /// In en, this message translates to:
  /// **'Transparency'**
  String get transparency;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @autoMode.
  ///
  /// In en, this message translates to:
  /// **'Auto Mode'**
  String get autoMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// No description provided for @customMode.
  ///
  /// In en, this message translates to:
  /// **'Custom Mode'**
  String get customMode;

  /// No description provided for @defaultMode.
  ///
  /// In en, this message translates to:
  /// **'Default Mode'**
  String get defaultMode;

  /// No description provided for @premiumMode.
  ///
  /// In en, this message translates to:
  /// **'Premium Mode'**
  String get premiumMode;

  /// No description provided for @freeMode.
  ///
  /// In en, this message translates to:
  /// **'Free Mode'**
  String get freeMode;

  /// No description provided for @trialMode.
  ///
  /// In en, this message translates to:
  /// **'Trial Mode'**
  String get trialMode;

  /// No description provided for @subscriptionMode.
  ///
  /// In en, this message translates to:
  /// **'Subscription Mode'**
  String get subscriptionMode;

  /// No description provided for @oneTimeMode.
  ///
  /// In en, this message translates to:
  /// **'One Time Mode'**
  String get oneTimeMode;

  /// No description provided for @monthlyMode.
  ///
  /// In en, this message translates to:
  /// **'Monthly Mode'**
  String get monthlyMode;

  /// No description provided for @yearlyMode.
  ///
  /// In en, this message translates to:
  /// **'Yearly Mode'**
  String get yearlyMode;

  /// No description provided for @lifetimeMode.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Mode'**
  String get lifetimeMode;

  /// No description provided for @unlimitedMode.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Mode'**
  String get unlimitedMode;

  /// No description provided for @limitedMode.
  ///
  /// In en, this message translates to:
  /// **'Limited Mode'**
  String get limitedMode;

  /// No description provided for @basicMode.
  ///
  /// In en, this message translates to:
  /// **'Basic Mode'**
  String get basicMode;

  /// No description provided for @advancedMode.
  ///
  /// In en, this message translates to:
  /// **'Advanced Mode'**
  String get advancedMode;

  /// No description provided for @professionalMode.
  ///
  /// In en, this message translates to:
  /// **'Professional Mode'**
  String get professionalMode;

  /// No description provided for @enterpriseMode.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Mode'**
  String get enterpriseMode;

  /// No description provided for @personalMode.
  ///
  /// In en, this message translates to:
  /// **'Personal Mode'**
  String get personalMode;

  /// No description provided for @businessMode.
  ///
  /// In en, this message translates to:
  /// **'Business Mode'**
  String get businessMode;

  /// No description provided for @studentMode.
  ///
  /// In en, this message translates to:
  /// **'Student Mode'**
  String get studentMode;

  /// No description provided for @familyMode.
  ///
  /// In en, this message translates to:
  /// **'Family Mode'**
  String get familyMode;

  /// No description provided for @teamMode.
  ///
  /// In en, this message translates to:
  /// **'Team Mode'**
  String get teamMode;

  /// No description provided for @organizationMode.
  ///
  /// In en, this message translates to:
  /// **'Organization Mode'**
  String get organizationMode;

  /// No description provided for @companyMode.
  ///
  /// In en, this message translates to:
  /// **'Company Mode'**
  String get companyMode;

  /// No description provided for @corporateMode.
  ///
  /// In en, this message translates to:
  /// **'Corporate Mode'**
  String get corporateMode;

  /// No description provided for @governmentMode.
  ///
  /// In en, this message translates to:
  /// **'Government Mode'**
  String get governmentMode;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @mainGoal.
  ///
  /// In en, this message translates to:
  /// **'Main Goal'**
  String get mainGoal;

  /// No description provided for @favouriteExercise.
  ///
  /// In en, this message translates to:
  /// **'Favourite Exercise'**
  String get favouriteExercise;

  /// No description provided for @loginInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password for login'**
  String get loginInstructions;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'Kcal'**
  String get kcal;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @browseProducts.
  ///
  /// In en, this message translates to:
  /// **'Browse Products'**
  String get browseProducts;

  /// No description provided for @favoriteProducts.
  ///
  /// In en, this message translates to:
  /// **'Favorite Products'**
  String get favoriteProducts;

  /// No description provided for @productAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart successfully'**
  String get productAddedToCart;

  /// No description provided for @productRemovedFromCart.
  ///
  /// In en, this message translates to:
  /// **'Product removed from cart'**
  String get productRemovedFromCart;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @targetWeight.
  ///
  /// In en, this message translates to:
  /// **'Target Weight'**
  String get targetWeight;

  /// No description provided for @currentActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Current Activity Level'**
  String get currentActivityLevel;

  /// No description provided for @preferredTrainingTypes.
  ///
  /// In en, this message translates to:
  /// **'Preferred Training Types'**
  String get preferredTrainingTypes;

  /// No description provided for @availableEquipment.
  ///
  /// In en, this message translates to:
  /// **'Available Equipment'**
  String get availableEquipment;

  /// No description provided for @currentDietSystem.
  ///
  /// In en, this message translates to:
  /// **'Current Diet System'**
  String get currentDietSystem;

  /// No description provided for @healthStatus.
  ///
  /// In en, this message translates to:
  /// **'Health Status'**
  String get healthStatus;

  /// No description provided for @planIncludes.
  ///
  /// In en, this message translates to:
  /// **'Plan Includes'**
  String get planIncludes;

  /// No description provided for @increaseMuscle.
  ///
  /// In en, this message translates to:
  /// **'Increase Muscle'**
  String get increaseMuscle;

  /// No description provided for @profileManagement.
  ///
  /// In en, this message translates to:
  /// **'Profile Management'**
  String get profileManagement;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @paymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment Info'**
  String get paymentInfo;

  /// No description provided for @logoutSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Logout Successful!'**
  String get logoutSuccessful;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout Failed'**
  String get logoutFailed;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated!'**
  String get profileUpdated;

  /// No description provided for @profileRefreshedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your profile data has been refreshed successfully'**
  String get profileRefreshedSuccessfully;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get required;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @genderRequired.
  ///
  /// In en, this message translates to:
  /// **'Gender is required'**
  String get genderRequired;

  /// No description provided for @letsGetYouStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get You Started'**
  String get letsGetYouStarted;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get signInWithFacebook;

  /// No description provided for @dontHaveAccountSignUp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get dontHaveAccountSignUp;

  /// No description provided for @alreadyHaveAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get alreadyHaveAccountSignIn;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createYourAccount;

  /// No description provided for @enterYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to create your account'**
  String get enterYourDetails;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions'**
  String get agreeToTerms;

  /// No description provided for @agreeToPrivacy.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Privacy Policy'**
  String get agreeToPrivacy;

  /// No description provided for @scanYourExercise.
  ///
  /// In en, this message translates to:
  /// **'Scan Your Exercise'**
  String get scanYourExercise;

  /// No description provided for @takePhotoOfExercise.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your exercise'**
  String get takePhotoOfExercise;

  /// No description provided for @exerciseDetected.
  ///
  /// In en, this message translates to:
  /// **'Exercise Detected'**
  String get exerciseDetected;

  /// No description provided for @noExerciseDetected.
  ///
  /// In en, this message translates to:
  /// **'No Exercise Detected'**
  String get noExerciseDetected;

  /// No description provided for @tryAgainWithBetterPhoto.
  ///
  /// In en, this message translates to:
  /// **'Try again with a better photo'**
  String get tryAgainWithBetterPhoto;

  /// No description provided for @exerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise Name'**
  String get exerciseName;

  /// No description provided for @exerciseDescription.
  ///
  /// In en, this message translates to:
  /// **'Exercise Description'**
  String get exerciseDescription;

  /// No description provided for @setsAndReps.
  ///
  /// In en, this message translates to:
  /// **'Sets and Reps'**
  String get setsAndReps;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get startWorkout;

  /// No description provided for @pauseWorkout.
  ///
  /// In en, this message translates to:
  /// **'Pause Workout'**
  String get pauseWorkout;

  /// No description provided for @resumeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Resume Workout'**
  String get resumeWorkout;

  /// No description provided for @finishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Finish Workout'**
  String get finishWorkout;

  /// No description provided for @workoutComplete.
  ///
  /// In en, this message translates to:
  /// **'Workout Complete'**
  String get workoutComplete;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get greatJob;

  /// No description provided for @workoutSummary.
  ///
  /// In en, this message translates to:
  /// **'Workout Summary'**
  String get workoutSummary;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @caloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Calories Burned'**
  String get caloriesBurned;

  /// No description provided for @exercisesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Exercises Completed'**
  String get exercisesCompleted;

  /// No description provided for @shareYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Share Your Progress'**
  String get shareYourProgress;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get addToCart;

  /// No description provided for @removeFromCart.
  ///
  /// In en, this message translates to:
  /// **'Remove from Cart'**
  String get removeFromCart;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCode;

  /// No description provided for @applyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get applyCoupon;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @debitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit Card'**
  String get debitCard;

  /// No description provided for @paypal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get paypal;

  /// No description provided for @applePay.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get applePay;

  /// No description provided for @googlePay.
  ///
  /// In en, this message translates to:
  /// **'Google Pay'**
  String get googlePay;

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cashOnDelivery;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get orderConfirmed;

  /// No description provided for @thankYouForYourOrder.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your order!'**
  String get thankYouForYourOrder;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @estimatedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get estimatedDelivery;

  /// No description provided for @trackYourOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Your Order'**
  String get trackYourOrder;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// No description provided for @returnRequested.
  ///
  /// In en, this message translates to:
  /// **'Return Requested'**
  String get returnRequested;

  /// No description provided for @returnApproved.
  ///
  /// In en, this message translates to:
  /// **'Return Approved'**
  String get returnApproved;

  /// No description provided for @returnRejected.
  ///
  /// In en, this message translates to:
  /// **'Return Rejected'**
  String get returnRejected;

  /// No description provided for @returnCompleted.
  ///
  /// In en, this message translates to:
  /// **'Return Completed'**
  String get returnCompleted;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get writeReview;

  /// No description provided for @rateProduct.
  ///
  /// In en, this message translates to:
  /// **'Rate Product'**
  String get rateProduct;

  /// No description provided for @writeYourReview.
  ///
  /// In en, this message translates to:
  /// **'Write your review'**
  String get writeYourReview;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review Submitted'**
  String get reviewSubmitted;

  /// No description provided for @thankYouForReview.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your review!'**
  String get thankYouForReview;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get averageRating;

  /// No description provided for @basedOnReviews.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} reviews'**
  String basedOnReviews(Object count);

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @beTheFirstToReview.
  ///
  /// In en, this message translates to:
  /// **'Be the first to review this product'**
  String get beTheFirstToReview;

  /// No description provided for @helpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get helpful;

  /// No description provided for @notHelpful.
  ///
  /// In en, this message translates to:
  /// **'Not Helpful'**
  String get notHelpful;

  /// No description provided for @reportReview.
  ///
  /// In en, this message translates to:
  /// **'Report Review'**
  String get reportReview;

  /// No description provided for @reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report Submitted'**
  String get reportSubmitted;

  /// No description provided for @thankYouForReport.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your report'**
  String get thankYouForReport;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search Products'**
  String get searchProducts;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords'**
  String get tryDifferentKeywords;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newestFirst;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get oldestFirst;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @bestSelling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get bestSelling;

  /// No description provided for @topRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter By'**
  String get filterBy;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @limitedStock.
  ///
  /// In en, this message translates to:
  /// **'Limited Stock'**
  String get limitedStock;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get resetFilters;

  /// No description provided for @showResults.
  ///
  /// In en, this message translates to:
  /// **'Show Results'**
  String get showResults;

  /// No description provided for @hideResults.
  ///
  /// In en, this message translates to:
  /// **'Hide Results'**
  String get hideResults;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @noMoreItems.
  ///
  /// In en, this message translates to:
  /// **'No more items'**
  String get noMoreItems;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing'**
  String get refreshing;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @releaseToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Release to refresh'**
  String get releaseToRefresh;

  /// No description provided for @refreshed.
  ///
  /// In en, this message translates to:
  /// **'Refreshed'**
  String get refreshed;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(Object count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(Object count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(Object count);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks ago'**
  String weeksAgo(Object count);

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String monthsAgo(Object count);

  /// No description provided for @yearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} years ago'**
  String yearsAgo(Object count);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next Week'**
  String get nextWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next Month'**
  String get nextMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @lastYear.
  ///
  /// In en, this message translates to:
  /// **'Last Year'**
  String get lastYear;

  /// No description provided for @nextYear.
  ///
  /// In en, this message translates to:
  /// **'Next Year'**
  String get nextYear;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @pace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get pace;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @floors.
  ///
  /// In en, this message translates to:
  /// **'Floors'**
  String get floors;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get bmi;

  /// No description provided for @bodyFat.
  ///
  /// In en, this message translates to:
  /// **'Body Fat'**
  String get bodyFat;

  /// No description provided for @muscleMass.
  ///
  /// In en, this message translates to:
  /// **'Muscle Mass'**
  String get muscleMass;

  /// No description provided for @boneMass.
  ///
  /// In en, this message translates to:
  /// **'Bone Mass'**
  String get boneMass;

  /// No description provided for @waterPercentage.
  ///
  /// In en, this message translates to:
  /// **'Water Percentage'**
  String get waterPercentage;

  /// No description provided for @metabolicAge.
  ///
  /// In en, this message translates to:
  /// **'Metabolic Age'**
  String get metabolicAge;

  /// No description provided for @visceralFat.
  ///
  /// In en, this message translates to:
  /// **'Visceral Fat'**
  String get visceralFat;

  /// No description provided for @fiber.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get fiber;

  /// No description provided for @sugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get sugar;

  /// No description provided for @sodium.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get sodium;

  /// No description provided for @cholesterol.
  ///
  /// In en, this message translates to:
  /// **'Cholesterol'**
  String get cholesterol;

  /// No description provided for @saturatedFat.
  ///
  /// In en, this message translates to:
  /// **'Saturated Fat'**
  String get saturatedFat;

  /// No description provided for @transFat.
  ///
  /// In en, this message translates to:
  /// **'Trans Fat'**
  String get transFat;

  /// No description provided for @monounsaturatedFat.
  ///
  /// In en, this message translates to:
  /// **'Monounsaturated Fat'**
  String get monounsaturatedFat;

  /// No description provided for @polyunsaturatedFat.
  ///
  /// In en, this message translates to:
  /// **'Polyunsaturated Fat'**
  String get polyunsaturatedFat;

  /// No description provided for @omega3.
  ///
  /// In en, this message translates to:
  /// **'Omega-3'**
  String get omega3;

  /// No description provided for @omega6.
  ///
  /// In en, this message translates to:
  /// **'Omega-6'**
  String get omega6;

  /// No description provided for @vitaminA.
  ///
  /// In en, this message translates to:
  /// **'Vitamin A'**
  String get vitaminA;

  /// No description provided for @vitaminB.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B'**
  String get vitaminB;

  /// No description provided for @vitaminC.
  ///
  /// In en, this message translates to:
  /// **'Vitamin C'**
  String get vitaminC;

  /// No description provided for @vitaminD.
  ///
  /// In en, this message translates to:
  /// **'Vitamin D'**
  String get vitaminD;

  /// No description provided for @vitaminE.
  ///
  /// In en, this message translates to:
  /// **'Vitamin E'**
  String get vitaminE;

  /// No description provided for @vitaminK.
  ///
  /// In en, this message translates to:
  /// **'Vitamin K'**
  String get vitaminK;

  /// No description provided for @calcium.
  ///
  /// In en, this message translates to:
  /// **'Calcium'**
  String get calcium;

  /// No description provided for @iron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get iron;

  /// No description provided for @magnesium.
  ///
  /// In en, this message translates to:
  /// **'Magnesium'**
  String get magnesium;

  /// No description provided for @phosphorus.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus'**
  String get phosphorus;

  /// No description provided for @potassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get potassium;

  /// No description provided for @zinc.
  ///
  /// In en, this message translates to:
  /// **'Zinc'**
  String get zinc;

  /// No description provided for @copper.
  ///
  /// In en, this message translates to:
  /// **'Copper'**
  String get copper;

  /// No description provided for @manganese.
  ///
  /// In en, this message translates to:
  /// **'Manganese'**
  String get manganese;

  /// No description provided for @selenium.
  ///
  /// In en, this message translates to:
  /// **'Selenium'**
  String get selenium;

  /// No description provided for @iodine.
  ///
  /// In en, this message translates to:
  /// **'Iodine'**
  String get iodine;

  /// No description provided for @fluoride.
  ///
  /// In en, this message translates to:
  /// **'Fluoride'**
  String get fluoride;

  /// No description provided for @chromium.
  ///
  /// In en, this message translates to:
  /// **'Chromium'**
  String get chromium;

  /// No description provided for @molybdenum.
  ///
  /// In en, this message translates to:
  /// **'Molybdenum'**
  String get molybdenum;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @meal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get meal;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @drink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get drink;

  /// No description provided for @waterIntake.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get waterIntake;

  /// No description provided for @hydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get hydration;

  /// No description provided for @dehydration.
  ///
  /// In en, this message translates to:
  /// **'Dehydration'**
  String get dehydration;

  /// No description provided for @overhydration.
  ///
  /// In en, this message translates to:
  /// **'Overhydration'**
  String get overhydration;

  /// No description provided for @fluidBalance.
  ///
  /// In en, this message translates to:
  /// **'Fluid Balance'**
  String get fluidBalance;

  /// No description provided for @electrolytes.
  ///
  /// In en, this message translates to:
  /// **'Electrolytes'**
  String get electrolytes;

  /// No description provided for @chloride.
  ///
  /// In en, this message translates to:
  /// **'Chloride'**
  String get chloride;

  /// No description provided for @bicarbonate.
  ///
  /// In en, this message translates to:
  /// **'Bicarbonate'**
  String get bicarbonate;

  /// No description provided for @phosphate.
  ///
  /// In en, this message translates to:
  /// **'Phosphate'**
  String get phosphate;

  /// No description provided for @sulfate.
  ///
  /// In en, this message translates to:
  /// **'Sulfate'**
  String get sulfate;

  /// No description provided for @vitaminB1.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B1'**
  String get vitaminB1;

  /// No description provided for @vitaminB2.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B2'**
  String get vitaminB2;

  /// No description provided for @vitaminB3.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B3'**
  String get vitaminB3;

  /// No description provided for @vitaminB5.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B5'**
  String get vitaminB5;

  /// No description provided for @vitaminB6.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B6'**
  String get vitaminB6;

  /// No description provided for @vitaminB7.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B7'**
  String get vitaminB7;

  /// No description provided for @vitaminB9.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B9'**
  String get vitaminB9;

  /// No description provided for @vitaminB12.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B12'**
  String get vitaminB12;

  /// No description provided for @folate.
  ///
  /// In en, this message translates to:
  /// **'Folate'**
  String get folate;

  /// No description provided for @biotin.
  ///
  /// In en, this message translates to:
  /// **'Biotin'**
  String get biotin;

  /// No description provided for @choline.
  ///
  /// In en, this message translates to:
  /// **'Choline'**
  String get choline;

  /// No description provided for @inositol.
  ///
  /// In en, this message translates to:
  /// **'Inositol'**
  String get inositol;

  /// No description provided for @carnitine.
  ///
  /// In en, this message translates to:
  /// **'Carnitine'**
  String get carnitine;

  /// No description provided for @coenzymeQ10.
  ///
  /// In en, this message translates to:
  /// **'Coenzyme Q10'**
  String get coenzymeQ10;

  /// No description provided for @alphaLipoicAcid.
  ///
  /// In en, this message translates to:
  /// **'Alpha Lipoic Acid'**
  String get alphaLipoicAcid;

  /// No description provided for @glutathione.
  ///
  /// In en, this message translates to:
  /// **'Glutathione'**
  String get glutathione;

  /// No description provided for @melatonin.
  ///
  /// In en, this message translates to:
  /// **'Melatonin'**
  String get melatonin;

  /// No description provided for @probiotics.
  ///
  /// In en, this message translates to:
  /// **'Probiotics'**
  String get probiotics;

  /// No description provided for @prebiotics.
  ///
  /// In en, this message translates to:
  /// **'Prebiotics'**
  String get prebiotics;

  /// No description provided for @antioxidants.
  ///
  /// In en, this message translates to:
  /// **'Antioxidants'**
  String get antioxidants;

  /// No description provided for @polyphenols.
  ///
  /// In en, this message translates to:
  /// **'Polyphenols'**
  String get polyphenols;

  /// No description provided for @flavonoids.
  ///
  /// In en, this message translates to:
  /// **'Flavonoids'**
  String get flavonoids;

  /// No description provided for @carotenoids.
  ///
  /// In en, this message translates to:
  /// **'Carotenoids'**
  String get carotenoids;

  /// No description provided for @lycopene.
  ///
  /// In en, this message translates to:
  /// **'Lycopene'**
  String get lycopene;

  /// No description provided for @betaCarotene.
  ///
  /// In en, this message translates to:
  /// **'Beta Carotene'**
  String get betaCarotene;

  /// No description provided for @lutein.
  ///
  /// In en, this message translates to:
  /// **'Lutein'**
  String get lutein;

  /// No description provided for @zeaxanthin.
  ///
  /// In en, this message translates to:
  /// **'Zeaxanthin'**
  String get zeaxanthin;

  /// No description provided for @astaxanthin.
  ///
  /// In en, this message translates to:
  /// **'Astaxanthin'**
  String get astaxanthin;

  /// No description provided for @resveratrol.
  ///
  /// In en, this message translates to:
  /// **'Resveratrol'**
  String get resveratrol;

  /// No description provided for @curcumin.
  ///
  /// In en, this message translates to:
  /// **'Curcumin'**
  String get curcumin;

  /// No description provided for @quercetin.
  ///
  /// In en, this message translates to:
  /// **'Quercetin'**
  String get quercetin;

  /// No description provided for @catechins.
  ///
  /// In en, this message translates to:
  /// **'Catechins'**
  String get catechins;

  /// No description provided for @epigallocatechin.
  ///
  /// In en, this message translates to:
  /// **'Epigallocatechin'**
  String get epigallocatechin;

  /// No description provided for @theanine.
  ///
  /// In en, this message translates to:
  /// **'Theanine'**
  String get theanine;

  /// No description provided for @caffeine.
  ///
  /// In en, this message translates to:
  /// **'Caffeine'**
  String get caffeine;

  /// No description provided for @creatine.
  ///
  /// In en, this message translates to:
  /// **'Creatine'**
  String get creatine;

  /// No description provided for @betaAlanine.
  ///
  /// In en, this message translates to:
  /// **'Beta Alanine'**
  String get betaAlanine;

  /// No description provided for @bcaa.
  ///
  /// In en, this message translates to:
  /// **'BCAA'**
  String get bcaa;

  /// No description provided for @leucine.
  ///
  /// In en, this message translates to:
  /// **'Leucine'**
  String get leucine;

  /// No description provided for @isoleucine.
  ///
  /// In en, this message translates to:
  /// **'Isoleucine'**
  String get isoleucine;

  /// No description provided for @valine.
  ///
  /// In en, this message translates to:
  /// **'Valine'**
  String get valine;

  /// No description provided for @glutamine.
  ///
  /// In en, this message translates to:
  /// **'Glutamine'**
  String get glutamine;

  /// No description provided for @arginine.
  ///
  /// In en, this message translates to:
  /// **'Arginine'**
  String get arginine;

  /// No description provided for @citrulline.
  ///
  /// In en, this message translates to:
  /// **'Citrulline'**
  String get citrulline;

  /// No description provided for @ornithine.
  ///
  /// In en, this message translates to:
  /// **'Ornithine'**
  String get ornithine;

  /// No description provided for @taurine.
  ///
  /// In en, this message translates to:
  /// **'Taurine'**
  String get taurine;

  /// No description provided for @tyrosine.
  ///
  /// In en, this message translates to:
  /// **'Tyrosine'**
  String get tyrosine;

  /// No description provided for @tryptophan.
  ///
  /// In en, this message translates to:
  /// **'Tryptophan'**
  String get tryptophan;

  /// No description provided for @phenylalanine.
  ///
  /// In en, this message translates to:
  /// **'Phenylalanine'**
  String get phenylalanine;

  /// No description provided for @histidine.
  ///
  /// In en, this message translates to:
  /// **'Histidine'**
  String get histidine;

  /// No description provided for @lysine.
  ///
  /// In en, this message translates to:
  /// **'Lysine'**
  String get lysine;

  /// No description provided for @methionine.
  ///
  /// In en, this message translates to:
  /// **'Methionine'**
  String get methionine;

  /// No description provided for @threonine.
  ///
  /// In en, this message translates to:
  /// **'Threonine'**
  String get threonine;

  /// No description provided for @serine.
  ///
  /// In en, this message translates to:
  /// **'Serine'**
  String get serine;

  /// No description provided for @asparagine.
  ///
  /// In en, this message translates to:
  /// **'Asparagine'**
  String get asparagine;

  /// No description provided for @asparticAcid.
  ///
  /// In en, this message translates to:
  /// **'Aspartic Acid'**
  String get asparticAcid;

  /// No description provided for @glutamicAcid.
  ///
  /// In en, this message translates to:
  /// **'Glutamic Acid'**
  String get glutamicAcid;

  /// No description provided for @proline.
  ///
  /// In en, this message translates to:
  /// **'Proline'**
  String get proline;

  /// No description provided for @glycine.
  ///
  /// In en, this message translates to:
  /// **'Glycine'**
  String get glycine;

  /// No description provided for @alanine.
  ///
  /// In en, this message translates to:
  /// **'Alanine'**
  String get alanine;

  /// No description provided for @cysteine.
  ///
  /// In en, this message translates to:
  /// **'Cysteine'**
  String get cysteine;

  /// No description provided for @selenocysteine.
  ///
  /// In en, this message translates to:
  /// **'Selenocysteine'**
  String get selenocysteine;

  /// No description provided for @pyrrolysine.
  ///
  /// In en, this message translates to:
  /// **'Pyrrolysine'**
  String get pyrrolysine;

  /// No description provided for @hydroxyproline.
  ///
  /// In en, this message translates to:
  /// **'Hydroxyproline'**
  String get hydroxyproline;

  /// No description provided for @hydroxylysine.
  ///
  /// In en, this message translates to:
  /// **'Hydroxylysine'**
  String get hydroxylysine;

  /// No description provided for @methylhistidine.
  ///
  /// In en, this message translates to:
  /// **'Methylhistidine'**
  String get methylhistidine;

  /// No description provided for @carnosine.
  ///
  /// In en, this message translates to:
  /// **'Carnosine'**
  String get carnosine;

  /// No description provided for @anserine.
  ///
  /// In en, this message translates to:
  /// **'Anserine'**
  String get anserine;

  /// No description provided for @balenine.
  ///
  /// In en, this message translates to:
  /// **'Balenine'**
  String get balenine;

  /// No description provided for @homocarnosine.
  ///
  /// In en, this message translates to:
  /// **'Homocarnosine'**
  String get homocarnosine;

  /// No description provided for @acetylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Acetylcarnitine'**
  String get acetylcarnitine;

  /// No description provided for @propionylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Propionylcarnitine'**
  String get propionylcarnitine;

  /// No description provided for @butyrylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Butyrylcarnitine'**
  String get butyrylcarnitine;

  /// No description provided for @isovalerylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Isovalerylcarnitine'**
  String get isovalerylcarnitine;

  /// No description provided for @valerylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Valerylcarnitine'**
  String get valerylcarnitine;

  /// No description provided for @hexanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Hexanoylcarnitine'**
  String get hexanoylcarnitine;

  /// No description provided for @octanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Octanoylcarnitine'**
  String get octanoylcarnitine;

  /// No description provided for @decanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Decanoylcarnitine'**
  String get decanoylcarnitine;

  /// No description provided for @dodecanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Dodecanoylcarnitine'**
  String get dodecanoylcarnitine;

  /// No description provided for @tetradecanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Tetradecanoylcarnitine'**
  String get tetradecanoylcarnitine;

  /// No description provided for @hexadecanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Hexadecanoylcarnitine'**
  String get hexadecanoylcarnitine;

  /// No description provided for @octadecanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Octadecanoylcarnitine'**
  String get octadecanoylcarnitine;

  /// No description provided for @oleoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Oleoylcarnitine'**
  String get oleoylcarnitine;

  /// No description provided for @linoleoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Linoleoylcarnitine'**
  String get linoleoylcarnitine;

  /// No description provided for @linolenoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Linolenoylcarnitine'**
  String get linolenoylcarnitine;

  /// No description provided for @arachidonoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Arachidonoylcarnitine'**
  String get arachidonoylcarnitine;

  /// No description provided for @docosahexaenoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Docosahexaenoylcarnitine'**
  String get docosahexaenoylcarnitine;

  /// No description provided for @eicosapentaenoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Eicosapentaenoylcarnitine'**
  String get eicosapentaenoylcarnitine;

  /// No description provided for @palmitoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Palmitoylcarnitine'**
  String get palmitoylcarnitine;

  /// No description provided for @stearoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Stearoylcarnitine'**
  String get stearoylcarnitine;

  /// No description provided for @myristoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Myristoylcarnitine'**
  String get myristoylcarnitine;

  /// No description provided for @laurylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Laurylcarnitine'**
  String get laurylcarnitine;

  /// No description provided for @caproylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Caproylcarnitine'**
  String get caproylcarnitine;

  /// No description provided for @caprylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Caprylcarnitine'**
  String get caprylcarnitine;

  /// No description provided for @capriccarnitine.
  ///
  /// In en, this message translates to:
  /// **'Capriccarnitine'**
  String get capriccarnitine;

  /// No description provided for @undecanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Undecanoylcarnitine'**
  String get undecanoylcarnitine;

  /// No description provided for @tridecanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Tridecanoylcarnitine'**
  String get tridecanoylcarnitine;

  /// No description provided for @pentadecanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Pentadecanoylcarnitine'**
  String get pentadecanoylcarnitine;

  /// No description provided for @heptadecanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Heptadecanoylcarnitine'**
  String get heptadecanoylcarnitine;

  /// No description provided for @nonadecanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Nonadecanoylcarnitine'**
  String get nonadecanoylcarnitine;

  /// No description provided for @heneicosanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Heneicosanoylcarnitine'**
  String get heneicosanoylcarnitine;

  /// No description provided for @tricosanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Tricosanoylcarnitine'**
  String get tricosanoylcarnitine;

  /// No description provided for @pentacosanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Pentacosanoylcarnitine'**
  String get pentacosanoylcarnitine;

  /// No description provided for @heptacosanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Heptacosanoylcarnitine'**
  String get heptacosanoylcarnitine;

  /// No description provided for @nonacosanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Nonacosanoylcarnitine'**
  String get nonacosanoylcarnitine;

  /// No description provided for @hentriacontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Hentriacontanoylcarnitine'**
  String get hentriacontanoylcarnitine;

  /// No description provided for @tritriacontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Tritriacontanoylcarnitine'**
  String get tritriacontanoylcarnitine;

  /// No description provided for @pentatriacontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Pentatriacontanoylcarnitine'**
  String get pentatriacontanoylcarnitine;

  /// No description provided for @heptatriacontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Heptatriacontanoylcarnitine'**
  String get heptatriacontanoylcarnitine;

  /// No description provided for @nonatriacontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Nonatriacontanoylcarnitine'**
  String get nonatriacontanoylcarnitine;

  /// No description provided for @tetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Tetracontanoylcarnitine'**
  String get tetracontanoylcarnitine;

  /// No description provided for @hentetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Hentetracontanoylcarnitine'**
  String get hentetracontanoylcarnitine;

  /// No description provided for @dotetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Dotetracontanoylcarnitine'**
  String get dotetracontanoylcarnitine;

  /// No description provided for @tritetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Tritetracontanoylcarnitine'**
  String get tritetracontanoylcarnitine;

  /// No description provided for @tetratetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Tetratetracontanoylcarnitine'**
  String get tetratetracontanoylcarnitine;

  /// No description provided for @pentatetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Pentatetracontanoylcarnitine'**
  String get pentatetracontanoylcarnitine;

  /// No description provided for @hexatetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Hexatetracontanoylcarnitine'**
  String get hexatetracontanoylcarnitine;

  /// No description provided for @heptatetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Heptatetracontanoylcarnitine'**
  String get heptatetracontanoylcarnitine;

  /// No description provided for @octatetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Octatetracontanoylcarnitine'**
  String get octatetracontanoylcarnitine;

  /// No description provided for @nonatetracontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Nonatetracontanoylcarnitine'**
  String get nonatetracontanoylcarnitine;

  /// No description provided for @pentacontanoylcarnitine.
  ///
  /// In en, this message translates to:
  /// **'Pentacontanoylcarnitine'**
  String get pentacontanoylcarnitine;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @clearImage.
  ///
  /// In en, this message translates to:
  /// **'Clear Image'**
  String get clearImage;

  /// No description provided for @stopScan.
  ///
  /// In en, this message translates to:
  /// **'Stop Scan'**
  String get stopScan;

  /// No description provided for @letsSetUpYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Set Up Your Plan'**
  String get letsSetUpYourPlan;

  /// No description provided for @noDietSystemOptionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No diet system options available'**
  String get noDietSystemOptionsAvailable;

  /// No description provided for @failedToLoadDietSystemOptions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load diet system options'**
  String get failedToLoadDietSystemOptions;

  /// No description provided for @noActivityLevelOptionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No activity level options available'**
  String get noActivityLevelOptionsAvailable;

  /// No description provided for @failedToLoadActivityLevelOptions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load activity level options'**
  String get failedToLoadActivityLevelOptions;

  /// No description provided for @errorLoadingAgeOptions.
  ///
  /// In en, this message translates to:
  /// **'Error loading age options'**
  String get errorLoadingAgeOptions;

  /// No description provided for @noAgeOptionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No age options available'**
  String get noAgeOptionsAvailable;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @failedToLoadCartItems.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cart items'**
  String get failedToLoadCartItems;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// No description provided for @addSomeProductsToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add some products to get started'**
  String get addSomeProductsToGetStarted;

  /// No description provided for @failedToRemoveProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove product'**
  String get failedToRemoveProduct;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Order Total'**
  String get orderTotal;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @failedToLoadFavoriteProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load favorite products'**
  String get failedToLoadFavoriteProducts;

  /// No description provided for @unknownErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownErrorOccurred;

  /// No description provided for @noFavoriteProducts.
  ///
  /// In en, this message translates to:
  /// **'No Favorite Products'**
  String get noFavoriteProducts;

  /// No description provided for @productsYouMarkAsFavoriteWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Products you mark as favorite will appear here'**
  String get productsYouMarkAsFavoriteWillAppearHere;

  /// No description provided for @failedToUpdateFavorite.
  ///
  /// In en, this message translates to:
  /// **'Failed to update favorite'**
  String get failedToUpdateFavorite;

  /// No description provided for @productDetail.
  ///
  /// In en, this message translates to:
  /// **'Product Detail'**
  String get productDetail;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @failedToAddProductToCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to add product to cart'**
  String get failedToAddProductToCart;

  /// No description provided for @adding.
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get adding;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// No description provided for @last6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get last6Months;

  /// No description provided for @noEquipment.
  ///
  /// In en, this message translates to:
  /// **'No Equipment'**
  String get noEquipment;

  /// No description provided for @matOnly.
  ///
  /// In en, this message translates to:
  /// **'Mat Only'**
  String get matOnly;

  /// No description provided for @machines.
  ///
  /// In en, this message translates to:
  /// **'Machines'**
  String get machines;

  /// No description provided for @atHome.
  ///
  /// In en, this message translates to:
  /// **'At Home'**
  String get atHome;

  /// No description provided for @atGym.
  ///
  /// In en, this message translates to:
  /// **'At Gym'**
  String get atGym;

  /// No description provided for @nonProfitMode.
  ///
  /// In en, this message translates to:
  /// **'Non Profit Mode'**
  String get nonProfitMode;

  /// No description provided for @charityMode.
  ///
  /// In en, this message translates to:
  /// **'Charity Mode'**
  String get charityMode;

  /// No description provided for @volunteerMode.
  ///
  /// In en, this message translates to:
  /// **'Volunteer Mode'**
  String get volunteerMode;

  /// No description provided for @communityMode.
  ///
  /// In en, this message translates to:
  /// **'Community Mode'**
  String get communityMode;

  /// No description provided for @publicMode.
  ///
  /// In en, this message translates to:
  /// **'Public Mode'**
  String get publicMode;

  /// No description provided for @privateMode.
  ///
  /// In en, this message translates to:
  /// **'Private Mode'**
  String get privateMode;

  /// No description provided for @sharedMode.
  ///
  /// In en, this message translates to:
  /// **'Shared Mode'**
  String get sharedMode;

  /// No description provided for @collaborativeMode.
  ///
  /// In en, this message translates to:
  /// **'Collaborative Mode'**
  String get collaborativeMode;

  /// No description provided for @socialMode.
  ///
  /// In en, this message translates to:
  /// **'Social Mode'**
  String get socialMode;

  /// No description provided for @networkingMode.
  ///
  /// In en, this message translates to:
  /// **'Networking Mode'**
  String get networkingMode;

  /// No description provided for @communicationMode.
  ///
  /// In en, this message translates to:
  /// **'Communication Mode'**
  String get communicationMode;

  /// No description provided for @messagingMode.
  ///
  /// In en, this message translates to:
  /// **'Messaging Mode'**
  String get messagingMode;

  /// No description provided for @chatMode.
  ///
  /// In en, this message translates to:
  /// **'Chat Mode'**
  String get chatMode;

  /// No description provided for @videoMode.
  ///
  /// In en, this message translates to:
  /// **'Video Mode'**
  String get videoMode;

  /// No description provided for @audioMode.
  ///
  /// In en, this message translates to:
  /// **'Audio Mode'**
  String get audioMode;

  /// No description provided for @imageMode.
  ///
  /// In en, this message translates to:
  /// **'Image Mode'**
  String get imageMode;

  /// No description provided for @documentMode.
  ///
  /// In en, this message translates to:
  /// **'Document Mode'**
  String get documentMode;

  /// No description provided for @fileMode.
  ///
  /// In en, this message translates to:
  /// **'File Mode'**
  String get fileMode;

  /// No description provided for @folderMode.
  ///
  /// In en, this message translates to:
  /// **'Folder Mode'**
  String get folderMode;

  /// No description provided for @directoryMode.
  ///
  /// In en, this message translates to:
  /// **'Directory Mode'**
  String get directoryMode;

  /// No description provided for @pathMode.
  ///
  /// In en, this message translates to:
  /// **'Path Mode'**
  String get pathMode;

  /// No description provided for @urlMode.
  ///
  /// In en, this message translates to:
  /// **'URL Mode'**
  String get urlMode;

  /// No description provided for @linkMode.
  ///
  /// In en, this message translates to:
  /// **'Link Mode'**
  String get linkMode;

  /// No description provided for @referenceMode.
  ///
  /// In en, this message translates to:
  /// **'Reference Mode'**
  String get referenceMode;

  /// No description provided for @sourceMode.
  ///
  /// In en, this message translates to:
  /// **'Source Mode'**
  String get sourceMode;

  /// No description provided for @targetMode.
  ///
  /// In en, this message translates to:
  /// **'Target Mode'**
  String get targetMode;

  /// No description provided for @destinationMode.
  ///
  /// In en, this message translates to:
  /// **'Destination Mode'**
  String get destinationMode;

  /// No description provided for @originMode.
  ///
  /// In en, this message translates to:
  /// **'Origin Mode'**
  String get originMode;

  /// No description provided for @beginningMode.
  ///
  /// In en, this message translates to:
  /// **'Beginning Mode'**
  String get beginningMode;

  /// No description provided for @endingMode.
  ///
  /// In en, this message translates to:
  /// **'Ending Mode'**
  String get endingMode;

  /// No description provided for @startMode.
  ///
  /// In en, this message translates to:
  /// **'Start Mode'**
  String get startMode;

  /// No description provided for @finishMode.
  ///
  /// In en, this message translates to:
  /// **'Finish Mode'**
  String get finishMode;

  /// No description provided for @completeMode.
  ///
  /// In en, this message translates to:
  /// **'Complete Mode'**
  String get completeMode;

  /// No description provided for @partialMode.
  ///
  /// In en, this message translates to:
  /// **'Partial Mode'**
  String get partialMode;

  /// No description provided for @fullMode.
  ///
  /// In en, this message translates to:
  /// **'Full Mode'**
  String get fullMode;

  /// No description provided for @emptyMode.
  ///
  /// In en, this message translates to:
  /// **'Empty Mode'**
  String get emptyMode;

  /// No description provided for @nullMode.
  ///
  /// In en, this message translates to:
  /// **'Null Mode'**
  String get nullMode;

  /// No description provided for @undefinedMode.
  ///
  /// In en, this message translates to:
  /// **'Undefined Mode'**
  String get undefinedMode;

  /// No description provided for @unknownMode.
  ///
  /// In en, this message translates to:
  /// **'Unknown Mode'**
  String get unknownMode;

  /// No description provided for @hiddenMode.
  ///
  /// In en, this message translates to:
  /// **'Hidden Mode'**
  String get hiddenMode;

  /// No description provided for @visibleMode.
  ///
  /// In en, this message translates to:
  /// **'Visible Mode'**
  String get visibleMode;

  /// No description provided for @shownMode.
  ///
  /// In en, this message translates to:
  /// **'Shown Mode'**
  String get shownMode;

  /// No description provided for @displayedMode.
  ///
  /// In en, this message translates to:
  /// **'Displayed Mode'**
  String get displayedMode;

  /// No description provided for @renderedMode.
  ///
  /// In en, this message translates to:
  /// **'Rendered Mode'**
  String get renderedMode;

  /// No description provided for @loadedMode.
  ///
  /// In en, this message translates to:
  /// **'Loaded Mode'**
  String get loadedMode;

  /// No description provided for @unloadedMode.
  ///
  /// In en, this message translates to:
  /// **'Unloaded Mode'**
  String get unloadedMode;

  /// No description provided for @cachedMode.
  ///
  /// In en, this message translates to:
  /// **'Cached Mode'**
  String get cachedMode;

  /// No description provided for @uncachedMode.
  ///
  /// In en, this message translates to:
  /// **'Uncached Mode'**
  String get uncachedMode;

  /// No description provided for @savedMode.
  ///
  /// In en, this message translates to:
  /// **'Saved Mode'**
  String get savedMode;

  /// No description provided for @unsavedMode.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Mode'**
  String get unsavedMode;

  /// No description provided for @modifiedMode.
  ///
  /// In en, this message translates to:
  /// **'Modified Mode'**
  String get modifiedMode;

  /// No description provided for @unmodifiedMode.
  ///
  /// In en, this message translates to:
  /// **'Unmodified Mode'**
  String get unmodifiedMode;

  /// No description provided for @updatedMode.
  ///
  /// In en, this message translates to:
  /// **'Updated Mode'**
  String get updatedMode;

  /// No description provided for @outdatedMode.
  ///
  /// In en, this message translates to:
  /// **'Outdated Mode'**
  String get outdatedMode;

  /// No description provided for @currentMode.
  ///
  /// In en, this message translates to:
  /// **'Current Mode'**
  String get currentMode;

  /// No description provided for @previousMode.
  ///
  /// In en, this message translates to:
  /// **'Previous Mode'**
  String get previousMode;

  /// No description provided for @nextMode.
  ///
  /// In en, this message translates to:
  /// **'Next Mode'**
  String get nextMode;

  /// No description provided for @lastMode.
  ///
  /// In en, this message translates to:
  /// **'Last Mode'**
  String get lastMode;

  /// No description provided for @firstMode.
  ///
  /// In en, this message translates to:
  /// **'First Mode'**
  String get firstMode;

  /// No description provided for @secondMode.
  ///
  /// In en, this message translates to:
  /// **'Second Mode'**
  String get secondMode;

  /// No description provided for @thirdMode.
  ///
  /// In en, this message translates to:
  /// **'Third Mode'**
  String get thirdMode;

  /// No description provided for @fourthMode.
  ///
  /// In en, this message translates to:
  /// **'Fourth Mode'**
  String get fourthMode;

  /// No description provided for @fifthMode.
  ///
  /// In en, this message translates to:
  /// **'Fifth Mode'**
  String get fifthMode;

  /// No description provided for @sixthMode.
  ///
  /// In en, this message translates to:
  /// **'Sixth Mode'**
  String get sixthMode;

  /// No description provided for @seventhMode.
  ///
  /// In en, this message translates to:
  /// **'Seventh Mode'**
  String get seventhMode;

  /// No description provided for @eighthMode.
  ///
  /// In en, this message translates to:
  /// **'Eighth Mode'**
  String get eighthMode;

  /// No description provided for @ninthMode.
  ///
  /// In en, this message translates to:
  /// **'Ninth Mode'**
  String get ninthMode;

  /// No description provided for @tenthMode.
  ///
  /// In en, this message translates to:
  /// **'Tenth Mode'**
  String get tenthMode;

  /// No description provided for @readyToStartYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Ready to start your journey?'**
  String get readyToStartYourJourney;

  /// No description provided for @youreOneStepAwayFromAHealthierYou.
  ///
  /// In en, this message translates to:
  /// **'You\'re One Step Away from a Healthier You'**
  String get youreOneStepAwayFromAHealthierYou;

  /// No description provided for @startYourPersonalizedWorkoutAndMealPlanNowToTransformYourBodyAndMind.
  ///
  /// In en, this message translates to:
  /// **'Start your personalized workout and meal plan now to transform your body and mind.'**
  String
  get startYourPersonalizedWorkoutAndMealPlanNowToTransformYourBodyAndMind;

  /// No description provided for @languageChangedToArabic.
  ///
  /// In en, this message translates to:
  /// **'Language changed to Arabic'**
  String get languageChangedToArabic;

  /// No description provided for @languageChangedToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Language changed to English'**
  String get languageChangedToEnglish;

  /// No description provided for @errorChangingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Error changing language'**
  String get errorChangingLanguage;

  /// No description provided for @yourProfileDataHasBeenRefreshedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your profile data has been refreshed successfully'**
  String get yourProfileDataHasBeenRefreshedSuccessfully;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @pleaseEnterYourCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get pleaseEnterYourCurrentPassword;

  /// No description provided for @pleaseEnterANewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get pleaseEnterANewPassword;

  /// No description provided for @passwordMustBeAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBeAtLeast8Characters;

  /// No description provided for @pleaseConfirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @failedToChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get failedToChangePassword;

  /// No description provided for @failedToChangePasswordPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password. Please try again.'**
  String get failedToChangePasswordPleaseTryAgain;

  /// No description provided for @noExercisesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No exercises available'**
  String get noExercisesAvailable;

  /// No description provided for @weCouldntFindAnyWorkoutDataRightNowPleaseCheckBackLater.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any workout data right now.\nPlease check back later!'**
  String get weCouldntFindAnyWorkoutDataRightNowPleaseCheckBackLater;

  /// No description provided for @searchExercises.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get searchExercises;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment;

  /// No description provided for @allExercise.
  ///
  /// In en, this message translates to:
  /// **'All exercise'**
  String get allExercise;

  /// No description provided for @noExercisesFound.
  ///
  /// In en, this message translates to:
  /// **'No exercises found'**
  String get noExercisesFound;

  /// No description provided for @tryAdjustingYourSearchOrFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingYourSearchOrFilters;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @tapToScanYourFood.
  ///
  /// In en, this message translates to:
  /// **'Tap to Scan your food'**
  String get tapToScanYourFood;

  /// No description provided for @yourMeals.
  ///
  /// In en, this message translates to:
  /// **'Your Meals'**
  String get yourMeals;

  /// No description provided for @noMealCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No meal categories found'**
  String get noMealCategoriesFound;

  /// No description provided for @thereAreNoMealCategoriesAvailableForThisDayPleaseTryAnotherDay.
  ///
  /// In en, this message translates to:
  /// **'There are no meal categories available for this day. Please try another day.'**
  String get thereAreNoMealCategoriesAvailableForThisDayPleaseTryAnotherDay;

  /// No description provided for @noMealsAvailableForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No meals available for this day'**
  String get noMealsAvailableForThisDay;

  /// No description provided for @whatsYourGender.
  ///
  /// In en, this message translates to:
  /// **'What\'s your gender?'**
  String get whatsYourGender;

  /// No description provided for @whatsYourAge.
  ///
  /// In en, this message translates to:
  /// **'What\'s your age?'**
  String get whatsYourAge;

  /// No description provided for @whatsYourHeight.
  ///
  /// In en, this message translates to:
  /// **'What\'s your height?'**
  String get whatsYourHeight;

  /// No description provided for @whatsYourWeight.
  ///
  /// In en, this message translates to:
  /// **'What\'s your weight?'**
  String get whatsYourWeight;

  /// No description provided for @whatsYourTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'What\'s your target weight?'**
  String get whatsYourTargetWeight;

  /// No description provided for @whatsYourMainGoal.
  ///
  /// In en, this message translates to:
  /// **'What\'s your main goal?'**
  String get whatsYourMainGoal;

  /// No description provided for @whatsYourActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'What\'s your activity level?'**
  String get whatsYourActivityLevel;

  /// No description provided for @whatsYourTrainingTypes.
  ///
  /// In en, this message translates to:
  /// **'What\'s your preferred training types?'**
  String get whatsYourTrainingTypes;

  /// No description provided for @whatsYourEquipment.
  ///
  /// In en, this message translates to:
  /// **'What\'s your available equipment?'**
  String get whatsYourEquipment;

  /// No description provided for @whatsYourDietSystem.
  ///
  /// In en, this message translates to:
  /// **'What\'s your current diet system?'**
  String get whatsYourDietSystem;

  /// No description provided for @whatsYourHealthStatus.
  ///
  /// In en, this message translates to:
  /// **'What\'s your health status?'**
  String get whatsYourHealthStatus;

  /// No description provided for @whatsYourSpecialDiet.
  ///
  /// In en, this message translates to:
  /// **'What\'s your special diet? (Describe)'**
  String get whatsYourSpecialDiet;

  /// No description provided for @whatsYourInjury.
  ///
  /// In en, this message translates to:
  /// **'What\'s your current or previous injury? (Describe)'**
  String get whatsYourInjury;

  /// No description provided for @whatsYourAdditionalGoals.
  ///
  /// In en, this message translates to:
  /// **'What\'s your additional goals (Optional)?'**
  String get whatsYourAdditionalGoals;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetPassword;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailPlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordPlaceholder;

  /// No description provided for @newPasswordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordPlaceholder;

  /// No description provided for @confirmPasswordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordPlaceholder;

  /// No description provided for @namePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get namePlaceholder;

  /// No description provided for @phonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phonePlaceholder;

  /// No description provided for @addressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressPlaceholder;

  /// No description provided for @cardNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumberPlaceholder;

  /// No description provided for @expirationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Expiration'**
  String get expirationPlaceholder;

  /// No description provided for @cvvPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvvPlaceholder;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNamePlaceholder;

  /// No description provided for @emailAddressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressPlaceholder;

  /// No description provided for @phoneNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberPlaceholder;

  /// No description provided for @couponPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get couponPlaceholder;

  /// No description provided for @searchProductPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search Product'**
  String get searchProductPlaceholder;

  /// No description provided for @describeSpecialDietPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe your special diet requirements (optional)'**
  String get describeSpecialDietPlaceholder;

  /// No description provided for @describeInjuryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe any current or previous injuries (optional)'**
  String get describeInjuryPlaceholder;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get validationError;

  /// No description provided for @noChanges.
  ///
  /// In en, this message translates to:
  /// **'No Changes'**
  String get noChanges;

  /// No description provided for @uploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading Image'**
  String get uploadingImage;

  /// No description provided for @imageUploaded.
  ///
  /// In en, this message translates to:
  /// **'Image Uploaded!'**
  String get imageUploaded;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload Failed'**
  String get uploadFailed;

  /// No description provided for @imageError.
  ///
  /// In en, this message translates to:
  /// **'Image Error'**
  String get imageError;

  /// No description provided for @changePasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Change Password Failed'**
  String get changePasswordFailed;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'OTP Verified!'**
  String get otpVerified;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification Failed'**
  String get verificationFailed;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful!'**
  String get loginSuccessful;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @googleSignInSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In Successful!'**
  String get googleSignInSuccessful;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In Failed'**
  String get googleSignInFailed;

  /// No description provided for @buildingYourPlan.
  ///
  /// In en, this message translates to:
  /// **'We\'re building your personalized plan'**
  String get buildingYourPlan;

  /// No description provided for @journeyStartsSoon.
  ///
  /// In en, this message translates to:
  /// **'Your journey starts in a few seconds.'**
  String get journeyStartsSoon;

  /// No description provided for @imageCapturedProcessing.
  ///
  /// In en, this message translates to:
  /// **'Image captured! Processing for exercise recognition...'**
  String get imageCapturedProcessing;

  /// No description provided for @currentPasswordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPasswordPlaceholder;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// No description provided for @failedToLoadMainGoalOptions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load main goal options'**
  String get failedToLoadMainGoalOptions;

  /// No description provided for @mainGoalUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Main goal updated successfully!'**
  String get mainGoalUpdatedSuccessfully;

  /// No description provided for @failedToUpdateMainGoal.
  ///
  /// In en, this message translates to:
  /// **'Failed to update main goal'**
  String get failedToUpdateMainGoal;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get errorPickingImage;

  /// No description provided for @couponAppliedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied successfully!'**
  String get couponAppliedSuccessfully;

  /// No description provided for @exerciseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise subtitle'**
  String get exerciseSubtitle;

  /// No description provided for @exerciseType.
  ///
  /// In en, this message translates to:
  /// **'Exercise type'**
  String get exerciseType;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see your notifications here'**
  String get noNotificationsDesc;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'This is a test notification from TrackFit! 🎉'**
  String get testNotificationBody;

  /// No description provided for @addTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Add Test Notification'**
  String get addTestNotification;

  /// No description provided for @showAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Show all Notifications'**
  String get showAllNotifications;

  /// No description provided for @daysShort.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get daysShort;

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hoursShort;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minutesShort;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get now;

  /// No description provided for @chooseImageSource.
  ///
  /// In en, this message translates to:
  /// **'Choose Image Source'**
  String get chooseImageSource;

  /// No description provided for @tapToChangeProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Tap to change profile picture'**
  String get tapToChangeProfilePicture;

  /// No description provided for @pleaseWaitWhileWeUploadYourImage.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we upload your image...'**
  String get pleaseWaitWhileWeUploadYourImage;

  /// No description provided for @yourProfileImageHasBeenUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your profile image has been updated successfully'**
  String get yourProfileImageHasBeenUpdatedSuccessfully;

  /// No description provided for @failedToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image. Please try again.'**
  String get failedToUploadImage;

  /// No description provided for @selectedImageFileIsNotAccessible.
  ///
  /// In en, this message translates to:
  /// **'Selected image file is not accessible'**
  String get selectedImageFileIsNotAccessible;

  /// No description provided for @noChangesDetectedToSave.
  ///
  /// In en, this message translates to:
  /// **'No changes detected to save'**
  String get noChangesDetectedToSave;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update Failed'**
  String get updateFailed;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @failedToLoadFavourites.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Favourites'**
  String get failedToLoadFavourites;

  /// No description provided for @noFavouriteExercises.
  ///
  /// In en, this message translates to:
  /// **'No Favourite Exercises'**
  String get noFavouriteExercises;

  /// No description provided for @youHaventAddedAnyExercisesToYourFavouritesYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any exercises to your favourites yet.'**
  String get youHaventAddedAnyExercisesToYourFavouritesYet;

  /// No description provided for @failedToLoadSubscription.
  ///
  /// In en, this message translates to:
  /// **'Failed to load subscription'**
  String get failedToLoadSubscription;

  /// No description provided for @noActiveSubscription.
  ///
  /// In en, this message translates to:
  /// **'No Active Subscription'**
  String get noActiveSubscription;

  /// No description provided for @youDontHaveAnActiveSubscriptionYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have an active subscription yet.\nChoose a plan to get started!'**
  String get youDontHaveAnActiveSubscriptionYet;

  /// No description provided for @browsePackages.
  ///
  /// In en, this message translates to:
  /// **'Browse Packages'**
  String get browsePackages;

  /// No description provided for @planActive.
  ///
  /// In en, this message translates to:
  /// **'Plan Active'**
  String get planActive;

  /// No description provided for @planInactive.
  ///
  /// In en, this message translates to:
  /// **'Plan Inactive'**
  String get planInactive;

  /// No description provided for @yourPlanIsAvailableTill.
  ///
  /// In en, this message translates to:
  /// **'Your Plan is available till'**
  String get yourPlanIsAvailableTill;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @pleaseFinishThePreviousChallengeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please Finish The previous challenge first.'**
  String get pleaseFinishThePreviousChallengeFirst;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get failedToLoadProducts;

  /// No description provided for @noProductsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProductsAvailable;

  /// No description provided for @thereAreNoExercisesScheduledForThisDayAndGoal.
  ///
  /// In en, this message translates to:
  /// **'There are no exercises scheduled for this day and goal.'**
  String get thereAreNoExercisesScheduledForThisDayAndGoal;

  /// No description provided for @noExercisesForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No exercises for this day'**
  String get noExercisesForThisDay;

  /// No description provided for @choosePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose Payment Method'**
  String get choosePaymentMethod;

  /// No description provided for @paymentProof.
  ///
  /// In en, this message translates to:
  /// **'Payment Proof'**
  String get paymentProof;

  /// No description provided for @pleaseUploadScreenshotOfPayment.
  ///
  /// In en, this message translates to:
  /// **'Please upload a screenshot of your Instapay payment'**
  String get pleaseUploadScreenshotOfPayment;

  /// No description provided for @tapToUploadPaymentProof.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload payment proof'**
  String get tapToUploadPaymentProof;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @noProductsInCart.
  ///
  /// In en, this message translates to:
  /// **'No products in cart'**
  String get noProductsInCart;

  /// No description provided for @addSomeProductsToContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Add some products to continue shopping'**
  String get addSomeProductsToContinueShopping;

  /// No description provided for @goToStore.
  ///
  /// In en, this message translates to:
  /// **'Go to Store'**
  String get goToStore;

  /// No description provided for @startShoppingToAddItems.
  ///
  /// In en, this message translates to:
  /// **'Start shopping to add items to your cart'**
  String get startShoppingToAddItems;

  /// No description provided for @startShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get startShopping;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get congratulations;

  /// No description provided for @yourOrderHasBeenConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your Order has been confirmed'**
  String get yourOrderHasBeenConfirmed;

  /// No description provided for @goToHomePage.
  ///
  /// In en, this message translates to:
  /// **'Go to Home Page'**
  String get goToHomePage;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhone;

  /// No description provided for @pleaseSelectCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Please select a country code'**
  String get pleaseSelectCountryCode;

  /// No description provided for @pleaseEnterYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address'**
  String get pleaseEnterYourAddress;

  /// No description provided for @pleaseSelectGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Please select a governorate'**
  String get pleaseSelectGovernorate;

  /// No description provided for @pleaseSelectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get pleaseSelectPaymentMethod;

  /// No description provided for @pleaseUploadPaymentProof.
  ///
  /// In en, this message translates to:
  /// **'Please upload payment proof for Instapay'**
  String get pleaseUploadPaymentProof;

  /// No description provided for @noItemsInCart.
  ///
  /// In en, this message translates to:
  /// **'No items in cart to checkout'**
  String get noItemsInCart;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @vodafoneCash.
  ///
  /// In en, this message translates to:
  /// **'Vodafone Cash'**
  String get vodafoneCash;

  /// No description provided for @instapay.
  ///
  /// In en, this message translates to:
  /// **'Instapay'**
  String get instapay;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address'**
  String get pleaseEnterAddress;

  /// No description provided for @pleaseUploadPaymentProofForInstapay.
  ///
  /// In en, this message translates to:
  /// **'Please upload payment proof for Instapay'**
  String get pleaseUploadPaymentProofForInstapay;

  /// No description provided for @noItemsInCartToCheckout.
  ///
  /// In en, this message translates to:
  /// **'No items in cart to checkout'**
  String get noItemsInCartToCheckout;

  /// No description provided for @startShoppingToAddItemsToYourCart.
  ///
  /// In en, this message translates to:
  /// **'Start shopping to add items to your cart'**
  String get startShoppingToAddItemsToYourCart;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// No description provided for @errorLoadingCategories.
  ///
  /// In en, this message translates to:
  /// **'Error loading categories'**
  String get errorLoadingCategories;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @unableToLoadWorkoutTypes.
  ///
  /// In en, this message translates to:
  /// **'Unable to load workout types'**
  String get unableToLoadWorkoutTypes;

  /// No description provided for @pleaseCheckYourConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get pleaseCheckYourConnection;

  /// No description provided for @searchForExercises.
  ///
  /// In en, this message translates to:
  /// **'Search for exercises'**
  String get searchForExercises;

  /// No description provided for @allExercises.
  ///
  /// In en, this message translates to:
  /// **'All exercises'**
  String get allExercises;

  /// No description provided for @tryModifyingSearchOrFilters.
  ///
  /// In en, this message translates to:
  /// **'Try modifying the search or filters'**
  String get tryModifyingSearchOrFilters;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @selectEquipment.
  ///
  /// In en, this message translates to:
  /// **'Select Equipment'**
  String get selectEquipment;

  /// No description provided for @exerciseDetail.
  ///
  /// In en, this message translates to:
  /// **'Exercise Detail'**
  String get exerciseDetail;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available for this exercise.'**
  String get noDescriptionAvailable;

  /// No description provided for @startYourExercise.
  ///
  /// In en, this message translates to:
  /// **'Start Your Exercise'**
  String get startYourExercise;

  /// No description provided for @failedToCaptureImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture image'**
  String get failedToCaptureImage;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan exercises. Please enable camera access in your device settings.'**
  String get cameraPermissionRequired;

  /// No description provided for @youveUpgradedToPremium.
  ///
  /// In en, this message translates to:
  /// **'You\'ve Upgraded to Premium!'**
  String get youveUpgradedToPremium;

  /// No description provided for @exploreMyPlan.
  ///
  /// In en, this message translates to:
  /// **'Explore My Plan'**
  String get exploreMyPlan;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go To Home'**
  String get goToHome;

  /// No description provided for @forgetPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a reset link to your email.'**
  String get forgetPasswordInstructions;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code?'**
  String get resendCode;

  /// No description provided for @pleaseEnterValidEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email first'**
  String get pleaseEnterValidEmailFirst;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @codeHasBeenSentTo.
  ///
  /// In en, this message translates to:
  /// **'Code has been sent to {email}'**
  String codeHasBeenSentTo(String email);

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in {seconds}s'**
  String resendOtpIn(int seconds);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @pleaseEnterOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP code'**
  String get pleaseEnterOtpCode;

  /// No description provided for @pleaseEnterCompleteOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit OTP'**
  String get pleaseEnterCompleteOtp;

  /// No description provided for @otpMustContainOnlyNumbers.
  ///
  /// In en, this message translates to:
  /// **'OTP must contain only numbers'**
  String get otpMustContainOnlyNumbers;

  /// No description provided for @createYourNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create your new password'**
  String get createYourNewPassword;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @yourAccountIsReadyToUse.
  ///
  /// In en, this message translates to:
  /// **'Your Account is ready to use'**
  String get yourAccountIsReadyToUse;

  /// No description provided for @goToLoginPage.
  ///
  /// In en, this message translates to:
  /// **'Go to Login Page'**
  String get goToLoginPage;

  /// No description provided for @otpSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully! Check your email for the verification code'**
  String get otpSentSuccessfully;

  /// No description provided for @otpVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully! You can now create a new password'**
  String get otpVerifiedSuccessfully;

  /// No description provided for @passwordResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully! Your account is ready to use'**
  String get passwordResetSuccessfully;

  /// No description provided for @achieveYourFitnessGoal.
  ///
  /// In en, this message translates to:
  /// **'Achieve Your Fitness Goal'**
  String get achieveYourFitnessGoal;

  /// No description provided for @getPersonalizedWorkoutPlan.
  ///
  /// In en, this message translates to:
  /// **'Get a personalized workout plan that matches your goal — whether it\'s weight loss, muscle gain, or staying fit.'**
  String get getPersonalizedWorkoutPlan;

  /// No description provided for @levelUpYourHealthWithSmartMeals.
  ///
  /// In en, this message translates to:
  /// **'Level Up Your Health with Smart Meals'**
  String get levelUpYourHealthWithSmartMeals;

  /// No description provided for @followDailyMealPlans.
  ///
  /// In en, this message translates to:
  /// **'Follow daily meal plans tailored to how fast you want to lose healthy calories and lifestyle that improve overall.'**
  String get followDailyMealPlans;

  /// No description provided for @scanYourPlateKnowYourCalories.
  ///
  /// In en, this message translates to:
  /// **'Scan Your Plate. Know Your Calories Instantly'**
  String get scanYourPlateKnowYourCalories;

  /// No description provided for @takePhotoOfYourFood.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your food and our AI will instantly identify calories, nutrients, and track it automatically.'**
  String get takePhotoOfYourFood;

  /// No description provided for @smartFitnessPoweredByAi.
  ///
  /// In en, this message translates to:
  /// **'Smart Fitness Powered by AI'**
  String get smartFitnessPoweredByAi;

  /// No description provided for @getPersonalizedTrainingPlans.
  ///
  /// In en, this message translates to:
  /// **'Get personalized training plans, intelligent suggestions and detailed tracking — all powered by AI.'**
  String get getPersonalizedTrainingPlans;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
