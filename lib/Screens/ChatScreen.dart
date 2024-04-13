import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_skenu/Core/Util/Models/MessageModel.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.chatUserModel, required this.chatroomId});

  final UserModel chatUserModel;
  final String chatroomId;

  static route(
          {required UserModel chatUserModel, required String chatroomId}) =>
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatUserModel: chatUserModel,
          chatroomId: chatroomId,
        ),
      );

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUserModel.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(widget.chatroomId)
                  .collection('chats')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    var list = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        MessageModel tempModel =
                            MessageModel.fromJson(list[index].data());
                        return Container(
                          child: Text(tempModel.message),
                        );
                      },
                    );
                  } else {
                    return Text("No data found");
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Center(
                  child: Text('Some error ${snapshot.error}'),
                );
              },
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type message......',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
