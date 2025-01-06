import 'package:injectable/injectable.dart';

import './i_chat_repo.dart';

@LazySingleton(as: IChatRepo)
class ChatRepo implements IChatRepo {

}