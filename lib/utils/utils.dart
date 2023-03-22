import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();

  final XFile? file = await _picker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
}

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
