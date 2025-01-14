import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/app_module.dart';
import 'package:projeto_cuidapet/app/app_wigdet.dart';
import 'package:projeto_cuidapet/app/core/application_config.dart';


Future<void> main() async {
  await ApplicationConfig().configureApp();
  runApp(ModularApp(
    module: AppModule(),
    child: AppWigdet(),
  ));
}
