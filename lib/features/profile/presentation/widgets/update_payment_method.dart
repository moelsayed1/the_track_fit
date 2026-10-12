import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';

class UpdatePaymentMethod extends StatefulWidget {
  const UpdatePaymentMethod({super.key});

  @override
  State<UpdatePaymentMethod> createState() => _UpdatePaymentMethodState();
}

class _UpdatePaymentMethodState extends State<UpdatePaymentMethod> {
  String? selectedPaymentMethod;
  bool isCardExpanded = false;
  bool showActionButtons = false;

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // No need to listen to text changes anymore
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expirationController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
      isCardExpanded = method == 'Card';

      // Show action buttons when Card is selected
      showActionButtons = method == 'Card';

      // Clear text when switching methods
      if (!isCardExpanded) {
        cardNumberController.clear();
        expirationController.clear();
        cvvController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 65.h),

                  // Payment Options Container
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        shadows: [
                          BoxShadow(
                            color: const Color(0x1E000000),
                            blurRadius: 4.r,
                            offset: const Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // PayPal Option
                          _buildPaymentOption(
                            'PayPal',
                            'assets/images/paypal.png',
                            28.w,
                            28.h,
                            'PayPal',
                            isSelected: selectedPaymentMethod == 'PayPal',
                          ),

                          SizedBox(height: 16.h),

                          // Card Option
                          _buildPaymentOption(
                            'Card',
                            'assets/images/card.png',
                            32.w,
                            32.h,
                            'Card',
                            isSelected: selectedPaymentMethod == 'Card',
                          ),

                          // Card Input Fields (only when Card is selected)
                          if (isCardExpanded) ...[
                            SizedBox(height: 16.h),
                            _buildCardInputFields(),
                          ],

                          SizedBox(height: 16.h),

                          // Instapay Option
                          _buildPaymentOption(
                            'Instapay',
                            'assets/images/instapay.png',
                            32.w,
                            32.h,
                            'Instapay',
                            isSelected: selectedPaymentMethod == 'Instapay',
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 320.h), // Bottom spacing for action buttons
                ],
              ),
            ),

            // Header at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Builder(
                builder: (context) {
                  final isArabic =
                      Localizations.localeOf(context).languageCode == 'ar';
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(color: const Color(0x26848484)),
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
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Update payment Method',
                            style: TextStyle(
                              color: AppColors.white,
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
                                  AppColors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Update payment Method',
                            style: TextStyle(
                              color: AppColors.white,
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
            ),

            // Action Buttons at the bottom
            if (showActionButtons)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Save Changes Button
                      GestureDetector(
                        onTap: () {
                          // Handle save changes
                          // You can add your save logic here
                          // For now, just show a success message or navigate back
                          context.pop();
                        },
                        child: Container(
                          width: 246.w,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 14.h,
                          ),
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(0.00, 0.50),
                              end: Alignment(1.00, 0.50),
                              colors: [Color(0xFF28A228), Color(0xD85CD65C)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            shadows: [
                              BoxShadow(
                                color: const Color(0x2628A228),
                                blurRadius: 4.r,
                                offset: const Offset(4, 0),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Save Changes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Cancel Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cardNumberController.clear();
                            expirationController.clear();
                            cvvController.clear();
                            showActionButtons = false;
                          });
                        },
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF848484),
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    String key,
    String imagePath,
    double imageWidth,
    double imageHeight,
    String label, {
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _selectPaymentMethod(key),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.w),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: isSelected
                  ? const Color(0xFF28A228)
                  : const Color(0x26848484),
            ),
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: key == 'Instapay' || key == 'PayPal' ? 55.w : 41.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Container(
                    width: imageWidth,
                    height: imageHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: key == 'Instapay' || key == 'PayPal' ? 55.w : 41.w,
                    child: Text(
                      label,
                      textAlign: key == 'PayPal'
                          ? TextAlign.start
                          : TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: key == 'PayPal' ? 10.sp : 12.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: key == 'PayPal' ? 1.60 : 1.33,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20.w,
              height: 20.h,
              padding: EdgeInsets.all(4.w),
              decoration: ShapeDecoration(
                color: isSelected
                    ? const Color(0xFF28A228)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: isSelected
                        ? const Color(0xFF28A228)
                        : const Color(0xFF848484),
                  ),
                  borderRadius: BorderRadius.circular(11.r),
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 9.w,
                        height: 9.h,
                        decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: const ShapeDecoration(shape: OvalBorder()),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInputFields() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: const Color(0x2628A228),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Number Field
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: ShapeDecoration(
              color: AppColors.surfaceVariant,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Color(0x26848484),
                ),
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //SizedBox(width: 2.w),
                SvgPicture.asset(
                  'assets/images/person_card.svg',
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF28A228),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextFormField(
                    controller: cardNumberController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Card Number',
                      hintStyle: TextStyle(
                        color: Color(0xB2848484),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // Expiration and CVV Fields Row
          Row(
            children: [
              // Expiration Field
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 4.h,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Color(0x26848484),
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //SizedBox(width: 8.w),
                      SvgPicture.asset(
                        'assets/images/person_card.svg',
                        width: 20.w,
                        height: 20.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF28A228),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextFormField(
                          controller: expirationController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Expiration',
                            hintStyle: TextStyle(
                              color: Color(0xB2848484),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // CVV Field
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 4.h,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Color(0x26848484),
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //SizedBox(width: 8.w),
                      SvgPicture.asset(
                        'assets/images/person_card.svg',
                        width: 20.w,
                        height: 20.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF28A228),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextFormField(
                          controller: cvvController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'CVV',
                            hintStyle: TextStyle(
                              color: Color(0xB2848484),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
