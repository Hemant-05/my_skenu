import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_skenu/Auth/FirestoreMethods.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:my_skenu/Provider/UserProvider.dart';
import 'package:my_skenu/Widgets/MessageWidget.dart';
import 'package:provider/provider.dart';

class PostCommentScreen extends StatefulWidget {
  const PostCommentScreen({super.key, required this.postId});

  final String postId;

  static route({required String postId}) => MaterialPageRoute(
        builder: (context) => PostCommentScreen(
          postId: postId,
        ),
      );

  @override
  State<PostCommentScreen> createState() => _PostCommentScreenState();
}

class _PostCommentScreenState extends State<PostCommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserProvider>(context).getModel;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Comments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await FirestoreMethods().postComment(
                  widget.postId,
                  model.uid,
                  model.name,
                  model.photoUrl,
                  commentController.text.trim(),
                  DateTime.now(),
                );
                commentController.clear();
              },
              child: Text('post'))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index].data();
                      return MessageWidget(
                        comment: data['comment'],
                        photoUrl: data['photoUrl'],
                        name: data['name'],
                        time: data['commentTime'].toDate(),
                      );
                    },
                  );
                } else {
                  return Text('Error while fetching comment');
                }
              }
              return Container();
            },
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('comments')
                .snapshots(),
          )),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Comment as ${model.name}',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
