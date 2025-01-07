import 'dart:convert';

import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@LazySingleton()
class PushNotificationFacade {
  final ILogger log;
  final dotenv = DotEnv(includePlatformEnvironment: true);

  PushNotificationFacade({
    required this.log,
  });

  Future<void> sendMessage(
      {required List<String?> devices,
      required String title,
      required String body,
      required Map<String, dynamic> payload}) async {
    try {
      final request = {
        'notification': {
          'body': body,
          'title': title,
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'payload': payload,
        }
      };
      final firebaseKey =
          dotenv['FIREBASE_PUSH_KEY'] ?? dotenv['firebasePushKey'];

      if (firebaseKey == null) {
        return;
      }
      for (var device in devices) {
        if (device != null) {
          request['to'] = device;
          log.info('enviando mensagem para: $device');
          final result = await http.post(
            Uri.parse(
                'https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send'),
            body: jsonEncode(request),
            headers: {
              'Authorization': 'key=$firebaseKey',
              'Content-Type': 'application/json',
            },
          );

          final responseData = jsonDecode(result.body);

          if (responseData['failure'] == 1) {
            log.error(
                'Falha ao enviar notificação para o dispositivo: $device erro: ${responseData['results']?[0]}');
          } else {
            log.info('Notificação enviada para o dispositivo: $device');
          }
        }
      }
    } catch (e) {
      log.error('Erro ao enviar notificação: $e');
    }
  }
}
