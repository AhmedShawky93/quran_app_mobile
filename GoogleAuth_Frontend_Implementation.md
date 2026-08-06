# Google Authentication in Flutter Frontend

This document outlines the steps to implement Google Authentication in the Flutter frontend, integrating with the .NET Core backend.

## 1. Add Dependencies

Add the `google_sign_in` package to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_sign_in: ^6.1.0 # Use the latest version
```

Run `flutter pub get` to install the new dependency.

## 2. Configure Google Sign-In

### Android Setup

Follow the instructions in the `google_sign_in` package documentation to configure your Android project. This typically involves:

*   Adding the SHA-1 fingerprint of your signing key to your Firebase project.
*   Downloading `google-services.json` and placing it in the `android/app` directory.

### iOS Setup

Follow the instructions in the `google_sign_in` package documentation to configure your iOS project. This typically involves:

*   Adding a `REVERSED_CLIENT_ID` to your `Info.plist`.
*   Configuring URL schemes.

## 3. Implement Google Sign-In Logic

Create a service or use your existing BLoC/Cubit to handle the Google Sign-In flow.

```dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String _backendBaseUrl = 'YOUR_BACKEND_BASE_URL'; // e.g., 'https://localhost:5001'

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        // Could not get ID token
        return null;
      }

      // Send the ID token to your backend for verification and JWT generation
      final response = await http.post(
        Uri.parse('$_backendBaseUrl/api/auth/google-login'), // Adjust endpoint as per your backend
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'idToken': idToken,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String jwtToken = responseData['token'];
        // Store the JWT token securely (e.g., using flutter_secure_storage)
        return jwtToken;
      } else {
        // Handle backend error
        print('Backend error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
```

## 4. Integrate with UI

Add a Google Sign-In button to your login screen and call the `signInWithGoogle` method.

```dart
// Example usage in a Flutter Widget
ElevatedButton(
  onPressed: () async {
    final AuthService authService = AuthService(); // Get this from your DI container
    final String? token = await authService.signInWithGoogle();
    if (token != null) {
      // Navigate to home screen or update UI
      print('Signed in successfully! Token: $token');
    } else {
      // Show error message
      print('Google Sign-In failed.');
    }
  },
  child: Text('Sign in with Google'),
)
```

## 5. Security Considerations

*   **HTTPS:** Always ensure your backend communication uses HTTPS.
*   **Token Storage:** Store the received JWT token securely on the device (e.g., using `flutter_secure_storage`).
*   **Error Handling:** Implement comprehensive error handling and user feedback for all authentication steps.
