import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hello/model/chat_model.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/services/auth_services.dart';
import 'package:hello/services/firestore_service.dart';
import 'package:hello/services/local_notification.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  TextEditingController msgController = TextEditingController();
  TextEditingController editMsgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserModel user = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40.w,
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              // radius: 50.w,
              backgroundImage: NetworkImage(user.image),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(user.name),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirestoreService.firestoreService.fetchChats(
                    sender: AuthService.authService.currentUser!.email ?? "",
                    receiver: user.email),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data;
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> allData =
                        data!.docs;
                    List<ChatModel> allChats = allData
                        .map((e) => ChatModel.fromMap(data: e.data()))
                        .toList();
                    return (allChats.isNotEmpty)
                        ? ListView.builder(
                            itemCount: allChats.length,
                            itemBuilder: (context, index) {
                              DateTime time = allChats[index].time.toDate();
                              return (allChats[index].receiver == user.email)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                          GestureDetector(
                                            onLongPress: () {},
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8, top: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.blue.shade100),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 8),
                                              child: Flexible(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      allChats[index].msg,
                                                    ),
                                                    Transform.translate(
                                                      offset:
                                                          const Offset(4, 4),
                                                      child: Text(
                                                        '${time.hour}:${time.minute} ${time.hour < 12 ? 'AM' : 'PM'}',
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 7.w,
                                                    ),
                                                    Icon(
                                                      color: (allChats[index]
                                                                  .sender ==
                                                              AuthService
                                                                  .authService
                                                                  .currentUser
                                                                  ?.email)
                                                          ? Colors.green
                                                          : Colors.red,
                                                      Icons.done_all,
                                                      size: 20.h,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ])
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 8, top: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey.shade300),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 8),
                                            child: Flexible(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    allChats[index].msg,
                                                  ),
                                                  Transform.translate(
                                                    offset: const Offset(4, 4),
                                                    child: Text(
                                                      '${time.hour}:${time.minute} ${time.hour < 12 ? 'AM' : 'PM'}',
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 7.w,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]);
                            },
                          )
                        : const Center(
                            child: Text('Empty'),
                          );
                  }
                  return Container();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value) async {
                      value.isNotEmpty
                          ? await LocalNotificationService
                              .localNotificationService
                              .showSimpleNotification(
                                  title: user.name, body: value)
                          : null;
                      msgController.clear();
                    },
                    controller: msgController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                GestureDetector(
                    onLongPress: () async {
                      if (msgController.text.isNotEmpty) {
                        await showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) {
                          if (value != null) {
                            LocalNotificationService.localNotificationService
                                .showSchedulingNotification(
                              title: user.name,
                              body: msgController.text,
                              timeDate: DateTime(value.hour, value.minute),
                            );
                          }
                        });
                      }
                    },
                    onDoubleTap: () async {
                      msgController.text.isNotEmpty
                          ? await LocalNotificationService
                              .localNotificationService
                              .showSchedulingNotification(
                              title: user.name,
                              body: msgController.text,
                              timeDate: DateTime.now().add(
                                const Duration(seconds: 5),
                              ),
                            )
                          : null;
                    },
                    onHorizontalDragStart: (details) {
                      if (msgController.text.isNotEmpty) {
                        LocalNotificationService.localNotificationService
                            .showBigPictureNotification(
                                title: user.name,
                                body: msgController.text,
                                url: user.image);
                      }
                    },
                    onTap: () async {
                      String msg = msgController.text;
                      String email =
                          AuthService.authService.currentUser?.email ?? '';
                      if (msg.isNotEmpty) {
                        FirestoreService.firestoreService.sendChat(
                            chatModel: ChatModel(
                                sender: email,
                                receiver: user.email,
                                msg: msg,
                                time: Timestamp.now()));
                        await LocalNotificationService.localNotificationService
                            .showSimpleNotification(
                                title: user.name, body: msg);
                        msgController.clear();
                      }
                    },
                    child: const Icon(
                      Icons.send_rounded,
                      size: 40,
                      color: Colors.blue,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
