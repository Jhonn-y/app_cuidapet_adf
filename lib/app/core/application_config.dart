import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/helpers/environments.dart';
import 'package:projeto_cuidapet/firebase_options.dart';

class ApplicationConfig {
  Future<void> configureApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _firebaseCoreConfigure();
    await _loadEnvs();
  }

  _firebaseCoreConfigure() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> _loadEnvs() => Environments.loadEnv();
}
