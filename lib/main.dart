import 'package:design_pattern_login/View/AreaMonitor.dart';
import 'package:design_pattern_login/View/NavigationMenu.dart';
import 'package:design_pattern_login/View/Statistical.dart';
import 'package:design_pattern_login/View/ViewLogin.dart';
import 'package:design_pattern_login/View/Warning.dart';
import 'package:design_pattern_login/ViewModel/AreaMonitorViewModel.dart';
import 'package:design_pattern_login/ViewModel/AuthViewModel.dart';
import 'package:design_pattern_login/ViewModel/HomePageViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'View/HomePage.dart';
import 'View/ViewRegister.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    if (kDebugMode) {
      print('Connect to Firebase successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Connect failed');
    }
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth_ViewModel>(create: (_) => Auth_ViewModel()),
        ChangeNotifierProvider<HomePageViewModel>(create: (_) => HomePageViewModel()),
        ChangeNotifierProvider<AreaMontitorViewModel>(create: (_) => AreaMontitorViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => Login(),
      routes: [
        GoRoute(
          path: 'Register',
          builder: (context, state) => Register(),
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) => NavigationMenu(child: child),
      routes: [
        GoRoute(
          path: '/HomePage',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/AreaMonitor',
          builder: (context, state) => AreaMontitor(),
        ),
        GoRoute(
          path: '/Warning',
          builder: (context, state) => Warning(),
        ),
        GoRoute(
          path: '/Statistical',
          builder: (context, state) => Statistical(),
        ),
      ],
    ),
  ],
);
