// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/exeptions/user_not_found_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/user/service/user_service.dart';
import 'package:cuidapet_api/modules/user/view_models/update_url_avatar_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_update_device_token_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_controller.g.dart';

@injectable
class UserController {
  UserService userService;
  ILogger log;
  UserController({
    required this.userService,
    required this.log,
  });

  @Route.get('/')
  Future<Response> findByToken(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final userData = await userService.findByID(user);

      return Response.ok(jsonEncode({
        'email': userData.email,
        'register_type': userData.registerType,
        'img_avatar': userData.imageAvatar
      }));
    } on UserNotFoundException {
      return Response(204);
    } catch (e) {
      log.error("erro ao buscar usuario", e);
      return Response.internalServerError();
    }
  }

  @Route.put('/avatar')
  Future<Response> updateAvatar(Request request) async {
    try {
      final userID = int.parse(request.headers['user']!);
      final updateUrlAvatar = UpdateUrlAvatarModel(
          userID: userID, dataRequest: await request.readAsString());

      final user = await userService.updateAvatar(updateUrlAvatar);

      return Response.ok(jsonEncode({
        'email': user.email,
        'register_type': user.registerType,
        'img_avatar': user.imageAvatar
      }));
    } catch (e) {
      log.error("Erro ao atualizar avatar", e);
      return Response.internalServerError();
    }
  }

  @Route.put('/device')
  Future<Response> updateDeviceToken(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final updateDeviceToken = UserUpdateDeviceTokenModel(
          userID: user, dataRequest: await request.readAsString());

      await userService.updateDeviceToken(updateDeviceToken);
      return Response.ok(jsonEncode({}));
    } catch (e) {
      log.error("Erro ao atualizar device token", e);
      return Response.internalServerError();
    }
  }

  Router get router => _$UserControllerRouter(this);
}
