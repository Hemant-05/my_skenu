import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.comment,
    required this.time,
    required this.name,
    required this.photoUrl,
  });

  final String comment;
  final DateTime time;
  final String name;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          Container(
            width: 260,
            margin: EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: Text(
              comment,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Text(
              DateFormat.yMMMd().format(
                time,
              ),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
