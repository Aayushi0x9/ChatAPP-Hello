import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello/model/chat_model.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/services/auth_services.dart';

class FirestoreService {
  static FirestoreService firestoreService = FirestoreService._();
  FirestoreService._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String userCollection = 'Users';
  String chatCollection = 'ChatRooms';

  Future<void> addUser({
    required UserModel user,
  }) async {
    await fireStore.collection(userCollection).doc(user.email).set(user.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUSer() {
    String email = AuthService.authService.currentUser?.email ?? "";
    return fireStore
        .collection(userCollection)
        .where("email", isNotEqualTo: email)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchSingleUser() async {
    String email = AuthService.authService.currentUser?.email ?? "";
    return await fireStore.collection(userCollection).doc(email).get();
  }

  //doc id
  String arrangeDocID({required String sender, required String receiver}) {
    List users = [sender, receiver];
    users.sort();
    return users.join('_');
  }

//Chat methods
  void sendChat({required ChatModel chatModel}) {
    String docID =
        arrangeDocID(sender: chatModel.sender, receiver: chatModel.receiver);

    fireStore
        .collection(chatCollection)
        .doc(docID)
        .collection('Chats')
        .add(chatModel.toMap);
  }

  //fetch chats
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchChats(
      {required String sender, required String receiver}) {
    String docID = arrangeDocID(sender: sender, receiver: receiver);
    return fireStore
        .collection(chatCollection)
        .doc(docID)
        .collection('Chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  //delete chat
  void deleteChat(
      {required String sender, required String receiver, required String id}) {
    String docID = arrangeDocID(sender: sender, receiver: receiver);
    fireStore
        .collection(chatCollection)
        .doc(docID)
        .collection("Chats")
        .doc(id)
        .delete();
  }

//update chat
  void updateChat(
      {required String sender,
      required String receiver,
      required String id,
      required String msg}) {
    String docID = arrangeDocID(sender: sender, receiver: receiver);
    fireStore
        .collection(chatCollection)
        .doc(docID)
        .collection("Chats")
        .doc(id)
        .update({
      'msg': msg,
    });
  }
}
