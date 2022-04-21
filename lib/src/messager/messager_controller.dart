import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lab1_provider_messager/src/messager/messager_service.dart';
import 'package:lab1_provider_messager/src/utils/string_extension.dart';

class MessagerController with ChangeNotifier {
  MessagerController() {
    service = MessagerService(controller: this);
  }
  late MessagerService service;

  UserModel? _userModel;
  UserModel? getUserModel() => _userModel;
  setUserModel(UserModel model) {
    _userModel = model;
    notifyListeners();
  }

  String getUserModelChatName(String id) =>
      _userModel!.chatIds[id].toString().capitalize();

  Map<String, UserModel> _users = {};
  Map<String, UserModel> get getUsers => _users;
  setUsers(Map<String, UserModel> models) {
    _users = models;
    notifyListeners();
  }

  Future<String> startChat(String id) async => await service.startChat(id);
  Map<String, ChatModel> _chats = {};
  Map<String, ChatModel> get getChats => _chats;
  setChats(Map<String, ChatModel> models) {
    _chats = models;
    notifyListeners();
  }

  setChat(String id, List<MessageModel> messages) {
    _chats[id]!.messages = messages;
    notifyListeners();
  }

  ChatModel? getChat(String id) {
    return _chats.containsKey(id) ? _chats[id] : null;
  }

  List<MessageModel> getChatMessages(String id) => _chats[id]!.messages;

  void sendMessage(String id, String message) => service.sendMessage(
      id,
      MessageModel(
          message: message,
          senderId: service.myUserId,
          postedAt: Timestamp.now()));
}
