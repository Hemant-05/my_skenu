import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_skenu/Auth/FirestoreMethods.dart';
import 'package:my_skenu/Core/Util/MyColors.dart';
import 'package:my_skenu/Core/Util/Models/PostModel.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:my_skenu/Screens/AddPostScreen.dart';
import 'package:my_skenu/Screens/EditPostScreen.dart';
import 'package:my_skenu/Screens/EditUserProfile.dart';
import 'package:my_skenu/Widgets/AuthButton.dart';
import 'package:my_skenu/Widgets/ProfileWidget.dart';
import 'package:provider/provider.dart';
import '../Auth/firebaseAuth.dart';
import '../Provider/UserProvider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen(
      {super.key,
      required this.isMe,
      required this.postUserModel,
      required this.uid});

  final UserModel postUserModel;
  final bool isMe;
  final String uid;

  static route(
          {required bool isMe,
          required UserModel postUserModel,
          required String uid}) =>
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          isMe: isMe,
          postUserModel: postUserModel,
          uid: uid,
        ),
      );

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isfollowing = false;
  int posts = 0;
  int follower = 0;
  int following = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var data = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.postUserModel.uid)
        .get();
    posts = data.docs.length;
    follower = widget.postUserModel.follower.length;
    following = widget.postUserModel.following.length;
    isfollowing = widget.postUserModel.follower.contains(widget.uid);
    setState(() {});
  }

  void showDeleteDialog(String postId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete this post ? "),
          actions: [
            TextButton(
              onPressed: () {
                FirestoreMethods().deletePost(postId);
                Navigator.pop(context);
                setState(() {
                  posts--;
                });
              },
              child: const Text(
                'Yes',
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'No',
              ),
            ),
          ],
        );
      },
    );
  }

  void followFunction(String uid, List following) async {
    FirestoreMethods().followUser(
      uid,
      following,
      widget.postUserModel.uid,
    );
    updateUserData(context);
  }

  showMenuDialog(String postUrl, String description, String postId) async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Options'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  EditPostScreen.route(
                    description: description,
                    postUrl: postUrl,
                    postId: postId,
                  ),
                );
              },
              child: Text('Edit'),
            ),
            SimpleDialogOption(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.pop(context);
                showDeleteDialog(postId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserProvider>(context).getModel;
    bool isMe = (model.uid.compareTo(widget.postUserModel.uid) == 0);
    UserModel postUserModel = widget.postUserModel;
    return Scaffold(
      appBar: AppBar(
        actions: [
          isMe
              ? IconButton(
                  onPressed: () {
                    final _auth = FirebaseAuthMethods();
                    _auth.logOut(context);
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                  ),
                )
              : IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                  ),
                ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      postUserModel.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ProfileWidget(
                  title: 'Followers',
                  value: follower.toString(),
                ),
                ProfileWidget(
                  title: 'Following',
                  value: following.toString(),
                ),
                ProfileWidget(
                  title: 'Posts',
                  value: '$posts',
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              width: double.infinity,
              height: 70,
              child: Text(
                postUserModel.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            isMe
                ? AuthButton(
                    color: MyColors.darkBlue,
                    text: 'Edit Profile',
                    fun: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditUserProfile(),
                        ),
                      );
                    },
                    textColor: Colors.white,
                  )
                : isfollowing
                    ? AuthButton(
                        color: Colors.grey,
                        text: 'Unfollow',
                        fun: () async {
                          followFunction(model.uid, model.following);
                          postUserModel = await FirestoreMethods()
                              .getDetails(postUserModel.uid);
                          setState(() {
                            isfollowing = false;
                            follower--;
                          });
                        },
                        textColor: Colors.white,
                      )
                    : AuthButton(
                        color: MyColors.darkyellow,
                        text: 'Follow',
                        fun: () async {
                          followFunction(model.uid, model.following);
                          setState(() {
                            isfollowing = true;
                            follower++;
                          });
                        },
                        textColor: Colors.white,
                      ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: postUserModel.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    var data = snapshot.data!.docs;
                    posts = data.length;
                    if (data.length == 0 && isMe) {
                      return Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, AddPostScreen.route());
                          },
                          child: const Text(
                            'Create post',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    } else if (data.length == 0 && !isMe) {
                      return const Center(
                        child: Text(
                          'No post here',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          PostModel tempModel =
                              PostModel.fromJson(data[index].data());
                          return ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Container(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  tempModel.postUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              tempModel.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              DateFormat.yMMMd().format(
                                tempModel.datePublished,
                              ),
                            ),
                            trailing: Visibility(
                              visible: isMe,
                              child: IconButton(
                                onPressed: () {
                                  showMenuDialog(
                                    tempModel.postUrl,
                                    tempModel.description,
                                    tempModel.postId,
                                  );
                                },
                                icon: const Icon(
                                  Icons.more_vert,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Text('No Data here');
                    }
                  }
                  return Text('some error accoured');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
