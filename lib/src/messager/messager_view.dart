import 'package:flutter/material.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_view.dart';
import 'package:lab1_provider_messager/src/chat/chat_view.dart';
import 'package:lab1_provider_messager/src/messager/messager_controller.dart';
import 'package:lab1_provider_messager/src/utils/color_utils.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.chatName,
    required this.id,
  }) : super(key: key);
  final String chatName;
  final String id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('chatTileIndex$id'),
      leading: CircleAvatar(
        backgroundColor: getRandomColor(),
        radius: 20,
        child: Text(
          chatName[0].toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(chatName),
      onTap: () => Navigator.restorablePushNamed(
        context,
        ChatView.routeName,
        arguments: id,
      ),
    );
  }
}

class MessagerView extends StatelessWidget {
  static const routeName = '/messager';
  const MessagerView({Key? key}) : super(key: key);

  static const navToAuthIconButtonKey = Key('navToAuthIconButton');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messager'),
        actions: [
          IconButton(
            key: MessagerView.navToAuthIconButtonKey,
            icon: const Icon(Icons.login_outlined),
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, AuthenticationView.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer<MessagerController>(builder: (_, controller, __) {
            var users = controller.getUsers;
            return SizedBox(
              height: 70,
              child: users.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var id = users.keys.toList()[index];
                        return Row(
                          children: [
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                var ref = await controller.startChat(id);
                                Navigator.restorablePushNamed(
                                  context,
                                  ChatView.routeName,
                                  arguments: ref,
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: getRandomColor(),
                                radius: 20,
                                child: Text(
                                  users[id]!.displayName![0].toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                  : const Center(
                      child: Text('Nobody to chat too, tried login in?')),
            );
          }),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Consumer<MessagerController>(
                    builder: (_, controller, __) {
                      return (controller.getChats.isNotEmpty &&
                              controller.getUserModel()!.chatIds.isNotEmpty)
                          ? ListView.builder(
                              itemCount: controller.getChats.length,
                              itemBuilder: (context, index) {
                                var id =
                                    controller.getChats.keys.toList()[index];
                                return ChatTile(
                                    chatName:
                                        controller.getUserModelChatName(id),
                                    id: id);
                              },
                            )
                          : const Center(
                              child:
                                  Text('You dont have anyone to chat with.'));
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
