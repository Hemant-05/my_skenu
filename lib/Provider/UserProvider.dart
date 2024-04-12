import 'package:flutter/material.dart';
import 'package:my_skenu/Auth/firebaseAuth.dart';
import 'package:my_skenu/Core/Util/UserModel.dart';

class UserProvider with ChangeNotifier {
  UserModel? _model;
  final FirebaseAuthMethods _methods = FirebaseAuthMethods();

  UserModel get getModel => _model!;

  Future<void> refreshUser() async {
    UserModel model = await _methods.getUserDetails();
    _model = model;
    notifyListeners();
  }
}
