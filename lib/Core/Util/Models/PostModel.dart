import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String uid;
  final String name;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileImage;
  final List likes;

  PostModel({
    required this.description,
    required this.uid,
    required this.name,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    description: json['description'] as String,
    uid: json['uid'] as String,
    name: json['name'] as String,
    postId: json['postId'] as String,
    datePublished: json['datePublished'].toDate(),
    postUrl: json['postUrl'] as String,
    profileImage: json['profileImage'] as String,
    likes: json['likes'],
  );

  Map<String, dynamic> toJson() => {
    'description': description,
    'uid': uid,
    'name': name,
    'postId': postId,
    'datePublished': datePublished,
    'postUrl': postUrl,
    'profileImage': profileImage,
    'likes': likes,
  };

  factory PostModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return PostModel(
      description: data['description'] as String,
      uid: data['uid'] as String,
      name: data['name'] as String,
      postId: data['postId'] as String,
      datePublished: data['datePublished'].toDate(),
      postUrl: data['postUrl'] as String,
      profileImage: data['profileImage'] as String,
      likes: data['likes'],
    );
  }
}
