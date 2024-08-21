import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pick_image() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    var x = await pickedFile.readAsBytes();
    print(x);
    return File(pickedFile.path);
  }
  return null;
}
