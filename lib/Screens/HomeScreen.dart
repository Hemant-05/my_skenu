import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Core/Util/UserModel.dart';
import 'package:my_skenu/Screens/UserProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel model;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Skenu'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  UserProfileScreen.route(
                    isMe: true,
                    model: model,
                  ),
                );
              },
              icon: const Icon(
                Icons.person,
              ),
            ),
          ],
        ),
        body: Container(
            alignment: Alignment.center,
            child: StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data?.docs[index];
                      if (data?['uid'] == model.uid) {
                        return Container();
                      }
                      return ListTile(
                        onTap: () {
                          UserModel userModel = UserModel(
                            email: data?['email'],
                            name: data?['name'],
                            uid: data?['uid'],
                            follower: data?['follower'],
                            following: data?['following'],
                            post: data?['post'],
                          );
                          Navigator.push(
                            context,
                            UserProfileScreen.route(
                              isMe: false,
                              model: userModel,
                            ),
                          );
                        },
                        title: Text('${data?['name']}'),
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      size: 200,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Error',
                    ),
                  );
                }
              },
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
            )),
      ),
    );
  }
}
