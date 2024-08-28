import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final String uid;
  final List follower;
  final List following;
  final List liked;
  final List saved;
  final String photoUrl;

  UserModel(
      {required this.email,
      required this.name,
      required this.uid,
      required this.follower,
      required this.following,
      required this.liked,
      required this.saved,
      required this.photoUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'] as String,
        name: json['name'] as String,
        uid: json['uid'] as String,
        follower: List.from(json['follower']),
        following: List.from(json['following']),
        liked: List.from(json['liked']),
        saved: List.from(json['saved']),
        photoUrl: json['photoUrl'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'uid': uid,
        'follower': follower,
        'following': following,
        'liked': liked,
        'saved': saved,
        'photoUrl': photoUrl,
      };

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      email: snap['email'],
      name: snap['name'],
      uid: snap['uid'],
      follower: snap['follower'],
      following: snap['following'],
      liked: snap['liked'],
      saved: snap['saved'],
      photoUrl: snap['photoUrl'],
    );
  }
}
