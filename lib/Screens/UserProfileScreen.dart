import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_skenu/Auth/FirestoreMethods.dart';
import 'package:my_skenu/Core/Util/MyColors.dart';
import 'package:my_skenu/Core/Util/Models/PostModel.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:my_skenu/Screens/AddPostScreen.dart';
import 'package:my_skenu/Screens/EditUserProfile.dart';
import 'package:my_skenu/Widgets/AuthButton.dart';
import 'package:my_skenu/Widgets/ProfileWidget.dart';
import 'package:provider/provider.dart';
import '../Auth/firebaseAuth.dart';
import '../Provider/UserProvider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen(
      {super.key, required this.isMe, required this.postUserModel});

  final UserModel postUserModel;
  final bool isMe;

  static route({required bool isMe, required UserModel postUserModel}) =>
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          isMe: isMe,
          postUserModel: postUserModel,
        ),
      );

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  void onSelected(int index) {}

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

  showMenuDialog(String postId) async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Options'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
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
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      widget.postUserModel.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ProfileWidget(
                  title: 'Followers',
                  value: widget.postUserModel.follower.length.toString(),
                ),
                ProfileWidget(
                  title: 'Following',
                  value: widget.postUserModel.following.length.toString(),
                ),
                ProfileWidget(
                  title: 'Posts',
                  value: '0',
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              width: double.infinity,
              height: 70,
              child: Text(
                widget.postUserModel.name,
                style: TextStyle(
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
                : AuthButton(
                    color: widget.postUserModel.follower.contains(model.uid)
                        ? Colors.grey
                        : MyColors.darkBlue,
                    text: 'Follow',
                    fun: () {
                      FirestoreMethods().followUser(
                        model.uid,
                        model.following,
                        widget.postUserModel.uid,
                        widget.postUserModel.follower,
                      );
                    },
                    textColor: Colors.white,
                  ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: widget.postUserModel.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    var data = snapshot.data!.docs;
                    if (data.length == 0) {
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
                                  showMenuDialog(tempModel.postId);
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
