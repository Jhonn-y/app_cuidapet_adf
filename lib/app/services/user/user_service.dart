import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_cuidapet/app/core/exceptions/failure.dart';
import 'package:projeto_cuidapet/app/core/exceptions/user_exists_exception.dart';
import 'package:projeto_cuidapet/app/core/logger/app_logger.dart';
import 'package:projeto_cuidapet/app/repo/user/i_user_repo.dart';

import './i_user_service.dart';

class UserService implements IUserService {
  final IUserRepo _userRepo;
  final AppLogger _log;

  UserService({required AppLogger log, required IUserRepo userRepo})
      : _userRepo = userRepo,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      final userMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (userMethods.isNotEmpty) {
        throw UserExistsException();
      }

      await _userRepo.register(email, password);
      final userRegisterCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userRegisterCredential.user?.sendEmailVerification();
    } on FirebaseException catch (e) {
      _log.error('Erro ao criar usuario no firebase', e);
      throw Failure(message: 'Erro ao criar usuario no firebase');
    }
  }
}
