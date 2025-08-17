import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/constants/app_assets.dart';

class LottieAnimatedLogo extends StatefulWidget {
  const LottieAnimatedLogo({super.key});

  @override
  State<LottieAnimatedLogo> createState() => _LottieAnimatedLogoState();
}

class _LottieAnimatedLogoState extends State<LottieAnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _lottieController;
  late Animation<Offset> _moveAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Controller for the movement animation
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Controller for the Lottie animation
    _lottieController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animation for moving from top-left to center
    _moveAnimation = Tween<Offset>(
      begin: const Offset(-2.5, -2.5), // Start from top-left corner
      end: Offset.zero, // End at center (0,0)
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeOutCubic, // Smooth easing
    ));

    // Animation for scaling effect
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeOutBack, // Slight bounce effect
    ));

    // Start the movement animation
    _moveController.forward();
    
    // Start the Lottie animation after a small delay
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        _lottieController.forward();
      }
    });
  }

  @override
  void dispose() {
    _moveController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final logoSize = ResponsiveHelper.getResponsiveLogoSize(context);
    
    return AnimatedBuilder(
      animation: _moveAnimation,
      builder: (context, child) {
        return Positioned(
          left: _moveAnimation.value.dx * screenWidth * 0.5 + 
                (screenWidth - logoSize) * 0.5, // Center horizontally
          top: _moveAnimation.value.dy * screenHeight * 0.5 + 
               (screenHeight - logoSize) * 0.5, // Center vertically
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Lottie.asset(
              AppAnimations.trackFitLogo,
              controller: _lottieController,
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
              repeat: false, // Don't repeat the animation
            ),
          ),
        );
      },
    );
  }
} 