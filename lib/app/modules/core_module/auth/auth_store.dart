import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_cuidapet/app/core/helpers/constants.dart';
import 'package:projeto_cuidapet/app/core/local_storage/local_storage.dart';
import 'package:projeto_cuidapet/app/model/user_model.dart';
import 'package:projeto_cuidapet/app/services/address/address_service.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final LocalStorage _localStorage;
  final LocalSecureStorage _secureStorage;
  final AddressService _addressService;

  @readonly
  UserModel? _userModel;

  _AuthStoreBase(
      {required LocalSecureStorage secureStorage,
      required LocalStorage localStorage,
      required AddressService addressService})
      : _localStorage = localStorage,
        _addressService = addressService,
        _secureStorage = secureStorage;

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
    await _secureStorage.clear();
    await _addressService.deleteAll();
    _userModel = UserModel.empty();
  }
}
