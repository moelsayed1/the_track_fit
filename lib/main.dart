import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_track_fit/firebase_options.dart';
import 'core/services/api_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/language_service.dart';
import 'core/bloc/language/language_bloc.dart';
import 'core/widgets/shimmer_loading.dart';
import 'core/widgets/localized_app.dart';
import 'features/workout/data/cubit/exercise_cubit.dart';
import 'features/workout/data/repositories/exercise_repository.dart';
import 'features/auth/data/cubit/auth_cubit.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/cart/data/services/cart_service.dart';
import 'features/cart/presentation/cubit/checkout_cubit.dart';
import 'features/cart/data/services/checkout_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  } else {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.ios);
  }

  // Initialize ApiService
  ApiService().init();

  // Initialize FCM Service
  await FCMService.initialize();

  // Initialize Language Service
  await LanguageService.instance.initialize();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialize API service
  ApiService().init();

  // Initialize StorageService
  await StorageService.getInstance();

  runApp(const TrackFit());
}

class TrackFit extends StatelessWidget {
  const TrackFit({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return FutureBuilder<StorageService>(
          future: StorageService.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ExerciseCubit(
                      exerciseRepository: ExerciseRepository(
                        apiService: ApiService(),
                      ),
                    ),
                  ),
                  BlocProvider(
                    create: (context) =>
                        AuthCubit(AuthRepository(), snapshot.data!),
                  ),
                  BlocProvider(
                    create: (context) => CartCubit(
                      cartService: CartService(apiService: ApiService()),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => CheckoutCubit(
                      checkoutService: CheckoutService(
                        apiService: ApiService(),
                      ),
                    ),
                  ),
                  BlocProvider(
                    create: (context) =>
                        LanguageBloc(languageService: LanguageService.instance)
                          ..add(const LanguageInitialized()),
                  ),
                ],
                child: const LocalizedApp(
                  themeMode: ThemeMode.dark, // 👈 Force dark theme
                ),
              );
            } else {
              return MaterialApp(
                themeMode: ThemeMode.dark,
                darkTheme: ThemeData.dark().copyWith(
                  scaffoldBackgroundColor: const Color(0xFF121212),
                  colorScheme: ColorScheme.dark(
                    primary: const Color(0xFFFF4A2A),
                    secondary: const Color(0xFFF27660),
                    surface: const Color(0xFF1E1E1E),
                    background: const Color(0xFF121212),
                  ),
                ),
                theme: ThemeData.dark().copyWith(
                  scaffoldBackgroundColor: const Color(0xFF121212),
                  colorScheme: ColorScheme.dark(
                    primary: const Color(0xFFFF4A2A),
                    secondary: const Color(0xFFF27660),
                    surface: const Color(0xFF1E1E1E),
                    background: const Color(0xFF121212),
                  ),
                ),
                home: const ShimmerLoadingScreen(
                  message: 'Initializing app...',
                ),
              );
            }
          },
        );
      },
    );
  }
}
