import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soltalk/data/db/entity/app_user.dart';
import 'package:soltalk/data/model/chat_with_user.dart';
import 'package:soltalk/data/provider/user_provider.dart';
import 'package:soltalk/ui/screens/chat_screen.dart';
import 'package:soltalk/ui/widgets/chats_list.dart';
import 'package:soltalk/ui/widgets/custom_modal_progress_hud.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  void chatWithUserPressed(ChatWithUser chatWithUser) async {
    AppUser? user = await Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      return;
    }

    if (context.mounted) {
      Navigator.pushNamed(context, ChatScreen.id,
          arguments: {"chat_id": chatWithUser.chat.id, "user_id": user.id, "other_user_id": chatWithUser.user.id});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return FutureBuilder<AppUser?>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  offset: null,
                  child: (userSnapshot.hasData)
                      ? FutureBuilder<List<ChatWithUser>>(
                          future: userProvider.getChatsWithUser(userSnapshot.data!.id),
                          builder: (context, chatWithUsersSnapshot) {
                            if (chatWithUsersSnapshot.data == null && chatWithUsersSnapshot.connectionState != ConnectionState.done) {
                              return CustomModalProgressHUD(inAsyncCall: true, offset: null, child: Container());
                            } else {
                              return chatWithUsersSnapshot.data!.isEmpty
                                  ? Center(
                                      child: Text('No matches', style: Theme.of(context).textTheme.headlineMedium),
                                    )
                                  : ChatsList(
                                      chatWithUserList: chatWithUsersSnapshot.data!,
                                      onChatWithUserTap: chatWithUserPressed,
                                      myUserId: userSnapshot.data!.id,
                                    );
                            }
                          })
                      : Container(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
