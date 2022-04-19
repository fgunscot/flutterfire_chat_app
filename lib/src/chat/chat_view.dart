import 'package:flutter/material.dart';
import 'package:lab1_provider_messager/src/messager/messager_controller.dart';
import 'package:lab1_provider_messager/src/messager/messager_service.dart';
import 'package:provider/provider.dart';

class MessageView extends StatelessWidget {
  const MessageView({
    Key? key,
    required this.model,
  }) : super(key: key);
  final MessageModel model;

  @override
  Widget build(BuildContext context) {
    var _rad = const Radius.circular(16.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment:
            model.isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: model.isMe! ? Colors.deepPurple[300] : Colors.grey[500],
              borderRadius: model.isMe!
                  ? BorderRadius.only(
                      topLeft: _rad, topRight: _rad, bottomLeft: _rad)
                  : BorderRadius.only(
                      topLeft: _rad, topRight: _rad, bottomRight: _rad),
            ),
            constraints: const BoxConstraints(maxWidth: 380),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
            child: Text(
              model.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              '12:39 PM',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  static const routeName = '/chat';
  const ChatView({Key? key, required this.chatId}) : super(key: key);
  final String chatId;

  @override
  Widget build(BuildContext context) {
    final _inputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Consumer<MessagerController>(builder: (_, controller, __) {
                var chat = controller.getChat(chatId);
                return chat.messages.isNotEmpty
                    ? ListView.builder(
                        reverse: true,
                        itemCount: chat.messages.length,
                        itemBuilder: (context, index) {
                          return MessageView(model: chat.messages[index]);
                        },
                      )
                    : const CircularProgressIndicator();
              }),
            ),
          ),
          const Divider(height: 2, thickness: 2),
          SizedBox(
            height: 60.0,
            width: double.maxFinite,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _inputController,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<MessagerController>(context, listen: false)
                        .sendMessage(chatId, _inputController.text);
                    _inputController.clear();
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
