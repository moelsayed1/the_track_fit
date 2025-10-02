import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/widgets/custom_snackbar.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../auth/data/cubit/auth_cubit.dart';
import '../../../auth/data/cubit/auth_states.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isAnyFieldEditing = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // TextEditingController for all form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  // Store original values to track changes
  String _originalUsername = '';
  String _originalEmail = '';
  String _originalPhone = '';
  String _originalGender = '';

  // Initialize with current user data
  @override
  void initState() {
    super.initState();
    log('EditProfile: initState called');
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() {
    // Load current user data from AuthCubit
    final authCubit = context.read<AuthCubit>();
    log('EditProfile: Loading current user data...');

    // Check if we already have user data
    log('EditProfile: Current user data before load:');
    log('EditProfile: _originalUsername = $_originalUsername');
    log('EditProfile: _originalEmail = $_originalEmail');
    log('EditProfile: _originalPhone = $_originalPhone');
    log('EditProfile: _originalGender = $_originalGender');

    authCubit.loadUserProfile();

    // Don't set any text initially - let the BlocListener handle it
    // when AuthUserProfileLoaded is received
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _onFieldEditingChanged(bool isEditing) {
    setState(() {
      _isAnyFieldEditing = isEditing;
    });
  }

  // Method to trigger UI update when fields change
  void _onFieldChanged() {
    setState(() {
      // This will trigger a rebuild to update the save button state
    });
  }

  bool _getIsAnyFieldEditing() {
    return _isAnyFieldEditing;
  }

  Future<void> _showImageSourceDialog() async {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            l10n?.chooseImageSource ?? 'Choose Image Source',
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: isArabic ? 'Cairo' : 'Poppins',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: const Color(0xFF28A228),
                  size: 24.sp,
                ),
                title: Text(
                  l10n?.camera ?? 'Camera',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: isArabic ? 'Cairo' : 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: const Color(0xFF28A228),
                  size: 24.sp,
                ),
                title: Text(
                  l10n?.gallery ?? 'Gallery',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: isArabic ? 'Cairo' : 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 300,
        maxHeight: 300,
      );

      if (image != null) {
        final originalImageFile = File(image.path);

        // Check if file exists before proceeding
        if (!originalImageFile.existsSync()) {
          final l10n = AppLocalizations.of(context);
          CustomSnackbar.show(
            context,
            title: l10n?.imageError ?? 'Image Error',
            message:
                l10n?.selectedImageFileIsNotAccessible ??
                'Selected image file is not accessible',
            type: SnackbarType.error,
          );
          return;
        }

        // Copy the image to a more permanent location to prevent cleanup
        final permanentImageFile = await _copyImageToPermanentLocation(
          originalImageFile,
        );

        setState(() {
          _selectedImage = permanentImageFile;
        });
        _onFieldChanged(); // Trigger UI update for save button

        // Upload image with current user data to API
        await _uploadImageToAPI(permanentImageFile);
      }
    } catch (e) {
      // Handle error
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${l10n?.errorPickingImage ?? "Error picking image"}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<File> _copyImageToPermanentLocation(File originalFile) async {
    try {
      // Get the application documents directory
      final directory = Directory.systemTemp;

      // Create a unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_image_$timestamp.jpg';
      final permanentPath = '${directory.path}/$fileName';

      log(
        'EditProfile: Copying image from ${originalFile.path} to $permanentPath',
      );

      // Copy the file to the permanent location
      final permanentFile = await originalFile.copy(permanentPath);

      log('EditProfile: Image copied successfully to ${permanentFile.path}');
      log('EditProfile: Permanent file exists: ${permanentFile.existsSync()}');

      return permanentFile;
    } catch (e) {
      log('EditProfile: Error copying image: $e');
      // If copying fails, return the original file
      return originalFile;
    }
  }

  Future<void> _uploadImageToAPI(File imageFile) async {
    try {
      log(
        'EditProfile: _uploadImageToAPI called with imageFile: ${imageFile.path}',
      );
      log('EditProfile: imageFile.existsSync(): ${imageFile.existsSync()}');

      final l10n = AppLocalizations.of(context);

      // Show loading indicator
      CustomSnackbar.show(
        context,
        title: l10n?.uploadingImage ?? 'Uploading Image',
        message:
            l10n?.pleaseWaitWhileWeUploadYourImage ??
            'Please wait while we upload your image...',
        type: SnackbarType.info,
      );

      // For image-only upload, we'll use the local storage approach
      // and then try to upload to API with minimal data
      log('EditProfile: Using local storage for image upload');

      // Convert image to base64 and store locally first
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      // Update local profile data with the new image
      context.read<AuthCubit>().updateUserProfileData(imagePath: base64String);

      // Show success message
      CustomSnackbar.show(
        context,
        title: l10n?.imageUploaded ?? 'Image Uploaded!',
        message:
            l10n?.yourProfileImageHasBeenUpdatedSuccessfully ??
            'Your profile image has been updated successfully',
        type: SnackbarType.success,
      );

      log('EditProfile: Image uploaded and stored locally as base64');
    } catch (e) {
      log('EditProfile: Error in _uploadImageToAPI: $e');
      final l10n = AppLocalizations.of(context);
      CustomSnackbar.show(
        context,
        title: l10n?.uploadFailed ?? 'Upload Failed',
        message:
            l10n?.failedToUploadImage ??
            'Failed to upload image. Please try again.',
        type: SnackbarType.error,
      );
    }
  }

  Widget _buildProfileImage() {
    // Priority: 1. Selected image, 2. Current user image, 3. Default person icon
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultProfileImage();
        },
      );
    }

    // Check if we have current user image from AuthCubit
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthUserProfileLoaded && state.imagePath != null) {
          final imageFile = File(state.imagePath!);
          if (imageFile.existsSync()) {
            return Image.file(
              imageFile,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultProfileImage();
              },
            );
          }
        }

        // Default person icon
        return _buildDefaultProfileImage();
      },
    );
  }

  Widget _buildDefaultProfileImage() {
    return Container(
      width: 150.w,
      height: 150.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE0E0E0),
      ),
      child: Icon(Icons.person, size: 60.sp, color: const Color(0xFF9E9E9E)),
    );
  }

  // Check if any field has been changed (excluding image since it's uploaded immediately)
  bool _hasChanges() {
    return _usernameController.text != _originalUsername ||
        _emailController.text != _originalEmail ||
        _phoneController.text != _originalPhone ||
        _passwordController.text.isNotEmpty;
  }

  // Get only the changed fields (excluding image since it's uploaded immediately)
  Map<String, dynamic> _getChangedFields() {
    final changes = <String, dynamic>{};

    if (_usernameController.text != _originalUsername) {
      changes['name'] = _usernameController.text;
    }
    if (_emailController.text != _originalEmail) {
      changes['email'] = _emailController.text;
    }
    if (_phoneController.text != _originalPhone) {
      changes['phone'] = _phoneController.text;
    }
    if (_passwordController.text.isNotEmpty) {
      changes['password'] = _passwordController.text;
      changes['password_confirmation'] = _passwordConfirmationController.text;
    }

    // Always include gender to satisfy API requirement
    changes['gender'] = _genderController.text.isNotEmpty
        ? _genderController.text
        : _originalGender;

    // Note: Image is uploaded immediately when selected, not included in save changes

    return changes;
  }

  void _saveChanges() {
    final l10n = AppLocalizations.of(context);

    // Check if there are any changes
    if (!_hasChanges()) {
      CustomSnackbar.show(
        context,
        title: l10n?.noChanges ?? 'No Changes',
        message: l10n?.noChangesDetectedToSave ?? 'No changes detected to save',
        type: SnackbarType.info,
      );
      return;
    }

    // Validate password fields if password is provided
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _passwordConfirmationController.text) {
      CustomSnackbar.show(
        context,
        title: l10n?.validationError ?? 'Validation Error',
        message: l10n?.passwordsDoNotMatch ?? 'Passwords do not match',
        type: SnackbarType.error,
      );
      return;
    }

    // Get only changed fields (image is handled separately)
    final changes = _getChangedFields();

    // Call the API to update profile with only changed fields
    context.read<AuthCubit>().updateProfile(
      name: changes['name'],
      email: changes['email'],
      phone: changes['phone'],
      gender: _genderController.text.isNotEmpty
          ? _genderController.text
          : _originalGender,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUserProfileLoaded) {
          log('EditProfile: AuthUserProfileLoaded received with data:');
          log('EditProfile: name = ${state.name}');
          log('EditProfile: email = ${state.email}');
          log('EditProfile: phone = ${state.phone}');
          log('EditProfile: gender = ${state.gender}');
          log('EditProfile: imagePath = ${state.imagePath}');

          // Update form fields with current user data
          _usernameController.text = state.name.isNotEmpty ? state.name : '';
          _emailController.text = state.email.isNotEmpty ? state.email : '';
          _phoneController.text = state.phone ?? '';
          _genderController.text = state.gender ?? 'male';

          // Update original values for change tracking
          _originalUsername = state.name.isNotEmpty ? state.name : '';
          _originalEmail = state.email.isNotEmpty ? state.email : '';
          _originalPhone = state.phone ?? '';
          _originalGender = state.gender ?? 'male';

          log('EditProfile: Updated controllers:');
          log(
            'EditProfile: _usernameController.text = ${_usernameController.text}',
          );
          log('EditProfile: _emailController.text = ${_emailController.text}');
          log('EditProfile: _phoneController.text = ${_phoneController.text}');
          log(
            'EditProfile: _genderController.text = ${_genderController.text}',
          );

          log('EditProfile: Updated original values:');
          log('EditProfile: _originalUsername = $_originalUsername');
          log('EditProfile: _originalEmail = $_originalEmail');
          log('EditProfile: _originalPhone = $_originalPhone');
          log('EditProfile: _originalGender = $_originalGender');

          // Trigger UI update to show the loaded data
          setState(() {});
        } else if (state is AuthChangePasswordSuccess) {
          log('EditProfile: AuthChangePasswordSuccess received');
          log('EditProfile: _selectedImage = $_selectedImage');
          log('EditProfile: _hasChanges() = ${_hasChanges()}');

          // Check if this was an image upload (no other fields changed)
          final hasOnlyImageChange = _selectedImage != null && !_hasChanges();
          log('EditProfile: hasOnlyImageChange = $hasOnlyImageChange');

          if (hasOnlyImageChange) {
            log('EditProfile: This was an image-only upload');
            // The image has already been handled in _uploadImageToAPI
            // No need to show additional success message here
            log(
              'EditProfile: Image upload successful, AuthCubit should already have updated image path',
            );

            // Force a reload of the user profile to ensure the image path is updated
            log('EditProfile: Force reloading user profile...');
            context.read<AuthCubit>().loadUserProfile();

            // Keep the selected image so profile screen can display it
            // Don't clear _selectedImage here
          } else {
            final l10n = AppLocalizations.of(context);
            CustomSnackbar.show(
              context,
              title: l10n?.success ?? 'Success!',
              message: state.message,
              type: SnackbarType.success,
            );
            // Clear password fields
            _passwordController.clear();
            _passwordConfirmationController.clear();
            // Update original values after successful save
            _originalUsername = _usernameController.text;
            _originalEmail = _emailController.text;
            _originalPhone = _phoneController.text;
            _originalGender = _genderController.text;
          }

          setState(() {
            _isAnyFieldEditing = false;
          });
        } else if (state is AuthChangePasswordError) {
          final l10n = AppLocalizations.of(context);
          CustomSnackbar.show(
            context,
            title: l10n?.updateFailed ?? 'Update Failed',
            message: state.message,
            type: SnackbarType.error,
          );
        } else if (state is AuthValidationError) {
          // Handle validation errors
          final l10n = AppLocalizations.of(context);
          final firstError = state.fieldErrors.values.first;
          CustomSnackbar.show(
            context,
            title: l10n?.validationError ?? 'Validation Error',
            message: firstError,
            type: SnackbarType.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6FFF6),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Header
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final l10n = AppLocalizations.of(context);
                      final isArabic =
                          Localizations.localeOf(context).languageCode == 'ar';

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x26848484),
                        ),
                        child: Directionality(
                          textDirection: isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n?.editProfile ?? 'Edit Profile',
                                style: TextStyle(
                                  color: const Color(0xFF1E1E1E),
                                  fontSize: 18.sp,
                                  fontFamily: isArabic ? 'Cairo' : 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 0.89,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () => context.pop(),
                                child: Transform.rotate(
                                  angle: !isArabic
                                      ? 3.14159
                                      : 0, // Rotate 180 degrees for LTR
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Profile Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 24.h),

                          // Profile Picture Section
                          Center(
                            child: SizedBox(
                              width: 150.w,
                              height: 158.h,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 150.w,
                                      height: 150.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFE0E0E0),
                                      ),
                                      child: ClipOval(
                                        child: _buildProfileImage(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                                                      left: 96.w,
                                  top: 112.h,
                                  child: Tooltip(
                                    message: AppLocalizations.of(context)?.tapToChangeProfilePicture ?? 'Tap to change profile picture',
                                    child: GestureDetector(
                                        onTap: _showImageSourceDialog,
                                        child: Container(
                                          width: 46.w,
                                          height: 46.h,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF5F5F5),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 5,
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/images/edit_profile.svg',
                                              width: 24.w,
                                              height: 24.h,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                    Color(0xFF1E1E1E),
                                                    BlendMode.srcIn,
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
                          ),

                          SizedBox(height: 24.h),

                          // Input Fields Section
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              final l10n = AppLocalizations.of(context);

                              return SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    _buildInputField(
                                      icon: 'assets/images/email_icon.svg',
                                      label: l10n?.email ?? 'E-mail',
                                      controller: _emailController,
                                    ),
                                    SizedBox(height: 16.h),
                                    _buildInputField(
                                      icon: 'assets/images/phone_icon.svg',
                                      label: l10n?.phonePlaceholder ?? 'Phone',
                                      controller: _phoneController,
                                    ),
                                    SizedBox(height: 16.h),
                                    _buildInputField(
                                      icon: 'assets/images/person_card.svg',
                                      label: l10n?.username ?? 'Username',
                                      controller: _usernameController,
                                    ),
                                    // SizedBox(height: 16.h),
                                    // _buildInputField(
                                    //   icon: 'assets/images/person_card.svg',
                                    //   label: 'Gender',
                                    //   controller: _genderController,
                                    // ),
                                    // SizedBox(height: 16.h),
                                    // _buildInputField(
                                    //   icon: 'assets/images/lock_icon.svg',
                                    //   label: 'Password',
                                    //   controller: _passwordController,
                                    //   isPassword: true,
                                    // ),
                                    // SizedBox(height: 16.h),
                                    // _buildInputField(
                                    //   icon: 'assets/images/lock_icon.svg',
                                    //   label: 'Confirm Password',
                                    //   controller: _passwordConfirmationController,
                                    //   isPassword: true,
                                    // ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ✅ زرار الحفظ والإلغاء في Positioned جوه Stack
              if (_getIsAnyFieldEditing() || _selectedImage != null)
                Positioned(
                  bottom: 16.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 246.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 16.h,
                        ),
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, 0.50),
                            end: Alignment(1.00, 0.50),
                            colors: AppColors.primaryGradient.colors,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          shadows: [
                            BoxShadow(
                              color: const Color(0x2628A228),
                              blurRadius: 4.r,
                              offset: Offset(4, 0),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: _hasChanges() ? _saveChanges : null,
                          child: BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      AppLocalizations.of(context)?.saving ?? 'Saving...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: Localizations.localeOf(context).languageCode == 'ar' 
                                            ? 'Cairo' 
                                            : 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.50,
                                        letterSpacing: 0.50,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              final l10n = AppLocalizations.of(context);
                              final isArabic = Localizations.localeOf(context).languageCode == 'ar';
                              return Text(
                                _hasChanges() 
                                    ? (l10n?.saveChanges ?? 'Save Changes')
                                    : (l10n?.noChanges ?? 'No Changes'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _hasChanges()
                                      ? Colors.white
                                      : Colors.white70,
                                  fontSize: 16.sp,
                                  fontFamily: isArabic ? 'Cairo' : 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                  letterSpacing: 0.50,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = null;
                            _isAnyFieldEditing = false;
                          });
                                              },
                      child: Text(
                        AppLocalizations.of(context)?.cancel ?? 'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF848484),
                          fontSize: 16.sp,
                          fontFamily: Localizations.localeOf(context).languageCode == 'ar'
                              ? 'Cairo'
                              : 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: 0.50,
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String icon,
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return _EditableTextFormField(
      icon: icon,
      label: label,
      controller: controller,
      isPassword: isPassword,
      onEditingChanged: _onFieldEditingChanged,
      onChanged: _onFieldChanged,
    );
  }
}

class _EditableTextFormField extends StatefulWidget {
  final String icon;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final Function(bool) onEditingChanged;
  final VoidCallback? onChanged;

  const _EditableTextFormField({
    required this.icon,
    required this.label,
    required this.controller,
    this.isPassword = false,
    required this.onEditingChanged,
    this.onChanged,
  });

  @override
  State<_EditableTextFormField> createState() => _EditableTextFormFieldState();
}

class _EditableTextFormFieldState extends State<_EditableTextFormField> {
  late FocusNode _focusNode;
  bool _isEditing = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      } else {
        _focusNode.unfocus();
      }
      widget.onEditingChanged(_isEditing);
    });
  }

  TextInputType _getKeyboardType() {
    switch (widget.label.toLowerCase()) {
      case 'e-mail':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'name':
      case 'username':
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: _isEditing ? const Color(0xFF28A228) : const Color(0x26848484),
          width: _isEditing ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(widget.icon, width: 20.w, height: 20.h),
                SizedBox(width: 8.w),
                if (_isEditing)
                  Expanded(
                    child: Directionality(
                      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                      child: TextFormField(
                        controller: widget.controller,
                        obscureText: widget.isPassword && !_isPasswordVisible,
                        style: TextStyle(
                          color: const Color(0xFF1E1E1E),
                          fontSize: 14.sp,
                          fontFamily: isArabic ? 'Cairo' : 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          hintText: 'Enter ${widget.label.toLowerCase()}',
                          hintStyle: TextStyle(
                            color: const Color(0x66848484),
                            fontSize: 14.sp,
                            fontFamily: isArabic ? 'Cairo' : 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          suffixIcon: widget.isPassword
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFF848484),
                                    size: 20.sp,
                                  ),
                                )
                              : null,
                        ),
                        focusNode: _focusNode,
                        autofocus: true,
                        keyboardType: _getKeyboardType(),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _toggleEdit(),
                        onChanged: (value) {
                          widget.onChanged?.call(); // Call the parent onChanged
                          if (value.isEmpty) {
                            setState(() {
                              _isEditing = false;
                              _focusNode.unfocus();
                            });
                            widget.onEditingChanged(false);
                          }
                        },
                      ),
                    ),
                  )
                else
                  Text(
                    widget.controller.text.isNotEmpty
                        ? widget.controller.text
                        : widget.label,
                    style: TextStyle(
                      color: widget.controller.text.isNotEmpty
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xB2848484),
                      fontSize: 12.sp,
                      fontFamily: isArabic ? 'Cairo' : 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _toggleEdit,
            child: SvgPicture.asset(
              'assets/images/edit_profile.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(
                _isEditing ? const Color(0xFF28A228) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
