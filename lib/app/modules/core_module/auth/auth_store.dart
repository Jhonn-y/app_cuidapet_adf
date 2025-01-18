import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/helpers/constants.dart';
import 'package:projeto_cuidapet/app/core/local_storage/local_storage.dart';
import 'package:projeto_cuidapet/app/model/user_model.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final LocalStorage _localStorage;
  @readonly
  UserModel? _userModel;

  _AuthStoreBase({required LocalStorage localStorage})
      : _localStorage = localStorage;

  @action
  Future<void> loadUserLogged() async {
    final userModelJson = await _localStorage
        .read<String>(Constants.LOCAL_STORAGE_USER_LOGGED_DATA_KEY);

    if (userModelJson != null) {
      _userModel = UserModel.fromJson(userModelJson);
    } else {
      _userModel = UserModel.empty();
    }

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        await logOut();
      }
    });
  }

  @action
  Future<void> logOut() async {
    await _localStorage.clear();
    _userModel = UserModel.empty();
  }
}
