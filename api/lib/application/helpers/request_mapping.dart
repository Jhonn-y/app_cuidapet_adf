import 'dart:convert';

abstract class RequestMapping {

  final Map<String, dynamic> data;

  RequestMapping.enpty() : data = {};

  RequestMapping(String data) : data = jsonDecode(data){
    map();
  }

  void map();

}