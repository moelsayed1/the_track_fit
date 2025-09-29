import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;
  GoogleSignInService._internal();

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Sign in with Google
  Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      log('GoogleSignInService: Starting Google sign in...');
      
      // Initialize GoogleSignIn for Android-only app
      // Note: Android requires serverClientId even for Android-only apps
      await _googleSignIn.initialize(
        serverClientId: '1039938398263-npmftijoj273247molqh8mjj8ekkarn1.apps.googleusercontent.com',
      );
      
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      
      if (googleUser == null) {
        log('GoogleSignInService: Google sign in was cancelled by user');
        return GoogleSignInResult.cancelled();
      }

      log('GoogleSignInService: Google user obtained: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        log('GoogleSignInService: No Firebase user found after credential sign in');
        return GoogleSignInResult.error('Failed to authenticate with Firebase');
      }

      log('GoogleSignInService: Firebase user obtained: ${firebaseUser.email}');

      // Get Firebase ID token
      final String? idToken = await firebaseUser.getIdToken();
      
      if (idToken == null) {
        log('GoogleSignInService: Failed to get Firebase ID token');
        return GoogleSignInResult.error('Failed to get authentication token');
      }

      log('GoogleSignInService: Google sign in successful');
      log('GoogleSignInService: Firebase ID Token generated successfully');
      log('GoogleSignInService: Token (first 50 chars): ${idToken.substring(0, idToken.length > 50 ? 50 : idToken.length)}...');
      log('GoogleSignInService: Token (full): $idToken');
      log('GoogleSignInService: Token length: ${idToken.length}');

      // Try to get phone number from Google account
      String? phoneNumber;
      try {
        // Note: Google Sign-In doesn't provide phone numbers by default
        // This is a placeholder - phone numbers are not available through Google Sign-In
        phoneNumber = null; // Will use placeholder in auth repository
        log('GoogleSignInService: Phone number not available from Google Sign-In');
      } catch (e) {
        log('GoogleSignInService: Could not get phone number: $e');
      }

      return GoogleSignInResult.success(
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? '',
        idToken: idToken,
        accessToken: '', // Not available in this approach
        phone: phoneNumber,
        profileImageUrl: firebaseUser.photoURL,
      );

    } catch (e) {
      log('GoogleSignInService: Error during Google sign in: $e');
      return GoogleSignInResult.error(e.toString());
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      log('GoogleSignInService: Signing out from Google...');
      await Future.wait([
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
      log('GoogleSignInService: Successfully signed out from Google');
    } catch (e) {
      log('GoogleSignInService: Error during sign out: $e');
    }
  }
}

/// Result class for Google Sign-In operations
class GoogleSignInResult {
  final bool isSuccess;
  final bool isCancelled;
  final String? error;
  final String? email;
  final String? name;
  final String? phone;
  final String? idToken;
  final String? accessToken;
  final String? profileImageUrl;

  GoogleSignInResult._({
    required this.isSuccess,
    required this.isCancelled,
    this.error,
    this.email,
    this.name,
    this.phone,
    this.idToken,
    this.accessToken,
    this.profileImageUrl,
  });

  factory GoogleSignInResult.success({
    required String email,
    required String name,
    required String idToken,
    required String accessToken,
    String? phone,
    String? profileImageUrl,
  }) {
    return GoogleSignInResult._(
      isSuccess: true,
      isCancelled: false,
      email: email,
      name: name,
      phone: phone,
      idToken: idToken,
      accessToken: accessToken,
      profileImageUrl: profileImageUrl,
    );
  }

  factory GoogleSignInResult.cancelled() {
    return GoogleSignInResult._(
      isSuccess: false,
      isCancelled: true,
    );
  }

  factory GoogleSignInResult.error(String error) {
    return GoogleSignInResult._(
      isSuccess: false,
      isCancelled: false,
      error: error,
    );
  }
}