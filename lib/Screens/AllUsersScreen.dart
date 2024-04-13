import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:my_skenu/Core/Util/MyColors.dart';
import 'package:my_skenu/Screens/ChatScreen.dart';
import 'package:provider/provider.dart';

import '../Provider/UserProvider.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => AllUsersScreen(),
      );

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {

  String createChatroomId(String id1, String id2) {
    if(id1[0].toLowerCase().codeUnits[0] > id2[0].toLowerCase().codeUnits[0]){
      return '$id1$id2';
    }
    return '$id2$id1';
  }

  @override
  Widget build(BuildContext context) {
    UserModel _model = Provider.of<UserProvider>(context).getModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.darkyellow,
        title: Text('All Users',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              var list = snapshot.data!.docs;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  UserModel tempModel = UserModel.fromJson(list[index].data());
                  return _model.uid == tempModel.uid
                      ? Container()
                      : ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              ChatScreen.route(
                                chatUserModel: tempModel,
                                chatroomId: createChatroomId(
                                  tempModel.uid,
                                  _model.uid,
                                ),
                              ),
                            );
                          },
                          leading: Container(
                            height: 40,
                            width: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                tempModel.photoUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            tempModel.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                },
              );
            } else {
              return Text("No data found");
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Text('Some error ${snapshot.error}'),
          );
        },
      ),
    );
  }
}
