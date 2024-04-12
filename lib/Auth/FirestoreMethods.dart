import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_skenu/Core/Util/PostModel.dart';
import 'package:my_skenu/Core/Util/ShowSnackbar.dart';
import 'package:my_skenu/Core/Util/StorageMethods.dart';
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
  Future<void> likePost(String uid,String postId, List likes) async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayRemove([uid]),
        });
      }else{
        await _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayUnion([uid]),
        });
      }
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> postComment(String postId,String uid,String name,String photoUrl,String comment,DateTime commentTime) async{
    try{
      String commentId = Uuid().v1();
      if(comment.isNotEmpty) {
        await _firestore.collection('posts').doc(postId)
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
      }else{
        print('Write something....');
      }
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> updateUser(String photoUrl,String name,String uid)async{
    try{
      if(photoUrl.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update({
          'photoUrl': photoUrl,
        });
      }
      if(name.isNotEmpty){
        await _firestore.collection('users').doc(uid).update({
          'name': name,
        });
      }
    }catch(e){
      print(e.toString());
    }
  }
}
