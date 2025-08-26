import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ScanYourMeal extends StatefulWidget {
  const ScanYourMeal({super.key});

  @override
  State<ScanYourMeal> createState() => _ScanYourMealState();
}

class _ScanYourMealState extends State<ScanYourMeal> {
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;
  bool _scanComplete = false;
  XFile? _scannedImage;

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (photo != null) {
        setState(() {
          _scannedImage = photo;
          _isScanning = true;
          _scanComplete = false;
        });
        
        // Simulate scanning process
        await Future.delayed(const Duration(seconds: 3));
        
        setState(() {
          _isScanning = false;
          _scanComplete = true;
        });
        
        log('Image captured: ${photo.path}');
        // You can navigate to a result screen or process the image here
      }
    } catch (e) {
      log('Error opening camera: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open camera: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F0), // Light green background
      appBar: null,
      body: Column(
        children: [
          SizedBox(height: 50.h),
          // Custom Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            decoration: const BoxDecoration(
              color: Color(0x26848484),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    'assets/logos/arrow_left.svg',
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Scan Your Meal',
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
          SizedBox(height: 50.h),
          // Main Content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Scanning Indicator
                  if (_isScanning)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF28A228), // Green background
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Text(
                        'Scanning...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  
                  if (_isScanning) SizedBox(height: 24.h),
                  
                  // Dashed Rectangle Scanning Area
                  Container(
                    width: 343.w,
                    height: 265.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF28A228), // Medium green color
                        width: 5.w,
                        style: BorderStyle.none, // Note: Flutter doesn't support dashed borders natively
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Stack(
                      children: [
                        // Dashed border effect using multiple small containers
                        Positioned.fill(
                          child: CustomPaint(
                            painter: DashedBorderPainter(
                              color: const Color(0xFF28A228),
                              strokeWidth: 4,
                              dashWidth: 30,
                              dashSpace: 24,
                            ),
                          ),
                        ),
                        
                        // Show scanned image or camera button
                        if (_scannedImage != null && !_scanComplete)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.r),
                              child: Image.file(
                                File(_scannedImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else if (_scanComplete)
                          // Show camera icon placeholder after scan complete
                          Center(
                            child: Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF28A228).withValues(alpha: 0.1),
                              ),
                              child: Center(
                                child: Container(
                                  width: 28.w,
                                  height: 28.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF28A228).withValues(alpha: 0.3),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/camera.svg',
                                    width: 28.w,
                                    height: 28.h,
                                    // colorFilter: const ColorFilter.mode(
                                    //   Color(0xFF28A228),
                                    //   BlendMode.srcIn,
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                           // Camera Button in Center
                           Center(
                             child: GestureDetector(
                               onTap: _openCamera,
                               child: Container(
                                 padding: EdgeInsets.all(12.w), // للتحكم في حجم الدائرة
                                 decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   border: Border.all(
                                     color: const Color(0xFF28A228).withValues(alpha: 0.2), // لون البوردر الخارجي
                                     width: 2.w, // سمك البوردر
                                   ),
                                 ),
                                 child: Container(
                                   padding: EdgeInsets.all(24.w),
                                   decoration: BoxDecoration(
                                     color: const Color(0xFF28A228).withValues(alpha: 0.2), // الخلفية الداخلية الفاتحة
                                     shape: BoxShape.circle,
                                   ),
                                   child: SvgPicture.asset(
                                     'assets/images/camera.svg',
                                     width: 28.w,
                                     height: 28.h,
                                    
                                   ),
                                 ),
                               ),
                             ),
                           ),
                      ],
                    ),
                  ),
                  
                  // Dynamic spacing based on scan state
                  if (_scanComplete)
                    const Spacer()
                  else
                    SizedBox(height: 50.h),
                  
                  // Calories Display (shown after scan complete)
                  if (_scanComplete) ...[
                    Container(
                      width: 375.w,
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: const Color(0x1E000000),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Total Calories Card
                          Container(
                            width: 343.w,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            decoration: ShapeDecoration(
                              color: const Color(0x26848484),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Total 180 Kcal',
                                  style: TextStyle(
                                    color: const Color(0xFF28A228),
                                    fontSize: 18.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  width: 45.w,
                                  height: 45.h,
                                  padding: EdgeInsets.all(13.w),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF28A228),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.50.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/fire2.svg',
                                      width: 32.w,
                                      height: 32.h,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 16.h),
                          
                          // Macronutrients Row
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Carbs
                                _buildMacroCard(
                                  icon: 'assets/images/carbs.png',
                                  amount: '50g',
                                  label: 'Carbs',
                                ),
                                SizedBox(width: 12.w),
                                // Protein
                                _buildMacroCard(
                                  icon: 'assets/images/carbs2.png',
                                  amount: '50g',
                                  label: 'Protein',
                                ),
                                SizedBox(width: 12.w),
                                // Fat
                                _buildMacroCard(
                                  icon: 'assets/images/carbs.png',
                                  amount: '50g',
                                  label: 'Fat',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Instruction Text
                    Text(
                      _scannedImage != null 
                        ? 'Meal scanned successfully!'
                        : 'Tap the camera button to scan your meal',
                      style: TextStyle(
                        color: const Color(0xFF666666),
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard({
    required String icon,
    required String amount,
    required String label,
  }) {
    return Container(
      width: 100.w,
      height: 120.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF7FFF7), // Light grey
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x19000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 32.w,
            height: 32.h,
          ),
          SizedBox(height: 8.h),
          Text(
            amount,
            style: TextStyle(
              color: const Color(0xFF28A228),
              fontSize: 16.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF999999),
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
// Custom painter for dashed border effect
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Create rounded rectangle path with 30 radius

    // Create dashed effect by drawing multiple small segments along the rounded rectangle
    final dashPath = Path();
    final dashLength = dashWidth + dashSpace;
    
    // Top border (with rounded corners)
    double currentX = 16; // Start after left rounded corner
    while (currentX < size.width - 16) {
      dashPath.moveTo(currentX, 0);
      dashPath.lineTo((currentX + dashWidth).clamp(currentX, size.width - 16), 0);
      currentX += dashLength;
    }
    
    // Right border (with rounded corners)
    double currentY = 16; // Start after top rounded corner
    while (currentY < size.height - 16) {
      dashPath.moveTo(size.width, currentY);
      dashPath.lineTo(size.width, (currentY + dashWidth).clamp(currentY, size.height - 16));
      currentY += dashLength;
    }
    
    // Bottom border (with rounded corners)
    currentX = size.width - 16; // Start before right rounded corner
    while (currentX > 16) {
      dashPath.moveTo(currentX, size.height);
      dashPath.lineTo((currentX - dashWidth).clamp(16, currentX), size.height);
      currentX -= dashLength;
    }
    
    // Left border (with rounded corners)
    currentY = size.height - 16; // Start before bottom rounded corner
    while (currentY > 16) {
      dashPath.moveTo(0, currentY);
      dashPath.lineTo(0, (currentY - dashWidth).clamp(16, currentY));
      currentY -= dashLength;
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
