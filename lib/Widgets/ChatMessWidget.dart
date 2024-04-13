import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_skenu/Core/Util/Models/MessageModel.dart';
import 'package:my_skenu/Core/Util/MyColors.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
      {super.key, required this.messageModel, this.userUid});

  final MessageModel messageModel;
  final userUid;

  @override
  Widget build(BuildContext context) {
    bool _isMyMessage = userUid == messageModel.senderUid;
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: _isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
        decoration: BoxDecoration(
          color: _isMyMessage ? MyColors.darkyellow : MyColors.lightyellow,
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
            topLeft: Radius.circular(_isMyMessage ? 10 : 1),
            topRight: Radius.circular(_isMyMessage ? 1 : 10),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              messageModel.message,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('hh:mm a').format(messageModel.time),
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
