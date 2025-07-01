import 'package:flutter/material.dart';

class Auth_ViewModel extends ChangeNotifier {
  final String aPIRealTime = "https://flutter-api-2f232-default-rtdb.firebaseio.com";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? messageError;

  String? validateEmail(String? value) {
    String emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    if (value == null || value.isEmpty){
     messageError = "emailEmpty";
     return messageError;
    }
    if(value.length <= 6){
      messageError = "emailLenght";
      return messageError;
    }
    RegExp regExp =RegExp(emailPattern);
    if(!regExp.hasMatch(value)){
      messageError = "emailFormat";
      return messageError;
    }
    return null;
  }

  String? validatePassword(String? value){
    if(value == null || value.isEmpty){
      messageError = "passwordNull";
      return messageError;
    }
    if(value.length <6){
      messageError = "passwordLength";
      return messageError;
    }
    return null;
  }

  String? validateConfirmPassword(String? value){
    if(value == null || value.isEmpty){
      messageError = "passwordNull";
      return messageError;
    }
    if(value.length <6){
      messageError = "passwordLength";
      return messageError;
    }
    if(value != confirmPasswordController.text){
     messageError = "noOverlap";
     return messageError;
    }
    return null;
  }
}