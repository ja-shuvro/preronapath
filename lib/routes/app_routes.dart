import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/main/home_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String signUp = '/signup';
  static const String otp = '/otp';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => AuthGuard(settings.name),
    );
  }
}

// ✅ Middleware for Authentication
class AuthGuard extends StatelessWidget {
  final String? routeName;
  AuthGuard(this.routeName);

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return StreamBuilder(
      stream: authController.authStateChanges(),
      builder: (context, snapshot) {
        bool isAuthenticated = snapshot.hasData;

        Map<String, Widget> publicRoutes = {
          AppRoutes.login: LoginScreen(),
          AppRoutes.signUp: SignUpScreen(),
          AppRoutes.otp: OtpScreen(),
        };

        Map<String, Widget> privateRoutes = {
          AppRoutes.home: HomeScreen(),
        };

        if (isAuthenticated) {
          return privateRoutes[routeName] ?? HomeScreen();
        } else {
          return publicRoutes[routeName] ?? LoginScreen();
        }
      },
    );
  }
}
