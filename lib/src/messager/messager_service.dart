import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab1_provider_messager/src/messager/messager_controller.dart';

class MessagerService {
  MessagerService({required this.controller}) {
    init();
  }
  late MessagerController controller;
  late String myUserId;

  Map<String, ChatModel> _chats = {};

  final _usersCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  userDocumentRef(String id) =>
      FirebaseFirestore.instance.doc('users/$id').withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (movie, _) => movie.toJson(),
          );

  final _chatsCollectionRef = FirebaseFirestore.instance
      .collection('chats')
      .withConverter<ChatModel>(
        fromFirestore: (snapshot, _) => ChatModel.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  messagesCollectionRef(String id) => FirebaseFirestore.instance
      .collection('chats/$id/messages')
      .withConverter<MessageModel>(
        fromFirestore: (snapshot, _) => MessageModel.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  void init() {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        myUserId = user.uid;
        if (await checkExist(user.uid)) {
          userDocumentRef(user.uid).snapshots().listen((user) {
            controller.setUserModel(user.data());
            chatsListener();
          });
        } else {
          addUser(user);
        }
      }
    });
  }

  void chatsListener() {
    List<String> filters = [];

    var chatIds = controller.getUserModel()!.chatIds.keys.toList();
    if (chatIds.isNotEmpty) {
      _chatsCollectionRef
          .where(FieldPath.documentId, whereIn: chatIds)
          .snapshots()
          .listen((chats) {
        for (var doc in chats.docs) {
          var data = doc.data();
          _chats[doc.id] = data;
          messagesListener(doc.id);
          filters.add(data.userIds.where((elem) => elem != myUserId).first);
        }
        controller.setChats(_chats);
        usersListener(filters);
      });
    } else {
      usersListener(filters);
    }
  }

  void messagesListener(String id) {
    messagesCollectionRef(id).snapshots().listen((col) {
      for (var doc in col.docs) {
        var data = doc.data();
        _chats[id]!.messages.add(data);
        _chats[id]!.messages.last.updateIsMe(myUserId);
      }
    });
  }

  void usersListener(List<String> filters) {
    filters.add(myUserId);
    _usersCollectionRef
        .where(FieldPath.documentId, whereNotIn: filters)
        .snapshots()
        .listen((users) {
      Map<String, UserModel> col = {};
      for (var doc in users.docs) {
        col[doc.id] = doc.data();
      }
      controller.setUsers(col);
    });
  }

  void startChat(String id) async {
    var ref = await _chatsCollectionRef.add(ChatModel(userIds: [myUserId, id]));
    var chatId = ref.id;
    _usersCollectionRef
        .doc(myUserId)
        .update({'chat_ids.$chatId': getOthersDisplayName(id)});
    _usersCollectionRef
        .doc(id)
        .update({'chat_ids.$chatId': controller.getUserModel()!.displayName});
  }

  void sendMessage(String id, MessageModel model) {
    messagesCollectionRef(id).add(model);
  }

  String? getOthersDisplayName(String id) {
    return controller.getUsers()[id]!.displayName;
  }

  void addUser(User user) {
    _usersCollectionRef.doc(user.uid).set(UserModel(
          displayName: user.displayName,
          chatIds: {},
        ));
  }

  Future<bool> checkExist(String id) async {
    try {
      var doc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}

class UserModel {
  UserModel({
    required this.displayName,
    required this.chatIds,
  });
  String? displayName;
  Map<String, dynamic> chatIds;

  UserModel.fromJson(Map<String, dynamic> json)
      : displayName = json['name']! as String,
        chatIds = json['chat_ids']! as Map<String, dynamic>;

  Map<String, dynamic> toJson() => {
        'name': displayName,
        'chat_ids': chatIds,
      };
}

class ChatModel {
  ChatModel({required this.userIds});
  String? name;
  List<dynamic> userIds;
  List<MessageModel> messages = [];

  ChatModel.fromJson(Map<String, dynamic> json)
      : userIds = json['user_ids'] as List<dynamic>;

  Map<String, dynamic> toJson() => {
        'user_ids': userIds,
      };
}

class MessageModel {
  MessageModel({required this.message, required this.senderId});
  String message;
  String senderId;
  bool? isMe;

  MessageModel.fromJson(Map<String, dynamic> json)
      : message = json['message']! as String,
        senderId = json['sender_id']! as String;

  Map<String, dynamic> toJson() => {
        'message': message,
        'sender_id': senderId,
      };

  updateIsMe(userId) => senderId == userId ? isMe = true : isMe = false;
}
