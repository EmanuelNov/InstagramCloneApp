import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(String uid, String username, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          uid, _descriptionController.text, _file!, username, profileImage);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, "Posted !");
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20.0),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20.0),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20.0),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.upload, size: 32,),
                  onPressed: () => _selectImage(context),
                  padding: EdgeInsets.all(10.0),
                ),
                Text('Add Post')
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Exit post'),
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.username, user.photoUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _isLoading
                      ? const LinearProgressIndicator()
                      : Padding(
                          padding: EdgeInsets.only(top: 0),
                        ),
                  Divider(
                    height: 24,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 320,
                        height: 320,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 320,
                              child: TextField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  hintText: 'Write a caption...',
                                  border: InputBorder.none,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
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
