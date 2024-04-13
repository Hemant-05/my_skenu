import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_skenu/Auth/FirestoreMethods.dart';
import 'package:my_skenu/Core/Util/PickImage.dart';
import 'package:my_skenu/Core/Util/ShowSnackbar.dart';
import 'package:my_skenu/Core/Util/StorageMethods.dart';
import 'package:provider/provider.dart';
import '../Core/Util/MyColors.dart';
import '../Core/Util/Models/UserModel.dart';
import '../Provider/UserProvider.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final nameController = TextEditingController();
  Uint8List? image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectPick() async {
    Uint8List file = await pickImage(ImageSource.gallery);
    setState(() {
      image = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserProvider>(context).getModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              String name = nameController.text.trim();
              String photoUrl = '';
              if (image != null) {
                //upload and get download url
                photoUrl = await StorageMethods()
                    .uploadImageToStorage('profilePics', image!, false);
              }
              await FirestoreMethods().updateUser(photoUrl, name, model.uid);
              showSnackBar(context, 'Updated Successfully');
              updateUserData(context);
              Navigator.pop(context);
              setState(() {
                _isLoading = false;
              });
            },
            child: Text(
              'Save',
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      selectPick();
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color:
                            image != null ? MyColors.transparent : Colors.grey,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image(
                                image: MemoryImage(
                                  image!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 100,
                            ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Change your name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
