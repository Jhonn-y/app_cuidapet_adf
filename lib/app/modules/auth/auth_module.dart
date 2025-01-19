import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_cuidapet/app/model/social_network_model.dart';
import 'package:projeto_cuidapet/app/modules/auth/home/auth_home_page.dart';
import 'package:projeto_cuidapet/app/modules/auth/login/login_module.dart';
import 'package:projeto_cuidapet/app/modules/auth/register/register_module.dart';
import 'package:projeto_cuidapet/app/modules/core_module/auth/auth_store.dart';
import 'package:projeto_cuidapet/app/modules/core_module/core_module.dart';
import 'package:projeto_cuidapet/app/repo/social/i_social_repo.dart';
import 'package:projeto_cuidapet/app/repo/social/social_repo.dart';
import 'package:projeto_cuidapet/app/repo/user/i_user_repo.dart';
import 'package:projeto_cuidapet/app/repo/user/user_repo.dart';
import 'package:projeto_cuidapet/app/services/user/i_user_service.dart';
import 'package:projeto_cuidapet/app/services/user/user_service.dart';

class AuthModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton<ISocialRepo>(SocialRepo.new);
    i.addLazySingleton<IUserRepo>(UserRepo.new);
    i.addLazySingleton<IUserService>(UserService.new);
  }

  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute,
        child: (_) => AuthHomePage(
              authStore: Modular.get<AuthStore>(),
            ));
    r.module('/login/', module: LoginModule());
    r.module('/register/', module: RegisterModule());
  }
}
