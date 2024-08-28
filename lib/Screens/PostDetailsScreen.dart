import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Auth/FirestoreMethods.dart';
import 'package:my_skenu/Core/Util/DateFormatter.dart';
import 'package:my_skenu/Core/Util/Models/PostModel.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:my_skenu/Provider/UserProvider.dart';
import 'package:my_skenu/Widgets/CommentMessageWidget.dart';
import 'package:provider/provider.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key, required this.postUid});

  final String postUid;

  static route({required String postUid}) => MaterialPageRoute(
        builder: (context) => PostDetailsScreen(postUid: postUid),
      );

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserProvider>(context).getModel;
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              PostModel postModel = PostModel.fromSnapshot(snapshot.data!);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postModel.description,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Post by ${postModel.name} on ${DateFormatterYMMMD(postModel.datePublished)} at ${DateFormatterHHMMZone(postModel.datePublished)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            postModel.postUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              FirestoreMethods().likePost(
                                  model.uid, postModel.postId, postModel.likes);
                            },
                            icon: postModel.likes.contains(model.uid)
                                ? const Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border_rounded,
                                  ),
                          ),
                          Text(
                            'Liked by ${postModel.likes.length.toString()} ${postModel.likes.length > 1 ? 'peoples' : 'people'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: const Text(
                          'Comments - ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 500,
                        padding: const EdgeInsets.only(top: 10),
                        width: double.infinity,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(postModel.postId)
                              .collection('comments')
                              .orderBy("commentTime", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasData) {
                                var data = snapshot.data!.docs;
                                return data.isEmpty
                                    ? const Center(
                                        child:
                                            Text('No comment on this post...'),
                                      )
                                    : ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          var commentModel = data[index].data();
                                          return CommentMessageWidget(
                                            comment: commentModel['comment'],
                                            time: commentModel['commentTime']
                                                .toDate(),
                                            name: commentModel['name'],
                                            photoUrl: commentModel['photoUrl'],
                                          );
                                        },
                                      );
                              } else {
                                return const Text('No data found');
                              }
                            } else {
                              return const Text(
                                  'Some error occurred while fetching comments of this post !');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Text('There is no data available for this post !');
            }
          } else {
            return const Text('Some Error occurred while fetching post data');
          }
        },
      ),
    );
  }
}
