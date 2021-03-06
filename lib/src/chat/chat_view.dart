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
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '${model.postedAt.toDate().hour}:${model.postedAt.toDate().minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  static const routeName = '/chat';
  const ChatView({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    final _inputController = TextEditingController();

    return Consumer<MessagerController>(
      builder: (_, controller, __) {
        return Scaffold(
          appBar: AppBar(title: Text(controller.getUserModelChatName(id))),
          body: controller.getChat(id) != null
              ? Column(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: controller.getChatMessages(id).isNotEmpty
                              ? ListView.builder(
                                  reverse: true,
                                  itemCount:
                                      controller.getChatMessages(id).length,
                                  itemBuilder: (context, index) {
                                    return MessageView(
                                        model: controller
                                            .getChatMessages(id)[index]);
                                  },
                                )
                              : const Center(
                                  child:
                                      Text('Send a message to start chat.'))),
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
                              controller.sendMessage(id, _inputController.text);
                              _inputController.clear();
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : const CircularProgressIndicator(),
        );
      },
    );
  }
}
