class DatabaseConnectionConfiguration {
  final String databaseName;
  final String host;
  final int port;
  final String user;
  final String password;

  DatabaseConnectionConfiguration(
      {required this.databaseName,
      required this.host,
      required this.port,
      required this.user,
      required this.password});
}
