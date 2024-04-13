import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messId;
  final String message;
  final bool sendByMe;
  final DateTime time;
  final String senderUid;

  MessageModel({
    required this.messId,
    required this.message,
    required this.sendByMe,
    required this.time,
    required this.senderUid,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    messId: json['messId'] as String,
    message: json['message'] as String,
    sendByMe: json['sendByMe'] as bool,
    time: DateTime.parse(json['time'].toDate()), // Parse time string
    senderUid: json['senderUid'] as String,
  );

  Map<String, dynamic> toJson() => {
    'messId': messId,
    'message': message,
    'sendByMe': sendByMe,
    'time': time,
    'senderUid': senderUid,
  };

  factory MessageModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return MessageModel(
      messId: data['messId'] as String,
      message: data['message'] as String,
      sendByMe: data['sendByMe'] as bool,
      time: DateTime.parse(data['time'].toDate()),
      senderUid: data['senderUid'] as String,
    );
  }
}
