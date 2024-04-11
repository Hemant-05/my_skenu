import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Core/Util/MyColors.dart';
import 'package:my_skenu/Core/Util/UserModel.dart';
import 'package:my_skenu/Widgets/AuthButton.dart';
import 'package:my_skenu/Widgets/ProfileWidget.dart';
import '../Auth/firebaseAuth.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.isMe, required this.model});

  final UserModel model;
  final bool isMe;

  static route({required bool isMe, required UserModel model}) =>
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          isMe: isMe,
          model: model,
        ),
      );

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.isMe
              ? IconButton(
                  onPressed: () {
                    final _auth = FirebaseAuthMethods(FirebaseAuth.instance);
                    _auth.logOut(context);
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                  ),
                )
              : IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu,
                  ),
                ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    child: const Icon(
                      Icons.person_rounded,
                      size: 70,
                    ),
                  ),
                ),
                ProfileWidget(
                  title: 'Followers',
                  value: widget.model.follower.length.toString(),
                ),
                ProfileWidget(
                  title: 'Following',
                  value: widget.model.following.length.toString(),
                ),
                ProfileWidget(
                  title: 'Post',
                  value: widget.model.post.length.toString(),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              width: double.infinity,
              height: 70,
              child: Text(
                widget.model.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            widget.isMe
                ? AuthButton(
                    color: MyColors.darkBlue,
                    text: 'Edit Profile',
                    fun: () {},
                    textColor: Colors.white,
                  )
                : AuthButton(
                    color: MyColors.darkBlue,
                    text: 'Follow',
                    fun: () {},
                    textColor: Colors.white,
                  ),
          ],
        ),
      ),
    );
  }
}
