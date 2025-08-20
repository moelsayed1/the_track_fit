import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenFeature extends StatefulWidget {
  const HomeScreenFeature({super.key});

  @override
  State<HomeScreenFeature> createState() => _HomeScreenFeatureState();
}

class _HomeScreenFeatureState extends State<HomeScreenFeature> {
  int _currentIndex = 0; // 0: Home, 1: Workout, 2: Scan, 3: Report, 4: Plan
  int _selectedDateIndex = 3; // 0: Fri, 1: Sat, 2: Sun, 3: Mon, 4: Tue, 5: Wed, 6: Thu
  int _selectedExerciseIndex = 0; // Track which exercise is selected
  final List<bool> _favoriteStates = List.filled(4, false); // Track favorite states for 4 products
  bool _showWarningDialog = false; // Control warning dialog visibility
  final List<bool> _completedExercises = List.filled(4, false); // Track completed exercises


  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    switch (index) {
      case 0: // Home
// Show welcome UI
        break;
      case 1: // Workout
// Show workout UI
        break;
      case 2: // Scan
        // TODO: Add scan route when available
        break;
      case 3: // Report
        // TODO: Add report route when available
        break;
      case 4: // Plan
        // TODO: Add plan route when available
        break;
    }
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
        return 'Plan';
      default:
        return 'Home';
    }
  }

  void _onDateSelected(int index) {
    setState(() {
      _selectedDateIndex = index;
    });
  }

  void _onExerciseSelected(int index) {
    setState(() {
      _selectedExerciseIndex = index;
    });
  }

  void _onFavoriteToggled(int index) {
    setState(() {
      _favoriteStates[index] = !_favoriteStates[index];
    });
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

  void _onExerciseCompleted(int index) {
    setState(() {
      _completedExercises[index] = !_completedExercises[index];
    });
  }

  int get _completedWorkoutsCount {
    return _completedExercises.where((completed) => completed).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
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
                     )
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
                          fontSize: 13.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                   ],
                 ),
               ),
            // Main content
            Expanded(
              child: _buildWorkoutUI(),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildWorkoutUI() {
    return Column(
      children: [
        // Header with points, title, and profile
        _Header(title: _getScreenTitle(_currentIndex)),
        
                 // Main content
         Expanded(
           child: ListView(
             padding: EdgeInsets.zero,
             children: [
                             // Greeting section
               Padding(
                 padding: EdgeInsets.only(top: 20.h, bottom: 24.h, left: 16.w),
                 child: Row(
                   children: [
                     Text(
                       'Hi Disha! 👋',
                       style: TextStyle(
                         color: const Color(0xFF1E1E1E),
                         fontSize: 16.sp,
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w400,
                       ),
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
                                  color: _completedExercises[0] ? const Color(0xFFFFCC4D) : Colors.white, // Light orange when completed
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
                                  color: _completedExercises[1] ? const Color(0xFFFFB366) : Colors.white, // Light orange when completed
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
                                  color: _completedExercises[2] ? const Color(0xFFFFB366) : Colors.white, // Light orange when completed
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
                  height: 120.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                                           return Padding(
                       padding: EdgeInsets.only(right: 8.w),
                       child: ProductCard(
                         productName: 'Product name',
                         price: '20\$',
                         exerciseIcon: 'assets/images/product_image.png',
                         isFavorite: _favoriteStates[index],
                         onFavoriteTapped: () => _onFavoriteToggled(index),
                       ),
                     );
                    },
                  ),
                ),
              ),

              SizedBox(height: 32.h),

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
                 decoration: BoxDecoration(
                   color: const Color(0xFF28A228),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     _buildDateItem('Fri', '5', 0),
                     _buildDateItem('Sat', '6', 1),
                     _buildDateItem('Sun', '11', 2),
                     _buildDateItem('Mon', '7', 3),
                     _buildDateItem('Tue', '8', 4),
                     _buildDateItem('Wed', '9', 5),
                     _buildDateItem('Thu', '10', 6),
                   ],
                 ),
               ),

              SizedBox(height: 16.h),

                             // Exercise Cards
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 16.w),
                 child: ListView.builder(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: 4,
                   itemBuilder: (context, index) {
                     return Padding(
                       padding: EdgeInsets.only(bottom: 16.h),
                       child: GestureDetector(
                         onTap: () => _onExerciseSelected(index),
                                                 child: ExerciseCard(
                          exerciseTitle: 'Exercise Title',
                          setsAndReps: '4 Sets x 8 reps',
                          isLocked: index > 0, // First exercise is unlocked
                          isSelected: _selectedExerciseIndex == index,
                          isCompleted: _completedExercises[index],
                          onLockTapped: _onLockTapped,
                          onCompleted: () => _onExerciseCompleted(index),
                        ),
                       ),
                     );
                   },
                 ),
               ),

              SizedBox(height: 30.h), // Reduced padding for bottom nav
            ],
          ),
        ),
        
        // Bottom navigation bar
        Container(
          width: double.infinity,
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 8.h, left: 12.w, right: 12.w),
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
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Home tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabTapped(0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/logos/home_icon.svg',
                              width: 24.w,
                              height: 24.h,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                _getTabColor(0),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Home',
                              style: TextStyle(
                                color: _getTabColor(0),
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Workout tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabTapped(1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/logos/gym_icon.svg',
                              width: 24.w,
                              height: 24.h,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                _getTabColor(1),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Workout',
                              style: TextStyle(
                                color: _getTabColor(1),
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Central action button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabTapped(2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(14.w),
                              decoration: ShapeDecoration(
                                color: _currentIndex == 2
                                    ? const Color(0xFF28A228)
                                    : const Color(0xFF28A228),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 4,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30.w,
                                    height: 30.h,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/logos/scan_icon.svg',
                                          width: 28.w,
                                          height: 28.h,
                                          fit: BoxFit.contain,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Report tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabTapped(3),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/logos/progressive_icon.svg',
                              width: 24.w,
                              height: 24.h,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                _getTabColor(3),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'report',
                              style: TextStyle(
                                color: _getTabColor(3),
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Plan tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabTapped(4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logos/premium_icon.png',
                              width: 24.w,
                              height: 24.h,
                              fit: BoxFit.contain,
                              color: _getTabColor(4),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Plan',
                              style: TextStyle(
                                color: _getTabColor(4),
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateItem(String day, String date, int index) {
    bool isSelected = _selectedDateIndex == index;
    return GestureDetector(
      onTap: () => _onDateSelected(index),
      child: Container(
        width: 35.w,
        height: 50.h,
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
            Text(
              date,
              style: TextStyle(
                color: isSelected ? const Color(0xFF28A228) : Colors.white,
                fontSize: 11.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Product Card Widget
class ProductCard extends StatelessWidget {
  final String productName;
  final String price;
  final String exerciseIcon;
  final bool isFavorite;
  final VoidCallback? onFavoriteTapped;

  const ProductCard({
    super.key,
    required this.productName,
    required this.price,
    required this.exerciseIcon,
    this.isFavorite = false,
    this.onFavoriteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 120.h,
      padding: EdgeInsets.all(8.w),
      decoration: ShapeDecoration(
        color: const Color(0xFFD8F1D8),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFF28A228),
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
                     // Heart icon
           GestureDetector(
             onTap: onFavoriteTapped,
             child: SizedBox(
               width: 24.w,
               height: 24.h,
               child: Icon(
                 isFavorite ? Icons.favorite : Icons.favorite_border,
                 color: isFavorite ? Color(0xFF28A228) : const Color(0xFF28A228),
                 size: 20.w,
               ),
             ),
           ),
          SizedBox(height: 0.h),
                     // Product image
           Expanded(
             child: Center(
               child: SizedBox(
                 width: 60.w,
                 height: 60.h,
                 child: Image.asset(
                   exerciseIcon,
                   width: 70.w,
                   height: 70.h,
                   fit: BoxFit.contain,
                 ),
               ),
             ),
           ),
          // Product details
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                productName,
                style: TextStyle(
                  color: const Color(0xFF1E1E1E),
                  fontSize: 12.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
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
  final VoidCallback? onLockTapped;
  final VoidCallback? onCompleted;

  const ExerciseCard({
    super.key,
    required this.exerciseTitle,
    required this.setsAndReps,
    required this.isLocked,
    required this.isSelected,
    required this.isCompleted,
    this.onLockTapped,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
             decoration: ShapeDecoration(
         color: isSelected ? const Color(0xFFD8F1D8) : Colors.white, // Light green when selected
         shape: RoundedRectangleBorder(
           side: BorderSide(
             width: 1,
             color: const Color(0xFF28A228),
           ),
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
            child: Image.asset(
              'assets/images/exercise_image.png',
              width: 40.w,
              height: 40.h,
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
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF28A228),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
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
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
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
            _ProfileContainer(),
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
          side: const BorderSide(
            width: 1,
            color: Color(0xFF28A228),
          ),
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
        