import 'package:flutter_modular/flutter_modular.dart';

mixin ControllerLifeCycle implements Disposable {
  onInit([Map<String, dynamic>? params]) {}

  onReady() {}

  @override
  void dispose() {
    // Implement any necessary cleanup code here
  }
}
