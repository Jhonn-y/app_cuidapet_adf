
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

class CryptHelper {

  CryptHelper._();

  static String generateSHA256Hash(String password){
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}