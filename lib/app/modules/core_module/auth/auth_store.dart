import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/model/user_model.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  @readonly
  UserModel? _userModel;

  @action
  Future<void> loadUserLogged() async {
      _userModel = UserModel.empty();

  }
}
