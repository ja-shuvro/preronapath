import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // ✅ Sign In with Phone Number
  Future<void> signInWithPhone(String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        notifyListeners();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Verification failed")));
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        Navigator.pushNamed(context, AppRoutes.otp, arguments: phoneNumber);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // ✅ Verify OTP
  Future<void> verifyOtp(String smsCode, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid OTP")));
    }
  }

  // ✅ Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
