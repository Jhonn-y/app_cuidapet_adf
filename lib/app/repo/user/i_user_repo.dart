abstract class IUserRepo {
  Future<void> register(String email, String password);
  Future<String> login(String email, String password);
}
