import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messId;
  final String message;
  final DateTime time;
  final String senderUid;

  MessageModel({
    required this.messId,
    required this.message,
    required this.time,
    required this.senderUid,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        messId: json['messId'] as String,
        message: json['message'] as String,
        time: json['time'].toDate(),
        senderUid: json['senderUid'] as String,
      );

  Map<String, dynamic> toJson() => {
        'messId': messId,
        'message': message,
        'time': time,
        'senderUid': senderUid,
      };

  factory MessageModel.fromSnap(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return MessageModel(
      messId: data['messId'] as String,
      message: data['message'] as String,
      time: data['time'].toDate(),
      senderUid: data['senderUid'] as String,
    );
  }
}
