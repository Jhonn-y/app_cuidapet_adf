import 'dart:math';

import 'package:injectable/injectable.dart';


@Singleton()
class RandomSingletonModel {
  int id;
  String name;

  RandomSingletonModel()
      : id = Random().nextInt(1000),
        name = "Random Singleton Model";
}
