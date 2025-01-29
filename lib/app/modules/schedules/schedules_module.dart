import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/modules/schedules/schedules_page.dart';

class SchedulesModule extends Module {

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (_) => SchedulesPage());
  }
}