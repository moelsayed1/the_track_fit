import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/features/auth/data/cubit/auth_cubit.dart';
import 'package:the_track_fit/features/auth/data/cubit/auth_states.dart';
import 'package:the_track_fit/core/widgets/custom_snackbar.dart';
import '../../../../../generated/l10n/app_localizations.dart';

class ChangePasswordProfile extends StatefulWidget {
  const ChangePasswordProfile({super.key});

  @override
  State<ChangePasswordProfile> createState() => _ChangePasswordProfileState();
}

class _ChangePasswordProfileState extends State<ChangePasswordProfile> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool showActionButtons = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers to detect when text changes
    newPasswordController.addListener(_checkIfShouldShowButtons);
    confirmPasswordController.addListener(_checkIfShouldShowButtons);
  }

  void _checkIfShouldShowButtons() {
    bool hasText =
        newPasswordController.text.isNotEmpty ||
        confirmPasswordController.text.isNotEmpty;

    if (hasText != showActionButtons) {
      setState(() {
        showActionButtons = hasText;
      });
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility(String field) {
    setState(() {
      switch (field) {
        case 'new':
          isNewPasswordVisible = !isNewPasswordVisible;
          break;
        case 'confirm':
          isConfirmPasswordVisible = !isConfirmPasswordVisible;
          break;
      }
    });
  }

  void _handleChangePassword() {
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      CustomSnackbar.show(
        context,
        title: AppLocalizations.of(context)!.validationError,
        message: AppLocalizations.of(context)!.pleaseEnterANewPassword,
        type: SnackbarType.error,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      CustomSnackbar.show(
        context,
        title: AppLocalizations.of(context)!.validationError,
        message: AppLocalizations.of(context)!.passwordsDoNotMatch,
        type: SnackbarType.error,
      );
      return;
    }

    if (newPasswordController.text.length < 6) {
      CustomSnackbar.show(
        context,
        title: AppLocalizations.of(context)!.validationError,
        message: AppLocalizations.of(context)!.passwordMustBeAtLeast6Characters,
        type: SnackbarType.error,
      );
      return;
    }

    context.read<AuthCubit>().changePassword(
      newPassword: newPasswordController.text,
      newPasswordConfirmation: confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthChangePasswordSuccess) {
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.success,
            message: state.message,
            type: SnackbarType.success,
          );
          // Clear the form
          newPasswordController.clear();
          confirmPasswordController.clear();
          // Navigate back
          context.pop();
        } else if (state is AuthChangePasswordError) {
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.changePasswordFailed,
            message: state.message,
            type: SnackbarType.error,
          );
        } else if (state is AuthValidationError) {
          // Handle validation errors
          final firstError = state.fieldErrors.values.first;
          CustomSnackbar.show(
            context,
            title: AppLocalizations.of(context)!.validationError,
            message: firstError,
            type: SnackbarType.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6FFF6),
        body: SafeArea(
          child: Column(
            children: [
              // Custom Header at the top
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
                            AppLocalizations.of(context)!.changePassword,
                            style: TextStyle(
                              color: const Color(0xFF1E1E1E),
                              fontSize: 18.sp,
                              fontFamily:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'Cairo'
                                  : 'Poppins',
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
                            AppLocalizations.of(context)!.changePassword,
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

              // Main Content (Input Fields)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      children: [
                        SizedBox(height: 24.h),
                        _buildPasswordField(
                          controller: newPasswordController,
                          hintText: AppLocalizations.of(
                            context,
                          )!.newPasswordPlaceholder,
                          isPasswordVisible: isNewPasswordVisible,
                          onToggleVisibility: () =>
                              _togglePasswordVisibility('new'),
                        ),
                        SizedBox(height: 16.h),
                        _buildPasswordField(
                          controller: confirmPasswordController,
                          hintText: AppLocalizations.of(
                            context,
                          )!.confirmPasswordPlaceholder,
                          isPasswordVisible: isConfirmPasswordVisible,
                          onToggleVisibility: () =>
                              _togglePasswordVisibility('confirm'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons at the bottom
              if (showActionButtons) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Container(
                    width: 347.w,
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
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
                            shadows: const [
                              BoxShadow(
                                color: Color(0x2628A228),
                                blurRadius: 4,
                                offset: Offset(4, 0),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _handleChangePassword,
                              borderRadius: BorderRadius.circular(30.r),
                              child: Center(
                                child: BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    if (state is AuthLoading) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16.w,
                                            height: 16.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.saving,
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
                                      );
                                    }
                                    return Text(
                                      AppLocalizations.of(context)!.saveChanges,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.50,
                                        letterSpacing: 0.50,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            newPasswordController.clear();
                            confirmPasswordController.clear();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8.w),
                SvgPicture.asset(
                  'assets/images/lock_icon.svg',
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF28A228),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: !isPasswordVisible,
                    style: TextStyle(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 12.sp,
                      fontFamily:
                          Localizations.localeOf(context).languageCode == 'ar'
                          ? 'Cairo'
                          : 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: const Color(0xB2848484),
                        fontSize: 12.sp,
                        fontFamily:
                            Localizations.localeOf(context).languageCode == 'ar'
                            ? 'Cairo'
                            : 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggleVisibility,
            child: SvgPicture.asset(
              isPasswordVisible
                  ? 'assets/images/eye-slash.svg'
                  : 'assets/images/eye.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                Color(0xFF848484),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
