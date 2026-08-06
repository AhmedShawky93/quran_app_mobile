# Phone Authentication in Flutter Frontend

This document outlines the steps to implement Phone Authentication in the Flutter frontend using Firebase, and then sending the Firebase ID Token to the .NET Core backend for verification and JWT generation.

## 1. Add Dependencies

Add the `firebase_core` and `firebase_auth` packages to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.x.x # Use the latest version
  firebase_auth: ^4.x.x # Use the latest version
```

Run `flutter pub get` to install the new dependencies.

## 2. Configure Firebase Project

### 2.1. Firebase Project Setup

*   Create a Firebase project in the Firebase console.
*   Add your Flutter app to the Firebase project (Android and iOS).
    *   For Android, download `google-services.json` and place it in `android/app/`.
    *   For iOS, download `GoogleService-Info.plist` and place it in `ios/Runner/`.
*   Enable Phone Sign-in in Firebase Authentication.

### 2.2. Initialize Firebase in Flutter

Ensure Firebase is initialized in your `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

## 3. Implement Phone Authentication Logic

This involves sending an OTP to the user's phone number, verifying it, and then obtaining a Firebase ID Token.

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _backendBaseUrl = 'YOUR_BACKEND_BASE_URL'; // e.g., 'https://localhost:5001'

  String? _verificationId;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval on Android
        await _auth.signInWithCredential(credential);
        await _sendFirebaseTokenToBackend();
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Phone verification failed: ${e.message}');
        // Handle error
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        print('OTP sent to $phoneNumber');
        // Inform UI that OTP has been sent
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<String?> signInWithOtp(String otp) async {
    if (_verificationId == null) {
      print('Verification ID is null. Call verifyPhoneNumber first.');
      return null;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      return await _sendFirebaseTokenToBackend();
    } on FirebaseAuthException catch (e) {
      print('Error signing in with OTP: ${e.message}');
      // Handle error
      return null;
    }
  }

  Future<String?> _sendFirebaseTokenToBackend() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      print('No user signed in after phone authentication.');
      return null;
    }

    final String? firebaseIdToken = await user.getIdToken();
    if (firebaseIdToken == null) {
      print('Failed to get Firebase ID Token.');
      return null;
    }

    // Send the Firebase ID token to your backend for verification and JWT generation
    final response = await http.post(
      Uri.parse('$_backendBaseUrl/api/auth/phone-login'), // Adjust endpoint as per your backend
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firebaseIdToken': firebaseIdToken,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String jwtToken = responseData['token'];
      // Store the JWT token securely (e.g., using flutter_secure_storage)
      return jwtToken;
    } else {
      print('Backend error: ${response.body}');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
```

## 4. Integrate with UI

Your UI will need input fields for the phone number and the OTP, and buttons to trigger `verifyPhoneNumber` and `signInWithOtp`.

## 5. Security Considerations

*   **HTTPS:** Always ensure your backend communication uses HTTPS.
*   **Token Storage:** Store the received JWT token securely on the device (e.g., using `flutter_secure_storage`).
*   **Error Handling:** Implement comprehensive error handling and user feedback for all authentication steps.
*   **Firebase Quotas:** Be aware of Firebase's daily SMS quotas for phone authentication.
