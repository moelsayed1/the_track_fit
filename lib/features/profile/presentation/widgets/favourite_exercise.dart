import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/features/workout/data/cubit/exercise_cubit.dart';
import 'package:the_track_fit/features/workout/data/repositories/exercise_repository.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/widgets/shimmer_loading.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';

class FavouriteExerciseProfile extends StatelessWidget {
  const FavouriteExerciseProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseCubit(
        exerciseRepository: ExerciseRepository(apiService: ApiService()),
      )..loadFavoriteExercisesFromAPI(),
      child: _FavoriteExerciseContent(),
    );
  }
}

class _FavoriteExerciseContent extends StatefulWidget {
  @override
  _FavoriteExerciseContentState createState() =>
      _FavoriteExerciseContentState();
}

class _FavoriteExerciseContentState extends State<_FavoriteExerciseContent> {
  @override
  void initState() {
    super.initState();
    // Refresh favorite exercises when screen is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseCubit>().loadFavoriteExercisesFromAPI();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Builder(
              builder: (context) {
                final isArabic =
                    Localizations.localeOf(context).languageCode == 'ar';
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: const BoxDecoration(color: Color(0x26848484)),
                  child: Row(
                    mainAxisAlignment: isArabic
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isArabic) ...[
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
                          l10n?.favouriteExercise ?? 'Favourite Exercise',
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: 18.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0.89,
                          ),
                        ),
                      ],
                      if (isArabic) ...[
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(3.1415926535897932),
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
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          l10n?.favouriteExercise ?? 'Favourite Exercise',
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: 18.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w500,
                            height: 0.89,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            // Main Content - Using BlocBuilder for dynamic updates
            Expanded(
              child: BlocBuilder<ExerciseCubit, ExerciseState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return _buildLoadingState();
                  }

                  if (state.error != null) {
                    return _buildErrorState(context, state.error!);
                  }

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
                          for (
                            int i = 0;
                            i < state.favouriteExercises.length;
                            i++
                          ) ...[
                            _buildExerciseItem(
                              context,
                              state.favouriteExercises[i],
                            ),
                            if (i < state.favouriteExercises.length - 1)
                              _buildDivider(),
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
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: SizedBox(
        width: 343.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Shimmer exercise items with dividers
            for (int i = 0; i < 4; i++) ...[
              _buildShimmerExerciseItem(),
              if (i < 3) _buildDivider(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h),
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: const Color(0xFF848484),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n?.failedToLoadFavourites ?? 'Failed to Load Favourites',
              style: TextStyle(
                color: const Color(0xFF848484),
                fontSize: 18.sp,
                fontFamily: isArabic ? 'Cairo' : 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF848484),
                fontSize: 14.sp,
                fontFamily: isArabic ? 'Cairo' : 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                // Refresh the data
                context.read<ExerciseCubit>().loadFavoriteExercisesFromAPI();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A228),
                foregroundColor: Colors.white,
              ),
              child: Text(
                l10n?.retry ?? 'Retry',
                style: TextStyle(fontFamily: isArabic ? 'Cairo' : 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 32.h),
            Icon(
              Icons.favorite_border,
              size: 64.sp,
              color: const Color(0xFF848484),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n?.noFavouriteExercises ?? 'No Favourite Exercises',
              style: TextStyle(
                color: const Color(0xFF848484),
                fontSize: 18.sp,
                fontFamily: isArabic ? 'Cairo' : 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n?.youHaventAddedAnyExercisesToYourFavouritesYet ??
                  'You haven\'t added any exercises to your favourites yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF848484),
                fontSize: 14.sp,
                fontFamily: isArabic ? 'Cairo' : 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(BuildContext context, Exercise exercise) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SizedBox(
      width: double.infinity,
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: exercise.imagePath.isNotEmpty
                              ? (exercise.imagePath.startsWith('http')
                                    ? Image.network(
                                        exercise.imagePath,
                                        width: 48.w,
                                        height: 48.h,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Icon(
                                                Icons.fitness_center,
                                                size: 24.sp,
                                                color: const Color(0xFF28A228),
                                              );
                                            },
                                      )
                                    : Image.asset(
                                        exercise.imagePath,
                                        width: 48.w,
                                        height: 48.h,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Icon(
                                                Icons.fitness_center,
                                                size: 24.sp,
                                                color: const Color(0xFF28A228),
                                              );
                                            },
                                      ))
                              : Icon(
                                  Icons.fitness_center,
                                  size: 24.sp,
                                  color: const Color(0xFF28A228),
                                ),
                        ),
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
                            fontFamily: isArabic ? 'Cairo' : 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 115.w,
                        child: Text(
                          exercise.setsAndRepsDisplay,
                          style: TextStyle(
                            color: const Color(0xFF848484),
                            fontSize: 14.sp,
                            fontFamily: isArabic ? 'Cairo' : 'Poppins',
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
              onTap: () =>
                  context.read<ExerciseCubit>().toggleFavourite(exercise),
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
      ),
    );
  }

  Widget _buildShimmerExerciseItem() {
    return ShimmerLoading(
      child: SizedBox(
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
                    color: Colors.white,
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
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
                      Container(
                        width: 115.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: 80.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
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
}
