import 'package:flutter/foundation.dart';
import 'package:lab1_provider_messager/src/messager/messager_service.dart';

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

  Map<String, UserModel> _users = {};
  Map<String, UserModel> getUsers() => _users;
  setUsers(Map<String, UserModel> models) {
    _users = models;
    notifyListeners();
  }

  startChat(String id) => service.startChat(id);
  Map<String, ChatModel> _chats = {};
  Map<String, ChatModel> getChats() => _chats;
  setChats(Map<String, ChatModel> models) {
    _chats = models;
    notifyListeners();
  }

  ChatModel getChat(String id) => _chats[id]!;

  void sendMessage(String id, String message) => service.sendMessage(
      id, MessageModel(message: message, senderId: service.myUserId));
}
