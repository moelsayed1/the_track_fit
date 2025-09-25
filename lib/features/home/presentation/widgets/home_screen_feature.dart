import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/features/auth/data/cubit/auth_cubit.dart';
import 'package:the_track_fit/features/auth/data/cubit/auth_states.dart';
import 'package:the_track_fit/features/plan/presentation/screens/plan_screen.dart';
import 'package:the_track_fit/features/report/presentation/screens/report_screen.dart';
import 'package:the_track_fit/features/scan_meals/presentation/screens/meal_screen.dart';
import 'package:the_track_fit/features/workout/presentation/screens/workout_screen.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/features/workout/data/repositories/exercise_repository.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/widgets/app_scaffold.dart';
import 'package:the_track_fit/features/store/domain/models/product.dart';
import 'package:the_track_fit/features/store/domain/repositories/product_repository.dart';
import 'package:the_track_fit/features/store/data/repositories/product_repository_impl.dart';
import 'package:the_track_fit/features/store/data/datasources/product_remote_datasource.dart';
import 'package:the_track_fit/core/widgets/shimmer_loading.dart';
import 'package:the_track_fit/core/services/storage_service.dart';

class HomeScreenFeature extends StatefulWidget {
  const HomeScreenFeature({super.key});

  @override
  State<HomeScreenFeature> createState() => _HomeScreenFeatureState();
}

class _HomeScreenFeatureState extends State<HomeScreenFeature> {
  int _currentIndex = 0; // 0: Home, 1: Workout, 2: Scan, 3: Report, 4: Plan
  int _selectedDateIndex = 0; // Will be set to today's day in initState
  int _selectedExerciseIndex = 0; // Track which exercise is selected
  bool _showWarningDialog = false; // Control warning dialog visibility
  List<bool> _completedExercises = []; // Track completed exercises

  // API integration
  late final ExerciseRepository _exerciseRepository;
  late final ProductRepository _productRepository;
  StorageService? _storageService;
  List<Exercise> _dayExercises = [];
  List<Product> _newProducts = [];
  bool _isLoadingExercises = false;
  bool _isLoadingProducts = false;
  bool _isInitializing = true; // Add initialization state
  String? _exerciseError;
  String? _productError;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _exerciseRepository = ExerciseRepository(apiService: ApiService());
    _productRepository = ProductRepositoryImpl(
      remoteDataSource: ProductRemoteDataSourceImpl(apiService: ApiService()),
    );
    // Initialize the API service
    ApiService().init();
    
    // Set selected date to today's day
    _setTodayAsSelected();
    
    // Initialize storage and then load data
    _initializeAndLoadData();
  }

  Future<void> _initializeAndLoadData() async {
    await _initializeStorage();
    if (!_isDisposed) {
      setState(() {
        _isInitializing = false;
      });
    }
    _loadExercisesForDay();
    _loadNewProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only refresh exercises if we're not still initializing
    if (!_isInitializing) {
      _loadExercisesForDay();
    }
  }

  Future<void> _initializeStorage() async {
    _storageService ??= await StorageService.getInstance();
  }

  // Set today as the selected day
  void _setTodayAsSelected() {
    final now = DateTime.now();
    final today = now.weekday; // 1=Monday, 2=Tuesday, ..., 7=Sunday

    // Map weekday to our day index (0: Sat, 1: Sun, 2: Mon, 3: Tue, 4: Wed, 5: Thu, 6: Fri)
    // Our array: [Sat, Sun, Mon, Tue, Wed, Thu, Fri]
    // DateTime:  [6,   7,   1,   2,   3,   4,   5]
    // Day IDs:   [1,   2,   3,   4,   5,   6,   7]
    switch (today) {
      case DateTime.saturday: // 6
        _selectedDateIndex = 0;
        break;
      case DateTime.sunday: // 7
        _selectedDateIndex = 1;
        break;
      case DateTime.monday: // 1
        _selectedDateIndex = 2;
        break;
      case DateTime.tuesday: // 2
        _selectedDateIndex = 3;
        break;
      case DateTime.wednesday: // 3
        _selectedDateIndex = 4;
        break;
      case DateTime.thursday: // 4
        _selectedDateIndex = 5;
        break;
      case DateTime.friday: // 5
        _selectedDateIndex = 6;
        break;
      default:
        _selectedDateIndex = 0; // Default to Saturday if something goes wrong
    }
  }

  // Map day index to day_id (1-7 for Fri-Thu)
  int _getDayId(int dayIndex) {
    return dayIndex + 1; // 0->1, 1->2, 2->3, 3->4, 4->5, 5->6, 6->7
  }

  // Helper method to sort products by update date (oldest first)
  List<Product> _sortProductsByDate(List<Product> products) {
    final sortedProducts = List<Product>.from(products);
    sortedProducts.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.updatedAt);
        final dateB = DateTime.parse(b.updatedAt);
        final comparison = dateA.compareTo(dateB); // Oldest first
        log('HomeScreen Sorting: ${a.name} (${a.updatedAt}) vs ${b.name} (${b.updatedAt}) -> $comparison');
        return comparison;
      } catch (e) {
        log('HomeScreen Error parsing dates: $e');
        return 0; // Keep original order if parsing fails
      }
    });
    
    // Log the final sorted order
    log('HomeScreen Final sorted order:');
    for (int i = 0; i < sortedProducts.length; i++) {
      log('$i: ${sortedProducts[i].name} (${sortedProducts[i].updatedAt})');
    }
    
    return sortedProducts;
  }

  // Load new products
  Future<void> _loadNewProducts() async {
    if (_isDisposed) return;

    setState(() {
      _isLoadingProducts = true;
      _productError = null;
    });

    try {
      final response = await _productRepository.getNewProducts(perPage: 8);
      if (!_isDisposed) {
        setState(() {
          // Sort products by update date (oldest first) for consistency
          _newProducts = _sortProductsByDate(response.products);
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      if (!_isDisposed) {
        setState(() {
          _productError = e.toString();
          _isLoadingProducts = false;
        });
      }
      log('Error loading new products: $e');
    }
  }

  // Load exercises for the selected day
  Future<void> _loadExercisesForDay() async {
    if (_isDisposed) return;

    log('Loading exercises for day index: $_selectedDateIndex');
    setState(() {
      _isLoadingExercises = true;
      _exerciseError = null;
    });

    try {
      final dayId = _getDayId(_selectedDateIndex);
      log('Day ID: $dayId');

      // Ensure storage is initialized
      if (_storageService == null) {
        log('Storage not initialized, initializing now...');
        await _initializeStorage();
      }
      
      // Get the user's selected main goal from storage
      final mainGoal = _storageService?.getMainGoal();
      log('User main goal: $mainGoal');
      log('Loading exercises for day $dayId with goal: $mainGoal');

      // Load exercises with the goal parameter
      final exercises = await _exerciseRepository.getExercisesByDay(
        dayId,
        goal: mainGoal,
      );

      log('Received ${exercises.length} exercises');
      for (var exercise in exercises) {
        log('Exercise: ${exercise.title}, Image: ${exercise.imagePath}');
      }

      if (!_isDisposed) {
        setState(() {
          _dayExercises = exercises;
          _isLoadingExercises = false;
          // Reset completed exercises list based on new data
          _completedExercises = List.filled(exercises.length, false);
        });
      }
    } catch (e) {
      log('Error loading exercises: $e');
      if (!_isDisposed) {
        setState(() {
          _exerciseError = e.toString();
          _isLoadingExercises = false;
        });
      }
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Color _getTabColor(int index) {
    return _currentIndex == index
        ? const Color(0xFF28A228) // Active: Green
        : const Color(0xFF848484); // Inactive: Gray
  }

  String _getScreenTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Workout';
      case 2:
        return 'Scan';
      case 3:
        return 'Report';
      case 4:
        return 'Packages';
      default:
        return 'Home';
    }
  }

  void _onDateSelected(int index) {
    setState(() {
      _selectedDateIndex = index;
    });
    _loadExercisesForDay(); // Load exercises for the selected day
  }

  void _onExerciseSelected(int index) {
    setState(() {
      _selectedExerciseIndex = index;
    });
    // Pass the exercise data to the Exercise Detail screen
    final exercise = _dayExercises[index];
    context.push(AppRouter.exerciseDetail, extra: exercise);
  }

  Future<void> _onFavoriteToggled(int productId) async {
    if (_isDisposed) return;

    try {
      await _productRepository.toggleProductFavorite(productId);
      if (!_isDisposed) {
        setState(() {
          // The repository already updates the local state, so we just need to refresh
          // Find the product and update its favorite status based on the repository state
          final productIndex = _newProducts.indexWhere((p) => p.id == productId);
          if (productIndex != -1) {
            // Get the updated product from the repository's cached products
            final updatedProduct = _productRepository.getCachedProducts()
                .firstWhere((p) => p.id == productId, orElse: () => _newProducts[productIndex]);
            _newProducts[productIndex] = updatedProduct;
            
            // Re-sort the products to maintain consistent order
            _newProducts = _sortProductsByDate(_newProducts);
          }
        });
      }
    } catch (e) {
      log('Error toggling favorite: $e');
      // Show error message to user
      if (!_isDisposed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update favorite: $e')),
        );
      }
    }
  }

  void _onLockTapped() {
    setState(() {
      _showWarningDialog = true;
    });

    // Auto-hide the dialog after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showWarningDialog = false;
        });
      }
    });
  }

  // Helper methods for product loading states
  Widget _buildProductShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 120.w,
              height: 160.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 32.w, color: Colors.red),
          SizedBox(height: 8.h),
          Text(
            'Failed to load products',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12.sp,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4.h),
          TextButton(
            onPressed: _loadNewProducts,
            child: Text(
              'Retry',
              style: TextStyle(
                color: const Color(0xFF28A228),
                fontSize: 12.sp,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoProducts() {
    return Center(
      child: Text(
        'No products available',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12.sp,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  void _onExerciseCompleted(int index) {
    setState(() {
      _completedExercises[index] = !_completedExercises[index];
    });
  }

  int get _completedWorkoutsCount {
    return _completedExercises.where((completed) => completed).length;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     
    return AppScaffoldWithCustomSafeArea(
      resizeToAvoidBottomInset: true,
      bottom: true,
      body: Column(
        children: [
          // Warning Dialog
          if (_showWarningDialog)
            Container(
              width: 375.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x19000000),
                    blurRadius: 4,
                    offset: const Offset(4, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Warning icon
                  Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Reduced spacing from 8.w to 4.w
                  // Warning text
                  SizedBox(width: 8.w),
                  Text(
                    'Please Finish The previous challenge first.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 12.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          // Main content
          Expanded(child: _buildContentForTab(_currentIndex)),
          // Hide bottom navigation bar when showing Plan tab
          if (_currentIndex != 4) ...[
            _BottomNavBar(
              currentIndex: _currentIndex,
              onTabTapped: _onTabTapped,
              getTabColor: _getTabColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContentForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: // Home
        return _buildHomeUI();
      case 1: // Workout
        return WorkoutScreen();
      case 2: // Scan
        return MealScreen();
      case 3: // Report
        return ReportScreen();
      case 4: // Plan
        return PlanSubscriptionScreen();
      default:
        return HomeScreenFeature();
    }
  }

  Widget _buildDateItem(String day, int index) {
    bool isSelected = _selectedDateIndex == index;
    return GestureDetector(
      onTap: () => _onDateSelected(index),
      child: Container(
        width: 35.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color: isSelected ? const Color(0xFF28A228) : Colors.white,
                fontSize: 11.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            // Text(
            //   date,
            //   style: TextStyle(
            //     color: isSelected ? const Color(0xFF28A228) : Colors.white,
            //     fontSize: 11.sp,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeUI() {
    // Show loading indicator while initializing
    if (_isInitializing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: const Color(0xFF28A228),
            ),
            SizedBox(height: 16.h),
            Text(
              'Loading...',
              style: TextStyle(
                color: const Color(0xFF1E1E1E),
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header with points, title, and profile
        _Header(title: _getScreenTitle(_currentIndex)),
        // Greeting section
        Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 16.h, left: 16.w),
          child: Row(
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  // Show shimmer loading while user data is being fetched
                  if (state is AuthLoading || state is AuthInitial) {
                    return ShimmerLoading(
                      child: Container(
                        width: 120.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    );
                  }

                  // Show actual user name when loaded
                  String userName = 'User'; // Default fallback

                  if (state is AuthUserProfileLoaded) {
                    userName = state.name;
                  } else if (state is AuthUserAlreadyLoggedIn) {
                    userName = state.name;
                  } else if (state is AuthRegisterSuccessWithProfile) {
                    userName = state.name;
                  } else if (state is AuthLoginSuccessWithProfile) {
                    userName = state.name;
                  }

                  return Text(
                    'Hi $userName! 👋',
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Daily Goal Banner
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.00, 0.50),
                end: Alignment(1.00, 0.50),
                colors: [Color(0xFF28A228), Color(0xD85CD65C)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily goal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 7.h,
                        decoration: ShapeDecoration(
                          color:
                              (_completedExercises.isNotEmpty &&
                                  _completedExercises[0])
                              ? const Color(0xFFFFCC4D)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Container(
                        height: 7.h,
                        decoration: ShapeDecoration(
                          color:
                              (_completedExercises.length > 1 &&
                                  _completedExercises[1])
                              ? const Color(0xFFFFB366)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Container(
                        height: 7.h,
                        decoration: ShapeDecoration(
                          color:
                              (_completedExercises.length > 2 &&
                                  _completedExercises[2])
                              ? const Color(0xFFFFB366)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  '$_completedWorkoutsCount/3 workouts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 24.h),

        // New Products Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Products',
                style: TextStyle(
                  color: const Color(0xFF1E1E1E),
                  fontSize: 18.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(AppRouter.store);
                },
                child: Text(
                  'Show all Products',
                  style: TextStyle(
                    color: const Color(0xFF28A228),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Products Horizontal ListView
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: SizedBox(
            height: 140.h,
            child: _isLoadingProducts
                ? _buildProductShimmer()
                : _productError != null
                ? _buildProductError()
                : _newProducts.isEmpty
                ? _buildNoProducts()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _newProducts.length,
                    itemBuilder: (context, index) {
                      final product = _newProducts[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ProductCard(
                          onTap: () => context.push(
                            AppRouter.productDetail,
                            extra: {'product': product},
                          ),
                          productName: product.name,
                          price: '${product.price}\$',
                          exerciseIcon: product.imageUrl,
                          isFavorite: product.isFavorite,
                          onFavoriteTapped: () =>
                              _onFavoriteToggled(product.id),
                        ),
                      );
                    },
                  ),
          ),
        ),

        SizedBox(height: 24.h),

        // Your Activity Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Your Activity',
            style: TextStyle(
              color: const Color(0xFF1E1E1E),
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Date Selector
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(color: const Color(0xFF28A228)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDateItem('Sat', 0),
              _buildDateItem('Sun', 1),
              _buildDateItem('Mon', 2),
              _buildDateItem('Tue', 3),
              _buildDateItem('Wed', 4),
              _buildDateItem('Thu', 5),
              _buildDateItem('Fri', 6),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Exercise Cards
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _buildExerciseList(),
        ),
      ],
    );
  }

  Widget _buildExerciseList() {
    log(
      'Building exercise list - Loading: $_isLoadingExercises, Error: $_exerciseError, Count: ${_dayExercises.length}',
    );

    if (_isLoadingExercises) {
      return _buildShimmerLoader();
    }

    if (_exerciseError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              color: Colors.grey[400],
              size: 64.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'No exercises available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'There are no exercises scheduled for this day and goal.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _loadExercisesForDay,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A228),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_dayExercises.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.fitness_center, color: Colors.grey, size: 48.sp),
            SizedBox(height: 8.h),
            Text(
              'No exercises for this day',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.sp,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _dayExercises.length,
      itemBuilder: (context, index) {
        final exercise = _dayExercises[index];
        log('Building exercise card $index: ${exercise.title}');
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: GestureDetector(
            onTap: () => _onExerciseSelected(index),
            child: ExerciseCard(
              exerciseTitle: exercise.title,
              setsAndReps: exercise.setsAndRepsDisplay, // Use the formatted sets and reps from API
              isLocked: index > 0, // You can customize this logic
              isSelected: _selectedExerciseIndex == index,
              isCompleted: _completedExercises.length > index
                  ? _completedExercises[index]
                  : false,
              imageUrl: exercise.imagePath, // Use the GIF from API
              onLockTapped: _onLockTapped,
              onCompleted: () => _onExerciseCompleted(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3, // Show 3 shimmer cards
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child: Row(
                children: [
                  // Exercise icon shimmer
                  Container(
                    width: 64.w,
                    height: 64.h,
                    padding: EdgeInsets.all(12.w),
                    decoration: ShapeDecoration(
                      color: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Exercise details shimmer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 120.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right side icon shimmer
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Reusable Product Card Widget

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTabTapped;
  final Color Function(int) getTabColor;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTabTapped,
    required this.getTabColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 85.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x2628A228),
            blurRadius: 4,
            offset: Offset(4, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NavBarItem(
            icon: SvgPicture.asset(
              'assets/logos/home_icon.svg',
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(getTabColor(0), BlendMode.srcIn),
            ),
            label: 'Home',
            selected: currentIndex == 0,
            onTap: () => onTabTapped(0),
            color: getTabColor(0),
          ),
          _NavBarItem(
            icon: SvgPicture.asset(
              'assets/logos/gym_icon.svg',
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(getTabColor(1), BlendMode.srcIn),
            ),
            label: 'Workout',
            selected: currentIndex == 1,
            onTap: () => onTabTapped(1),
            color: getTabColor(1),
          ),
          _NavBarCentralButton(onTap: () => onTabTapped(2)),
          _NavBarItem(
            icon: SvgPicture.asset(
              'assets/logos/progressive_icon.svg',
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(getTabColor(3), BlendMode.srcIn),
            ),
            label: 'Report',
            selected: currentIndex == 3,
            onTap: () => onTabTapped(3),
            color: getTabColor(3),
          ),
          _NavBarItem(
            icon: Image.asset(
              'assets/logos/premium_icon.png',
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
              color: getTabColor(4),
            ),
            label: 'Package',
            selected: currentIndex == 4,
            onTap: () => onTabTapped(4),
            color: getTabColor(4),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.33,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarCentralButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NavBarCentralButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: ShapeDecoration(
                color: const Color(0xFF28A228),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: SizedBox(
                width: 30.w,
                height: 30.h,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/logos/scan_icon.svg',
                    width: 28.w,
                    height: 28.h,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productName;
  final String price;
  final String exerciseIcon;
  final bool isFavorite;
  final VoidCallback? onFavoriteTapped;
  final VoidCallback? onTap;
  final bool alignCenter; // لو true = في النص ، false = على اليمين

  const ProductCard({
    super.key,
    required this.productName,
    required this.price,
    required this.exerciseIcon,
    this.isFavorite = false,
    this.onFavoriteTapped,
    this.onTap,
    this.alignCenter = false, // الافتراضي في النص
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120.w,
        height: 160.h,
        padding: EdgeInsets.all(8.w),
        decoration: ShapeDecoration(
          color: const Color(0xFFD8F1D8),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFF28A228)),
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heart icon positioned at top left
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onFavoriteTapped,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFF28A228),
                    size: 20.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h), // Add spacing between heart and image
            // Product image
            Expanded(
              child: Center(
                child: exerciseIcon.startsWith('http')
                    ? Image.network(
                        exerciseIcon,
                        width: 70.w,
                        height: 70.h,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return ShimmerLoading(
                            child: Container(
                              width: 70.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/product_image.png',
                            width: 70.w,
                            height: 70.h,
                            fit: BoxFit.contain,
                          );
                        },
                      )
                    : Image.asset(
                        exerciseIcon,
                        width: 70.w,
                        height: 70.h,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            // Product details (اسم + سعر)
            Column(
              crossAxisAlignment: alignCenter
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(
                  productName,
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: alignCenter ? TextAlign.start : TextAlign.start,
                ),
                SizedBox(height: 2.h),
                Text(
                  price,
                  style: TextStyle(
                    color: const Color(0xFF28A228),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: alignCenter ? TextAlign.center : TextAlign.start,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Exercise Card Widget
class ExerciseCard extends StatelessWidget {
  final String exerciseTitle;
  final String setsAndReps;
  final bool isLocked;
  final bool isSelected;
  final bool isCompleted;
  final String? imageUrl;
  final VoidCallback? onLockTapped;
  final VoidCallback? onCompleted;

  const ExerciseCard({
    super.key,
    required this.exerciseTitle,
    required this.setsAndReps,
    required this.isLocked,
    required this.isSelected,
    required this.isCompleted,
    this.imageUrl,
    this.onLockTapped,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: isSelected
            ? const Color(0xFFD8F1D8)
            : Colors.white, // Light green when selected
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFF28A228)),
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
      child: Row(
        children: [
          // Exercise icon
          Container(
            width: 64.w,
            height: 64.h,
            padding: EdgeInsets.all(12.w),
            decoration: ShapeDecoration(
              color: const Color(0x26848484),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    width: 64.w,
                    height: 64.h,
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return ShimmerLoading(
                        child: Container(
                          width: 64.w,
                          height: 64.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/exercise_image.png',
                        width: 64.w,
                        height: 64.h,
                        fit: BoxFit.fill,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/exercise_image.png',
                    width: 64.w,
                    height: 64.h,
                    fit: BoxFit.contain,
                  ),
          ),
          SizedBox(width: 16.w),
          // Exercise details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exerciseTitle,
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: 18.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  setsAndReps,
                  style: TextStyle(
                    color: const Color(0xFF848484),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Right side icon - checkmark if selected, lock if locked, or completion button
          if (isSelected)
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: Icon(
                Icons.check_circle,
                color: const Color(0xFF28A228),
                size: 20.w,
              ),
            )
          else if (isLocked)
            GestureDetector(
              onTap: onLockTapped,
              child: SizedBox(
                width: 24.w,
                height: 24.h,
                child: Icon(
                  Icons.lock,
                  color: const Color(0xFF28A228),
                  size: 20.w,
                ),
              ),
            )
          else if (!isCompleted)
            GestureDetector(
              onTap: onCompleted,
              child: SizedBox(
                width: 24.w,
                height: 24.h,
                child: Icon(
                  Icons.check_circle,
                  color: const Color(0xFF28A228),
                  size: 20.w,
                ),
              ),
            )
          else
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: Icon(
                Icons.check_circle,
                color: const Color(0xFF28A228),
                size: 24.w,
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
      child: SizedBox(
        width: 343.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PointsContainer(),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF1E1E1E),
                fontSize: 24.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(AppRouter.profile);
              },
              child: _ProfileContainer(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
      decoration: ShapeDecoration(
        color: const Color(0x3328A228),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xFF28A228),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/logos/star_icon.svg',
            width: 14.w,
            height: 14.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 2.w),
          Text(
            '0',
            style: TextStyle(
              color: const Color(0xFF28A228),
              fontSize: 11.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.h,
      padding: EdgeInsets.all(5.w),
      decoration: ShapeDecoration(
        color: const Color(0x3328A228),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF28A228)),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/logos/person_icon.svg',
          width: 18.w,
          height: 18.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
