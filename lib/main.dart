import 'package:design_pattern_login/View/ViewLogin.dart';
import 'package:design_pattern_login/ViewModel/AuthViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp();
    if (kDebugMode) {
      print('Connect to Firebase successfully');
    }
  }catch(e){
    if (kDebugMode) {
      print('Connect failed');
    }
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Auth_ViewModel()),
  ],
    child: const Login(),
  ));
}
