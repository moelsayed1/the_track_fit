import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_track_fit/features/auth/data/cubit/auth_cubit.dart';
import 'package:the_track_fit/features/auth/data/cubit/auth_states.dart';

/// Example widget showing how profile image persistence works
class ProfileImagePersistenceExample extends StatefulWidget {
  const ProfileImagePersistenceExample({super.key});

  @override
  State<ProfileImagePersistenceExample> createState() => _ProfileImagePersistenceExampleState();
}

class _ProfileImagePersistenceExampleState extends State<ProfileImagePersistenceExample> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Image Persistence'),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          String? imagePath;
          
          if (state is AuthUserProfileLoaded) {
            imagePath = state.imagePath;
          } else if (state is AuthUserAlreadyLoggedIn) {
            imagePath = state.imagePath;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Image Display
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: ClipOval(
                    child: _buildProfileImage(imagePath),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Instructions
                const Text(
                  'Profile Image Persistence Demo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 10),
                
                const Text(
                  '1. Tap "Pick Image" to select a profile image\n'
                  '2. The image will be saved to SharedPreferences\n'
                  '3. Hot reload the app - the image will persist\n'
                  '4. The image will be displayed in the profile screen',
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 20),
                
                // Pick Image Button
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                ),
                
                const SizedBox(height: 10),
                
                // Clear Image Button
                ElevatedButton.icon(
                  onPressed: _clearImage,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Image'),
                ),
                
                const SizedBox(height: 20),
                
                // Image Info
                if (imagePath != null) ...[
                  const Text(
                    'Image Status:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Type: ${imagePath.startsWith('data:image/') ? 'Base64' : 'File Path'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Length: ${imagePath.length} characters',
                    style: const TextStyle(fontSize: 12),
                  ),
                ] else ...[
                  const Text(
                    'No image selected',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(
        Icons.person,
        size: 60,
        color: Colors.grey,
      );
    }

    if (imagePath.startsWith('data:image/')) {
      // Base64 image
      try {
        final bytes = base64Decode(imagePath);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        );
      } catch (e) {
        return const Icon(Icons.error, color: Colors.red);
      }
    } else {
      // File path
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, color: Colors.red);
        },
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        // Update profile image through AuthCubit
        context.read<AuthCubit>().updateProfileImage(File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _clearImage() {
    // Clear profile image through AuthCubit
    context.read<AuthCubit>().updateUserProfileData(imagePath: null);
  }
}
