import 'package:soltalk/data/db/entity/app_user.dart';
import 'package:soltalk/data/db/entity/chat.dart';

class ChatWithUser {
  Chat chat;
  AppUser user;

  ChatWithUser(this.chat, this.user);
}
