import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/features/workout/data/cubit/exercise_cubit.dart';

class FavouriteExerciseProfile extends StatelessWidget {
  const FavouriteExerciseProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseCubit()..initializeFavourites(_getMockExercises()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6FFF6),
        body: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: const BoxDecoration(color: Color(0x26848484)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: SvgPicture.asset(
                        'assets/logos/arrow_left.svg',
                        width: 24.w,
                        height: 24.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1E1E1E),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Favourite Exercise',
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: 18.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.89,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content - Using BlocBuilder for dynamic updates
              Expanded(
                child: BlocBuilder<ExerciseCubit, ExerciseState>(
                  builder: (context, state) {
                    if (state.favouriteExercises.isEmpty) {
                      return _buildEmptyState();
                    }

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: SizedBox(
                        width: 343.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Exercise items with dividers
                            for (int i = 0; i < state.favouriteExercises.length; i++) ...[
                              _buildExerciseItem(context, state.favouriteExercises[i]),
                              if (i < state.favouriteExercises.length - 1) _buildDivider(),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100.h),
          Icon(
            Icons.favorite_border,
            size: 64.sp,
            color: const Color(0xFF848484),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Favourite Exercises',
            style: TextStyle(
              color: const Color(0xFF848484),
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You haven\'t added any exercises to your favourites yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF848484),
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(BuildContext context, Exercise exercise) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.w,
                      color: const Color(0x26848484),
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: ShapeDecoration(
                        image: exercise.imagePath.isNotEmpty
                            ? DecorationImage(
                                image: AssetImage(exercise.imagePath),
                                fit: BoxFit.cover,
                              )
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: exercise.imagePath.isEmpty
                          ? Icon(
                              Icons.fitness_center,
                              size: 24.sp,
                              color: const Color(0xFF28A228),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              SizedBox(
                width: 115.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 115.w,
                      child: Text(
                        exercise.title,
                        style: TextStyle(
                          color: const Color(0xFF1E1E1E),
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 115.w,
                      child: Text(
                        exercise.subtitle,
                        style: TextStyle(
                          color: const Color(0xFF848484),
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.read<ExerciseCubit>().removeFromFavourites(exercise.id),
            child: SizedBox(
              width: 24.w,
              height: 24.h,
              child: Icon(
                Icons.favorite,
                size: 24.sp,
                color: const Color(0xFF28A228),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          height: 1.h,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.w,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: const Color(0x26848484),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  // Mock data for demonstration
  List<Exercise> _getMockExercises() {
    return [
      const Exercise(
        id: '1',
        title: 'Push-ups',
        subtitle: 'Bodyweight exercise for chest and arms',
        imagePath: 'assets/images/exercise_image.jpg',
        type: 'Strength',
        isFavorite: true,
      ),
      const Exercise(
        id: '2',
        title: 'Squats',
        subtitle: 'Lower body strength exercise',
        imagePath: 'assets/images/exercise_image.jpg',
        type: 'Strength',
        isFavorite: true,
      ),
      const Exercise(
        id: '3',
        title: 'Plank',
        subtitle: 'Core stability exercise',
        imagePath: 'assets/images/exercise_image.jpg',
        type: 'Core',
        isFavorite: true,
      ),
      const Exercise(
        id: '4',
        title: 'Burpees',
        subtitle: 'Full body cardio exercise',
        imagePath: 'assets/images/exercise_image.jpg',
        type: 'Cardio',
        isFavorite: true,
      ),
    ];
  }
}
