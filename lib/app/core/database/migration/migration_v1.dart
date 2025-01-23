import 'package:projeto_cuidapet/app/core/database/migration/migration.dart';
import 'package:sqflite/sqflite.dart';


class MigrationV1 extends Migration {
  @override
  void create(Batch batch) {
    batch.execute('''CREATE TABLE address (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        address TEXT NOT NULL,
        lat TEXT,
        lng TEXT,
        aditional TEXT
      )''');
  }

  @override
  void update(Batch batch) {
    // TODO: implement update
  }
}
