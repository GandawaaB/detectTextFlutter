import 'package:image_picker/image_picker.dart';

Future<String> pickImage({ImageSource? source}) async {
  final picker = ImagePicker();
  String path = '';
  try {
    final XFile? getImage = await picker.pickImage(source: source!);
    if (getImage != null) {
      path = getImage.path;
      print(path);
    } else {
      path = '';
    }
  } catch (e) {
    print(e.toString());
  }
  return path;
}
