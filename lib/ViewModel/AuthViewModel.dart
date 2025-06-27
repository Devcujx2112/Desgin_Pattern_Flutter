import 'package:flutter/material.dart';

class Auth_ViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? validateEmail(String? value) {
    String emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    if (value == null || value.isEmpty) return "emailEmpty";
    RegExp regExp =RegExp(emailPattern);
    if(regExp.hasMatch(value)) return "emailFormat";
    return "true";
  }

  String? validatePassword(String? value){
    if(value == null || value.isEmpty) return "passwordNull";
    if(value.length <6) return "passwordLength";
    return "true";
  }
}