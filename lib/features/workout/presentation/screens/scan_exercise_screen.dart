import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/constants/app_assets.dart';
import 'dart:io';

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

class ScanExerciseScreen extends StatefulWidget {
  const ScanExerciseScreen({super.key});

  @override
  State<ScanExerciseScreen> createState() => _ScanExerciseScreenState();
}

class _ScanExerciseScreenState extends State<ScanExerciseScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;
  File? _capturedImage;

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
    });

    try {
      // Open camera to capture image
      // image_picker handles permissions automatically
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
          _isScanning = false;
        });
        
        // TODO: Process the captured image for exercise recognition
        _processCapturedImage(_capturedImage!);
      } else {
        setState(() {
          _isScanning = false;
        });
      }
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      
      // Handle permission denied or other errors
      String errorMessage = 'Failed to capture image: ${e.toString()}';
      if (e.toString().contains('permission') || e.toString().contains('denied')) {
        errorMessage = 'Camera permission is required to scan exercises. Please enable camera access in your device settings.';
      }
      
      _showErrorDialog(errorMessage);
    }
  }

  void _stopScan() {
    setState(() {
      _isScanning = false;
      _capturedImage = null;
    });
  }

  void _processCapturedImage(File image) {
    // TODO: Implement image processing for exercise recognition
    // This could involve:
    // 1. Sending image to ML model for exercise detection
    // 2. Analyzing the image for exercise form
    // 3. Providing feedback to the user
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image captured! Processing for exercise recognition...'),
        backgroundColor: Color(0xFF28A228),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.h),
            
            // Custom Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: responsiveHelper.w(16),
                vertical: responsiveHelper.h(8),
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
                      width: responsiveHelper.w(24),
                      height: responsiveHelper.h(24),
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF1E1E1E),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: responsiveHelper.w(8)),
                  Text(
                    'Scan Exercise',
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: responsiveHelper.sp(18),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0.89,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: responsiveHelper.h(28)),
            
            // Dashed Border Container
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(16)),
              child: Container(
                width: double.infinity,
                height: responsiveHelper.h(265),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Stack(
                  children: [
                    // Dashed border effect using CustomPaint
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
                    
                    // Camera Button in Center or Captured Image
                    Center(
                      child: _capturedImage != null
                          ? GestureDetector(
                              onTap: _startScan,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.r),
                                  image: DecorationImage(
                                    image: FileImage(_capturedImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/images/camera.svg',
                                            width: 24.w,
                                            height: 24.h,
                                            colorFilter: const ColorFilter.mode(
                                              Color(0xFF28A228),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          'Tap to scan again',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsiveHelper.sp(14),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: _isScanning ? null : _startScan,
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _isScanning 
                                        ? const Color(0xFF28A228).withValues(alpha: 0.5)
                                        : const Color(0xFF28A228).withValues(alpha: 0.2),
                                    width: 2.w,
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(24.w),
                                  decoration: BoxDecoration(
                                    color: _isScanning 
                                        ? const Color(0xFF28A228).withValues(alpha: 0.5)
                                        : const Color(0xFF28A228).withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: _isScanning
                                      ? SizedBox(
                                          width: 28.w,
                                          height: 28.h,
                                          child: const CircularProgressIndicator(
                                            color: Color(0xFF28A228),
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : SvgPicture.asset(
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
            ),
            
            SizedBox(height: responsiveHelper.h(40)),
            
            // Exercise Illustration
            Center(
              child: SizedBox(
                width: responsiveHelper.w(375),
                height: responsiveHelper.h(250),
                child: Image.asset(
                  AppAssets.exerciseGif,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            SizedBox(height: responsiveHelper.h(40)),
            
            // Stop Scan Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveHelper.w(16)),
              child: SizedBox(
                width: double.infinity,
                height: responsiveHelper.h(50),
                child: GestureDetector(
                  onTap: _capturedImage != null ? _stopScan : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _capturedImage != null 
                          ? Color(0xFFFF1A1A) // Red color for stop button
                          : Color(0xFF848484), // Gray when disabled
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Center(
                      child: Text(
                        _capturedImage != null ? 'Clear Image' : 'Stop Scan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsiveHelper.sp(16),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
