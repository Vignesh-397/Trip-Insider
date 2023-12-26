import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripinsider/utils/colorsScheme.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.endToStart,
      backgroundColor: const Color.fromARGB(255, 208, 220, 253),
      content: Text(
        content,
        style: const TextStyle(color: mobileBackgroundColor),
      ),
    ),
  );
}
