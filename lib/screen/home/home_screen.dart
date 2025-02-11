import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello/controller/home_controller.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/routes/app_routes.dart';
import 'package:hello/services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());

  // @override
  // void initState() {
  //   super.initState();
  //   controller.getCurentUser();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            FutureBuilder(
              future: FirestoreService.firestoreService.fetchSingleUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  log('error : ===>${snapshot.error}');
                  return Center(
                    child: Text("Error : ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
                  UserModel user = UserModel.fromMap(data: data?.data() ?? {});
                  return UserAccountsDrawerHeader(
                    accountName: Text('${user.name}'),
                    accountEmail: Text('${user.email}'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(user.image ?? ''),
                    ),
                  );
                }
                return Container();
              },
            ),
            ListTile(
              onTap: () {
                controller.signOut();
                Get.toNamed(Routes.login);
              },
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HomePage'),
      ),
      body: StreamBuilder(
        stream: FirestoreService.firestoreService.fetchUSer(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
            List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                data?.docs ?? [];

            List<UserModel> users = allDocs
                .map(
                  (e) => UserModel.fromMap(data: e.data()),
                )
                .toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = users[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Get.toNamed(Routes.chatScreen, arguments: user);
                    },
                    leading: CircleAvatar(
                      foregroundImage: NetworkImage('${user.image}'),
                    ),
                    title: Text('${user.name}'),
                    subtitle: Text('${user.email}'),
                  ),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
