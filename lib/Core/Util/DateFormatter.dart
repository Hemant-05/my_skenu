import 'package:intl/intl.dart';

String DateFormatterYMMMD(DateTime time){
  return DateFormat.yMMMd().format(time);
}
String DateFormatterHHMMZone(DateTime time){
  return DateFormat.jm().format(time);
}