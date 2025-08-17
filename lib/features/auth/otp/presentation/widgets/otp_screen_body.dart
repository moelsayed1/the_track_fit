import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/otp_input_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/router/app_router.dart';

class OtpScreenBody extends StatefulWidget {
  final String email;
  
  const OtpScreenBody({
    super.key,
    required this.email,
  });

  @override
  State<OtpScreenBody> createState() => _OtpScreenBodyState();
}

class _OtpScreenBodyState extends State<OtpScreenBody> {
  final List<TextEditingController> _otpControllers = List.generate(
    4, 
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> _focusNodes = List.generate(
    4, 
    (index) => FocusNode(),
  );
  
  bool _isLoading = false;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    // Add focus listeners to trigger rebuilds when focus changes
    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(4.3), // 16px equivalent
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: responsive.hp(0)), // 44px equivalent
          
          // OTP Logo/Illustration
          _buildOtpLogo(responsive),
          
          SizedBox(height: responsive.hp(2)), // 32px equivalent
          
          // OTP Content Section
          _buildOtpContent(responsive),
          
          SizedBox(height: responsive.hp(4)), // 16px equivalent
          
          // Verify Button
          _buildVerifyButton(responsive),
          
          SizedBox(height: responsive.hp(4)), // 16px equivalent
        ],
      ),
    );
  }

  Widget _buildOtpLogo(ResponsiveHelper responsive) {
    return SizedBox(
      width: responsive.w(250),
      height: responsive.h(250),
      child: SvgPicture.asset(
        AppLogos.otp,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildOtpContent(ResponsiveHelper responsive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // OTP Title
        Text(
          'OTP',
          style: AppTextStyles.heading2.copyWith(
            fontSize: responsive.sp(20),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF111827),
          ),
        ),
        
        SizedBox(height: responsive.h(16)),
        
        // Email instruction text
        Text(
          'Code has been sent to ${widget.email}',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: responsive.sp(10),
            color: AppColors.gray,
          ),
        ),
        
        SizedBox(height: responsive.h(16)),
        
        // OTP Input Fields
        _buildOtpInputFields(responsive),
      ],
    );
  }

  Widget _buildOtpInputFields(ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.w(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (index) {
          return Row(
            children: [
                 OtpInputField(
                 controller: _otpControllers[index],
                 focusNode: _focusNodes[index],
                 isActive: _focusNodes[index].hasFocus,
                 isFilled: _otpControllers[index].text.isNotEmpty,
                 onChanged: (value) => _handleOtpChange(value, index),
                 onTap: () => _handleOtpTap(index),
               ),
              if (index < 3) SizedBox(width: responsive.w(10)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildVerifyButton(ResponsiveHelper responsive) {
    return PrimaryButton(
      text: 'Verify',
      onPressed: _isLoading ? null : _handleVerify,
      isLoading: _isLoading,
      height: responsive.h(56),
    );
  }

  void _handleOtpChange(String value, int index) {
    setState(() {
      _otpCode = _otpControllers.map((c) => c.text).join();
    });
    
    // Auto-focus to next field
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Auto-focus to previous field on delete
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _handleOtpTap(int index) {
    // Focus the tapped field
    _focusNodes[index].requestFocus();
  }

  void _handleVerify() async {
    if (_otpCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 4-digit OTP'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement OTP verification logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
              if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP verified successfully!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          
          // Navigate to New Password screen
          context.push(AppRouter.newPassword);
        }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}