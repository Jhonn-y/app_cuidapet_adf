import 'package:projeto_cuidapet/app/core/database/migration/migration.dart';
import 'package:projeto_cuidapet/app/core/database/migration/migration_v1.dart';

class SqliteMigrationFactory {
  List<Migration> getCreatedMigrations() => [
        MigrationV1(),
      ];

  List<Migration> getUpdatedMigrations(int version) {
    return [];
  }
}
