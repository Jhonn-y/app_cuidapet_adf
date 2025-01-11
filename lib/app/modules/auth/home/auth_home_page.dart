// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'package:projeto_cuidapet/app/core/ui/extensions/size_screen_extension.dart';
import 'package:projeto_cuidapet/app/model/user_model.dart';
import 'package:projeto_cuidapet/app/modules/core_module/auth/auth_store.dart';

class AuthHomePage extends StatefulWidget {
  AuthStore _authStore;
  AuthHomePage({
    super.key,
    required AuthStore authStore,
  }) : _authStore = authStore;

  @override
  State<AuthHomePage> createState() => _AuthHomePageState();
}

class _AuthHomePageState extends State<AuthHomePage> {
  @override
  void initState() {
    super.initState();

    reaction<UserModel?>((_) => widget._authStore.userModel, (userLogger) {
      if (userLogger != null && userLogger.email.isNotEmpty) {
        Modular.to.pushNamed('/home');
      } else {
        Modular.to.navigate('/auth/login/');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget._authStore.loadUserLogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: 130.h,
          width: 162.w,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
