import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/size_screen_extension.dart';


class AuthHomePage extends StatelessWidget {
  const AuthHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png',
        height: 130.h,
        width: 162.w,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        color: Colors.white,),
      ),
    );
  }
}
