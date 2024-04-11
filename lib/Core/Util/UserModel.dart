class UserModel {
  final String email;
  final String name;
  final String uid;
  final List follower;
  final List following;
  final List post;

  UserModel({
    required this.email,
    required this.name,
    required this.uid,
    required this.follower,
    required this.following,
    required this.post,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json['email'] as String,
    name: json['name'] as String,
    uid: json['uid'] as String,
    follower: List.from(json['follower']),
    following: List.from(json['following']),
    post: List.from(json['post']),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'uid': uid,
    'follower': follower,
    'following': following,
    'post': post,
  };
}
