import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/constants.dart';
import 'core/router/app_router.dart';
import 'core/services/api_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/fcm_service.dart';
import 'core/widgets/shimmer_loading.dart';
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

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize ApiService
  ApiService().init();

  // Initialize FCM Service
  await FCMService.initialize();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

//   SystemChrome.setSystemUIOverlayStyle(
//   const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent, // ✅ شفاف
//     statusBarIconBrightness: Brightness.dark, // حسب خلفيتك
//   ),
// );
  
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
                  BlocProvider(create: (context) => ExerciseCubit(exerciseRepository: ExerciseRepository(apiService: ApiService()))),
                  BlocProvider(create: (context) => AuthCubit(AuthRepository(), snapshot.data!)),
                  BlocProvider(create: (context) => CartCubit(cartService: CartService(apiService: ApiService()))),
                  BlocProvider(create: (context) => CheckoutCubit(checkoutService: CheckoutService(apiService: ApiService()))),
                ],
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: AppConstants.appName,
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.splashDarkGreen),
                  ),
                  routerConfig: AppRouter.router,
                ),
              );
            } else {
              return const MaterialApp(
                home: ShimmerLoadingScreen(
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


