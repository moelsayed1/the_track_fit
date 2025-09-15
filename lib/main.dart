import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/constants.dart';
import 'core/router/app_router.dart';
import 'core/services/api_service.dart';
import 'features/workout/data/cubit/exercise_cubit.dart';
import 'features/workout/data/repositories/exercise_repository.dart';
import 'features/auth/data/cubit/auth_cubit.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/cart/data/services/cart_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  // Initialize API service
  ApiService().init();
  
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
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ExerciseCubit(exerciseRepository: ExerciseRepository(apiService: ApiService()))),
            BlocProvider(create: (context) => AuthCubit(AuthRepository())),
            BlocProvider(create: (context) => CartCubit(cartService: CartService(apiService: ApiService()))),
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
      },
    );
  }
}


