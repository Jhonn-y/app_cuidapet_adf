abstract class IUserRepo {
  Future<void> register(String email, String password);
}
