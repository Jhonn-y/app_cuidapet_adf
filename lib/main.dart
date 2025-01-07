import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/app_module.dart';
import 'package:projeto_cuidapet/app/app_wigdet.dart';

void main() {
  runApp(ModularApp(
    module: AppModule(),
    child: AppWigdet(),
  ));
}
