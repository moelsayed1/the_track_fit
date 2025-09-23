import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../../core/constants/constants.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/lottie_animated_logo.dart';
import '../../../auth/data/cubit/auth_cubit.dart';
import '../../../auth/data/cubit/auth_states.dart';
import '../../../../core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _canNavigate = false;
  AuthState? _pendingState;
  
  @override
  void initState() {
    super.initState();
    
    // Check authentication immediately and set up navigation
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      log('SplashScreen: Initializing authentication...');
      
      // Check authentication directly first
      final storageService = await StorageService.getInstance();
      
      // Add a small delay to ensure SharedPreferences is fully initialized
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Check authentication status
      final hasValidSession = storageService.hasValidSession();
      
      if (hasValidSession) {
        // User is logged in, set up the auth state
        final authData = storageService.getAuthData();
        
        if (authData != null) {
          _pendingState = AuthUserAlreadyLoggedIn(
            token: authData.token,
            name: authData.user.name,
            email: authData.user.email,
            imagePath: authData.user.image,
            phone: authData.user.phone,
            gender: authData.user.gender,
          );
        } else {
          _pendingState = const AuthInitial();
        }
      } else {
        _pendingState = const AuthInitial();
      }
      
      // Also trigger the AuthCubit check for consistency
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<AuthCubit>().checkExistingLogin();
        }
      });
      
      // Allow navigation after minimum splash duration
      Timer(const Duration(milliseconds: 4000), () {
        if (mounted) {
          setState(() {
            _canNavigate = true;
          });
          _handlePendingNavigation();
        }
      });
      
    } catch (e) {
      log('SplashScreen: Error initializing auth: $e');
      _pendingState = const AuthInitial();
      
      Timer(const Duration(milliseconds: 4000), () {
        if (mounted) {
          setState(() {
            _canNavigate = true;
          });
          _handlePendingNavigation();
        }
      });
    }
  }
  
  void _handlePendingNavigation() async {
    if (_canNavigate && _pendingState != null) {
      if (_pendingState is AuthUserAlreadyLoggedIn) {
        // Check if user is first-time user
        final storageService = await StorageService.getInstance();
        final isFirstTime = storageService.isFirstTimeUser();
        
        if (isFirstTime) {
          // First-time user: go to home screen with "Start Workout" card
          context.go(AppRouter.home);
        } else {
          // Returning user: go to home_feature screen
          context.go(AppRouter.homeFeature);
        }
      } else if (_pendingState is AuthInitial) {
        context.go(AppRouter.onboarding);
      }
    } else if (_canNavigate && _pendingState == null) {
      // This should not happen with the new initialization logic
      context.go(AppRouter.onboarding);
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUserAlreadyLoggedIn || state is AuthInitial) {
          _pendingState = state;
          _handlePendingNavigation();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.splashGradient,
          ),
          child: Stack(
            children: [
                // Lottie animated logo that moves from top-left to center
                const LottieAnimatedLogo(),
            ],
          ),
        ),
      ),
    );
  }
} 