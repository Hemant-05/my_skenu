import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Screens/AllUsersScreen.dart';
import 'package:my_skenu/Widgets/PostWidget.dart';
import '../Core/Constant/StringConstant.dart';
import 'AddPostScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              AddPostScreen.route(),
            );
          },
          icon: const Icon(
            Icons.add_circle_outline,
          ),
        ),
        centerTitle: true,
        title: Container(
          height: 30,
          width: 50,
          child: Image.asset(
            icon,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AllUsersScreen.route());
            },
            icon: const Icon(
              Icons.send_rounded,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              if(data!.docs.isEmpty){
                return const Center(child: Text('No post yet !!'),);
              }
              return ListView.builder(
                itemCount: data!.docs.length,
                itemBuilder: (context, index) {
                  return PostWidget(
                    snapshot: data.docs[index].data(),
                  );
                },
              );
            } else {
              return const Text('Error while loading posts');
            }
          }
          return Text(snapshot.error.toString());
        },
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
      ),
    );
  }
}
