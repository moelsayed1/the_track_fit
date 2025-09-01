import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/constants.dart';
import 'core/router/app_router.dart';
import 'features/workout/data/cubit/exercise_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        return BlocProvider(
          create: (context) => ExerciseCubit(),
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


