import 'package:flutter_day_50/views/screens/chat/chat_screen.dart';

import '../views/screens/auth/sign_in_screen.dart';
import '../views/screens/auth/sign_up_screen.dart';
import '../views/screens/home/home_screen.dart';

class Routes {
  static final routes = {
    RouteNames.signIn: (context) => const SignInScreen(),
    RouteNames.signUp: (context) => const SignUpScreen(),
    RouteNames.home: (context) => const HomeScreen(),
  };
}

class RouteNames {
  static const signIn = "/signin";
  static const signUp = "/signup";
  static const home = "/home";
  // static const orders = "/orders";
  // static const settings = "/settings";
}
