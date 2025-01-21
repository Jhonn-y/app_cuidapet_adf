import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projeto_cuidapet/app/core/ui/ui_config.dart';

class AppWigdet extends StatelessWidget {
  const AppWigdet({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/home/');
    Modular.setObservers([Asuka.asukaHeroController]);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp.router(
        title: UiConfig.title,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Asuka.builder(context, child);
        },
        theme: UiConfig.theme,
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
      ),
    );
  }
}
