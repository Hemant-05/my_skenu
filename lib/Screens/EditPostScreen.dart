import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_skenu/Auth/FirestoreMethods.dart';
import 'package:my_skenu/Core/Util/ShowSnackbar.dart';
import '../Core/Util/MyColors.dart';
import '../Core/Util/PickImage.dart';
import '../Core/Util/StorageMethods.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen(
      {super.key,
      required this.description,
      required this.postUrl,
      required this.postId});

  final String description;
  final String postUrl;
  final String postId;

  static route(
          {required String description,
          required String postUrl,
          required String postId}) =>
      MaterialPageRoute(
        builder: (context) => EditPostScreen(
          description: description,
          postUrl: postUrl,
          postId: postId,
        ),
      );

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  TextEditingController editCaptionController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _file;


  @override
  void initState() {
    super.initState();
    editCaptionController.text = widget.description;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              String description = editCaptionController.text.trim();
              if (_file != null) {
                String photoUrl = await StorageMethods()
                    .uploadImageToStorage('posts', _file!, true);
                FirestoreMethods()
                    .updatePost(description, photoUrl, widget.postId);
                Navigator.pop(context);
              } else {
                showSnackBar(context, 'Change post picture');
              }
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      widget.postUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: editCaptionController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write a Caption....',
                ),
                maxLines: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
