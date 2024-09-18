import 'dart:io';
import 'package:file_picker/file_picker.dart';

/// Pick Image
Future<List<File>?> pickImage() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpeg', 'jpg'],
    );

    if (result == null) {
      return null;
    }

    return result.paths.map((path) => File(path!)).toList();
  } catch (e) {
    rethrow;
  }
}
