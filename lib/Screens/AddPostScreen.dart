import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_skenu/Auth/FirestoreMethods.dart';
import 'package:my_skenu/Core/Util/MyColors.dart';
import 'package:my_skenu/Core/Util/PickImage.dart';
import 'package:my_skenu/Core/Util/ShowSnackbar.dart';
import 'package:my_skenu/Core/Util/Models/UserModel.dart';
import 'package:my_skenu/Provider/UserProvider.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const AddPostScreen(),
      );

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  _pickImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: const Text('Create a post'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
              child: const Text('Take a photo'),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
              child: const Text('Choose from gallery'),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String name, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        uid: uid,
        file: _file!,
        description: _captionController.text.trim(),
        name: name,
        profileImage: profileImage,
      );
      if (res == 'success') {
        showSnackBar(context, 'posted');
        Navigator.pop(context);
      } else {
        showSnackBar(context, '$res');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserProvider>(context).getModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post to',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              postImage(model.uid, model.name, model.photoUrl);
            },
            child: Text(
              'Post',
              style: TextStyle(
                color: MyColors.purpul,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 2,
              child: _isLoading ? const LinearProgressIndicator() : Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    _pickImage(context);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: _file != null
                          ? Image(
                              image: MemoryImage(
                                _file!,
                              ),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              alignment: Alignment.center,
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.grey,
                              ),
                              child: const Icon(
                                size: 50,
                                Icons.image,
                              ),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _captionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write a Caption....',
                    ),
                    maxLines: 5,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
