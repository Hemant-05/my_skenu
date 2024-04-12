import 'dart:io';

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
    XFile? _file = await _picker.pickImage(source: source,imageQuality: 50);
    if(_file != null){
      return await _file.readAsBytes();
    }
  print('No image will be selected !');
}