import 'package:flutter/material.dart';
import 'package:my_skenu/Auth/firebaseAuth.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:provider/provider.dart';

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

void updateUserData(BuildContext context) async{
  UserProvider provider = Provider.of(context,listen: false);
  await provider.refreshUser();
}
