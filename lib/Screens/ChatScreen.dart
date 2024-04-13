import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_skenu/Auth/FirestoreMethods.dart';
import 'package:my_skenu/Core/Util/Models/MessageModel.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:my_skenu/Core/Util/MyColors.dart';
import 'package:my_skenu/Provider/UserProvider.dart';
import 'package:my_skenu/Screens/UserProfileScreen.dart';
import 'package:my_skenu/Widgets/ChatMessWidget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
    super.dispose();
    messageController.dispose();
  }

  void showDeleteDialog(String messId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete this message'),
          actions: [
            TextButton(
              onPressed: () {
                FirestoreMethods().onDeleteMessage(messId, widget.chatroomId);
                Navigator.pop(context);
              },
              child: Text(
                'Yes',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'No',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserProvider>(context).getModel;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  UserProfileScreen.route(
                    isMe: false,
                    postUserModel: widget.chatUserModel,
                  ),
                );
              },
              icon: Container(
                margin: const EdgeInsets.only(right: 5),
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    widget.chatUserModel.photoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(widget.chatUserModel.name),
          ],
        ),
        backgroundColor: MyColors.darkyellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatroom')
                    .doc(widget.chatroomId)
                    .collection('chats')
                    .orderBy('time', descending: false)
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
                          return InkWell(
                            onLongPress: () {
                              showDeleteDialog(tempModel.messId);
                            },
                            child: ChatMessageWidget(
                              messageModel: tempModel,
                              userUid: model.uid,
                            ),
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
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    child: IconButton(
                      onPressed: () async {
                        String message = messageController.text.trim();
                        String messId = Uuid().v1();
                        MessageModel messModel = MessageModel(
                          messId: messId,
                          message: message,
                          time: DateTime.now(),
                          senderUid: model.uid,
                        );
                        await FirestoreMethods()
                            .onSendMessage(messModel, widget.chatroomId);
                        messageController.clear();
                      },
                      icon: const Icon(Icons.send_rounded),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
