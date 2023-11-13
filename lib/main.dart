import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './Utils/image_picker.dart';

void main() {
  runApp(const MyApp(
    selectedImage: null,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, File? selectedImage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Detect Text From Image'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, selectedImage, state});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? selectedImage;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          selectedImage == null
              ? Image.asset(
                  "image/rb.png",
                  width: 200,
                  height: 200,
                )
              : Container(
                  padding: const EdgeInsets.all(20),
                  child: InteractiveViewer(
                    child: Image.file(selectedImage!),
                  ),
                ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 30),
                  ),
                  child: const Text('FAST'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 30),
                  ),
                  child: const Text('COPY'),
                ),
              ],
            ),
          ),
          Container(
            height: 500,
            padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
            child: Card(
              child: SizedBox(
                width: 200,
                height: 200,
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Detected text ...",
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Thank you 😎"),
              Text("MUST-SICT"),
              Text("2023"),
            ],
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              //Camera
              pickImage(source: ImageSource.camera).then((value) {
                if (value != '') {
                  setState(() {
                    selectedImage = File(value);
                    print("Image file:$selectedImage");
                  });
                }
              });
            },
            tooltip: 'Increment',
            child: const Icon(Icons.camera),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              //Gallery
              pickImage(source: ImageSource.gallery).then((value) {
                if (value != '') {
                  setState(() {
                    selectedImage = File(value);
                    print("Image file:$selectedImage");
                  });
                }
                imageCropperView(value, context);
              });
            },
            tooltip: 'Increment',
            child: const Icon(Icons.image),
          )
        ],
      ),
    );
  }

  Future imageCropperView(String? path, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path!,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      print("Cropped");
      setState(() {
        selectedImage = File(croppedFile.path);
      });
    } else {
      print("Do nothing");
    }
  }
}
