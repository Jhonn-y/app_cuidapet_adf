import 'package:cuidapet_api/application/database/i_database_conn.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_database_exception.dart';
import 'mock_mysql_connection.dart';
import 'mock_results.dart';

class MockDatabaseConnection extends Mock implements IDatabaseConn {
  final mySqlConnection = MockMysqlConnection();

  MockDatabaseConnection() {
    when(() => openConnection()).thenAnswer((_) async => mySqlConnection);
  }

  void mockQuery(MockResults mockResults, [List<Object>? params]) {
    when(() => mySqlConnection.query(any(), any()))
        .thenAnswer((_) async => mockResults);
  }

  void mockQueryException(
      {MockDatabaseException? mockException, List<Object>? params}) {
    var exception = mockException;

    if (exception == null) {
      exception = MockDatabaseException();
      when(() => exception!.message).thenReturn('Erro mysql generico');
    }

    when(() => mySqlConnection.query(any(), params ?? any()))
        .thenThrow(exception);
  }

  void verifyQueryCalled({int? called, List<Object>? params}) =>
      verify(() => mySqlConnection.query(any(), params ?? any()))
          .called(called ?? 1);


  void verifyQueryNeverCalled({List<Object>? params}) =>
      verifyNever(() => mySqlConnection.query(any(), params ?? any()));
}
