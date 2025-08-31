import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isAnyFieldEditing = false;

  void _onFieldEditingChanged(bool isEditing) {
    setState(() {
      _isAnyFieldEditing = isEditing;
    });
  }

  bool _getIsAnyFieldEditing() {
    return _isAnyFieldEditing;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                            // Main Profile Picture
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
                                  child: Image.asset(
                                    'assets/images/profile_image.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                                    },
                                  ),
                                ),
                              ),
                            ),
                            
                            // Edit Button Overlay
                            Positioned(
                              left: 96.w,
                              top: 112.h,
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
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF1E1E1E),
                                      BlendMode.srcIn,
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
                          // Email Field
                          _buildInputField(
                            icon: 'assets/images/email_icon.svg',
                            label: 'E-mail',
                            value: 'user@example.com',
                          ),
                          
                          SizedBox(height: 16.h),
                          
                          // Phone Field
                          _buildInputField(
                            icon: 'assets/images/phone_icon.svg',
                            label: 'Phone',
                            value: '+1234567890',
                          ),
                          
                          SizedBox(height: 16.h),
                          
                          // Username Field
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
             
             // Action Buttons at the bottom of the screen
             if (_getIsAnyFieldEditing())
               Positioned(
                 bottom: 0,
                 left: 0,
                 right: 0,
                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     boxShadow: [
                       BoxShadow(
                         color: const Color(0x19000000),
                         blurRadius: 8.r,
                         offset: Offset(0, -2),
                         spreadRadius: 0,
                       ),
                     ],
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
                         width: 246.w,
                         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
                         decoration: ShapeDecoration(
                           gradient: LinearGradient(
                             begin: Alignment(0.00, 0.50),
                             end: Alignment(1.00, 0.50),
                             colors: [const Color(0xFF28A228), const Color(0xD85CD65C)],
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
                       SizedBox(width: 16.w),
                       Text(
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
                     ],
                   ),
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
  State<_EditableTextFormField> createState() => _EditableTextFormFieldState();
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
        // Entering edit mode - focus the text field
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      } else {
        // Exiting edit mode - unfocus and save changes
        _focusNode.unfocus();
        // You can add validation or API calls here
      }
      // Notify parent about editing state change
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
                              // Auto-disable edit mode when text becomes empty
                              if (value.isEmpty) {
                                setState(() {
                                  _isEditing = false;
                                  _focusNode.unfocus();
                                });
                                // Notify parent about editing state change
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
                _isEditing ? const Color(0xFF28A228) :  Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

}