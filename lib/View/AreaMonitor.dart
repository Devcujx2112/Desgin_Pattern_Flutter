import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AreaMontitor extends StatefulWidget {
  const AreaMontitor({super.key});

  @override
  State<AreaMontitor> createState() => _AreaMontitorState();
}

class _AreaMontitorState extends State<AreaMontitor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Terrorism"),
        automaticallyImplyLeading: false,
      ),
    );
  }
}
