import 'package:design_pattern_login/View/ViewLogin.dart';
import 'package:design_pattern_login/ViewModel/AuthViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Auth_ViewModel()),
  ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router,debugShowCheckedModeBanner: false);
  }
}

final _router = GoRouter(initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => Login(),
        routes: [
          GoRoute(path: 'Register', builder: (BuildContext context, GoRouterState state) => Register(),
          )
        ]
      )
    ]);

