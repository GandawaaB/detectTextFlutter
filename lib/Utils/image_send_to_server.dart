import 'dart:io';

import 'package:http/http.dart' as http;

uploadImage(File _selectedImage) async {
  // Create a multipart/form-data HTTP request.
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('http://192.168.1.19:5000/upload'),
  );
  final headers = {"Content-type": "multipart/form-data"};

  // Add the image file to the request.
  request.files.add(
    http.MultipartFile('image', _selectedImage.readAsBytes().asStream(),
        _selectedImage.lengthSync(),
        filename: _selectedImage.path.split("/").last),
  );
  request.headers.addAll(headers);

  // Send the request and get the response.
  final response = await request.send();
  http.Response res = await http.Response.fromStream(response);
  //final resJson = jsonDecode(res.body);

  // Check the response status code.
  if (response.statusCode == 200) {
    // setState(() {
    //   resData = res.body;
    // });
    print("response:");
    print(res.body);
    return res.body;
  } else {
    // setState(() {

    // });
    print("No aldaa garlaa");
  }
}
