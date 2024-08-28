import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_skenu/Auth/FirestoreMethods.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:my_skenu/Provider/UserProvider.dart';
import 'package:my_skenu/Screens/PostCommentScreen.dart';
import 'package:my_skenu/Screens/PostDetailsScreen.dart';
import 'package:my_skenu/Screens/UserProfileScreen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key, required this.snapshot});

  final snapshot;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  void shareImageAndText(String description, String photoUrl) async {
    print('$photoUrl');
    await Share.share('$photoUrl \n $description');
  }

  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserProvider>(context).getModel;
    return Container(
      height: 600,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: double.infinity,
            child: InkWell(
              onTap: () async {
                UserModel _model =
                    await FirestoreMethods().getDetails(widget.snapshot['uid']);
                Navigator.push(
                  context,
                  UserProfileScreen.route(
                    isMe: false,
                    postUserModel: _model,
                    uid: model.uid,
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.snapshot['profileImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.snapshot['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        DateFormat.yMMMd().format(
                          widget.snapshot['datePublished'].toDate(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PostDetailsScreen.route(
                  postUid: widget.snapshot['postId'],
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 400,
              child: Image.network(
                widget.snapshot['postUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.snapshot['description'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      FirestoreMethods().likePost(model.uid,
                          widget.snapshot['postId'], widget.snapshot['likes']);
                    },
                    icon: widget.snapshot['likes'].contains(model.uid)
                        ? const Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border_rounded,
                          ),
                  ),
                  IconButton(
                    onPressed: () async {
                      shareImageAndText(widget.snapshot['description'],
                          widget.snapshot['postUrl']);
                    },
                    icon: const Icon(
                      Icons.share,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PostCommentScreen.route(
                          postId: widget.snapshot['postId'],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.insert_comment,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Text(
              '${widget.snapshot['likes'].length} ${widget.snapshot['likes'].length > 1 ? 'Likes' : 'Like'}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
