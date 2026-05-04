import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthService {
  static final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  static final _firebaseAuth = FirebaseAuth.instance;

  /// Returns Firebase ID token. Returns null only on user cancellation.
  /// Throws on real errors so caller can show a message.
  static Future<String?> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null; // cancelled

    final googleAuth = await account.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    return userCredential.user?.getIdToken();
  }

  static Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  /// Returns Firebase ID token. Returns null only on user cancellation.
  /// Throws on real errors so caller can show a message.
  static Future<String?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      return userCredential.user?.getIdToken();
    } on SignInWithAppleAuthorizationException {
      return null; // cancelled
    }
  }
}
