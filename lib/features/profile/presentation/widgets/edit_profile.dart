import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isAnyFieldEditing = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  void _onFieldEditingChanged(bool isEditing) {
    setState(() {
      _isAnyFieldEditing = isEditing;
    });
  }

  bool _getIsAnyFieldEditing() {
    return _isAnyFieldEditing;
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Choose Image Source',
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: 'Poppins',
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
                  'Camera',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
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
                  'Gallery',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
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
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDefaultProfileImage() {
    return Container(
      width: 150.w,
      height: 150.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE0E0E0),
      ),
      child: Icon(
        Icons.person,
        size: 60.sp,
        color: const Color(0xFF9E9E9E),
      ),
    );
  }

  void _saveChanges() {
    setState(() {
      _isAnyFieldEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile updated successfully!',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF28A228),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0x26848484),
                  ),
                  child: Row(
                    children: [
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
                        'Edit Profile',
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
                                      child: _selectedImage != null
                                          ? Image.file(
                                              _selectedImage!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return _buildDefaultProfileImage();
                                              },
                                            )
                                          : Image.asset(
                                              'assets/images/profile_image.png',
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                  stackTrace) {
                                                return _buildDefaultProfileImage();
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 96.w,
                                  top: 112.h,
                                  child: Tooltip(
                                    message:
                                        'Tap to change profile picture',
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
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              _buildInputField(
                                icon: 'assets/images/email_icon.svg',
                                label: 'E-mail',
                                value: 'user@example.com',
                              ),
                              SizedBox(height: 16.h),
                              _buildInputField(
                                icon: 'assets/images/phone_icon.svg',
                                label: 'Phone',
                                value: '+1234567890',
                              ),
                              SizedBox(height: 16.h),
                              _buildInputField(
                                icon: 'assets/images/person_card.svg',
                                label: 'Username',
                                value: 'username123',
                              ),
                            ],
                          ),
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
                          horizontal: 8.w, vertical: 16.h),
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
                          )
                        ],
                      ),
                      child: GestureDetector(
                        onTap: _saveChanges,
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = null;
                          _isAnyFieldEditing = false;
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
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String icon,
    required String label,
    required String value,
  }) {
    return _EditableTextFormField(
      icon: icon,
      label: label,
      initialValue: value,
      onEditingChanged: _onFieldEditingChanged,
    );
  }
}

class _EditableTextFormField extends StatefulWidget {
  final String icon;
  final String label;
  final String initialValue;
  final Function(bool) onEditingChanged;

  const _EditableTextFormField({
    required this.icon,
    required this.label,
    required this.initialValue,
    required this.onEditingChanged,
  });

  @override
  State<_EditableTextFormField> createState() =>
      _EditableTextFormFieldState();
}

class _EditableTextFormFieldState extends State<_EditableTextFormField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
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
      case 'username':
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: _isEditing
              ? const Color(0xFF28A228)
              : const Color(0x26848484),
          width: _isEditing ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(
                  widget.icon,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(width: 8.w),
                if (_isEditing)
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
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
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      focusNode: _focusNode,
                      autofocus: true,
                      keyboardType: _getKeyboardType(),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _toggleEdit(),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _isEditing = false;
                            _focusNode.unfocus();
                          });
                          widget.onEditingChanged(false);
                        }
                      },
                    ),
                  )
                else
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: const Color(0xB2848484),
                      fontSize: 12.sp,
                      fontFamily: 'Poppins',
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
