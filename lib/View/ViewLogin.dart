import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ViewModel/AuthViewModel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidePassword = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final VM_Login = Provider.of<Auth_ViewModel>(context,listen: false);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  buildTextField(
                      controller: VM_Login.emailController,
                      label: "Email",
                      pass: false,
                      validator: VM_Login.validateEmail),
                  SizedBox(height: 15),
                  buildTextField(
                      controller: VM_Login.passwordController,
                      label: "Password",
                      pass: true,
                      validator:VM_Login.validatePassword),
                  SizedBox(height: 20),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => {context.push('/Register')},
                  child: Text(
                    "Chưa có tài khoản?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB02700),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(200, 30),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required bool pass,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: hidePassword,
      validator: validator,
      decoration: InputDecoration(
        label: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon:
        pass
            ? IconButton(
          icon: Icon(
            hidePassword
                ? Icons.visibility_off_rounded
                : Icons.visibility,
            color: Colors.black87,
            size: 22,
          ),
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }
}
