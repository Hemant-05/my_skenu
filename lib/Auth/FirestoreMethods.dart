import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_skenu/Core/Util/Models/MessageModel.dart';
import 'package:my_skenu/Core/Util/Models/PostModel.dart';
import 'package:my_skenu/Core/Util/ShowSnackbar.dart';
import 'package:my_skenu/Core/Util/StorageMethods.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String uid,
    required Uint8List file,
    required String description,
    required String name,
    required String profileImage,
  }) async {
    String str = 'nothing';
    String postId = Uuid().v1();
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      PostModel postModel = PostModel(
        description: description,
        uid: uid,
        name: name,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(postModel.toJson());
      str = 'success';
    } catch (e) {
      str = e.toString();
    }
    return str;
  }

  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> onSendMessage(MessageModel model, String chatroomId) async {
    try {
      _firestore
          .collection('chatroom')
          .doc(chatroomId)
          .collection('chats')
          .doc(model.messId)
          .set(model.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> onDeleteMessage(String messId, String chatroomId) async {
    try {
      _firestore
          .collection('chatroom')
          .doc(chatroomId)
          .collection('chats')
          .doc(messId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String uid, String name,
      String photoUrl, String comment, DateTime commentTime) async {
    try {
      String commentId = Uuid().v1();
      if (comment.isNotEmpty) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'uid': uid,
          'name': name,
          'commentTime': commentTime,
          'comment': comment,
          'photoUrl': photoUrl,
          'commentId': commentId,
        });
      } else {
        print('Write something....');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatePost(
      String description, String photoUrl, String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'description': description,
        'postUrl': photoUrl,
        'datePublished': DateTime.now(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(
    String userUid,
    List following,
    String followingUid,
  ) async {
    if (following.contains(followingUid)) {
      await _firestore.collection('users').doc(userUid).update({
        'following': FieldValue.arrayRemove([followingUid]),
      });
      await _firestore.collection('users').doc(followingUid).update({
        'follower': FieldValue.arrayRemove([userUid]),
      });
    } else {
      await _firestore.collection('users').doc(userUid).update({
        'following': FieldValue.arrayUnion([followingUid]),
      });
      await _firestore.collection('users').doc(followingUid).update({
        'follower': FieldValue.arrayUnion([userUid]),
      });
    }
  }

  Future<void> updateUser(String photoUrl, String name, String uid) async {
    try {
      if (photoUrl.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update({
          'photoUrl': photoUrl,
        });
      }
      if (name.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update({
          'name': name,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Get another user details
  Future<UserModel> getDetails(String uid) async {
    final data = await _firestore.collection('users').doc(uid).get();
    return UserModel.fromSnap(data);
  }

  //for future builder to get user data
  Future<DocumentSnapshot> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid);
    return await doc.get();
  }
}
