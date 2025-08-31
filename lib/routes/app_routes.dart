import 'package:go_router/go_router.dart';
import 'package:money_management_app/pages/home_page.dart';
import 'package:money_management_app/pages/login_page.dart';
import 'package:money_management_app/routes/route_enum.dart';

import '../pages/signup_page.dart';

class GoRouterConfig {
  static final router = GoRouter(
    routes: [
      // Home
      GoRoute(
        path: '/',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      // Login

      // Register
      GoRoute(
        path: '/signup',
        name: AppRoute.signup.name,
        builder: (context, state) => const SignupPage(),
      ),
      // Profile
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const HomePage(),),],);}