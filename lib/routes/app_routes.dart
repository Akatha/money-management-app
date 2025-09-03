import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:money_management_app/pages/home_page.dart';
import 'package:money_management_app/pages/login_page.dart';
import 'package:money_management_app/pages/signup_page.dart';
import 'package:money_management_app/routes/route_enum.dart';

class GoRouterConfig {
  static final router = GoRouter(
    // Routes
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoute.signup.name,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const HomePage(),

      ),
    ],

    // Redirect based on Hive login state
    redirect: (context, state) {
      final box = Hive.box('authBox');
      final isLoggedIn = box.get('isLoggedIn', defaultValue: false);

      final loggingIn = state.matchedLocation == '/'; // login page

      if (!isLoggedIn && !loggingIn) return '/'; // not logged in → go login
      if (isLoggedIn && loggingIn) return '/home'; // logged in → go home

      return null; // no redirect
    },
  );
}
