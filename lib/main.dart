// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './Utils/image_picker.dart';
import './Utils/image_send_to_server.dart';

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
  var resText = "";
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _copy() {
      final copyText = ClipboardData(text: controller.text);
      Clipboard.setData(copyText);
      return const Center(
        child: AlertDialog(
          title: Text("Text Copied"),
          content: Text("Text Copied"),
        ),
      );
    }

    _past() async {
      final pastText = await Clipboard.getData('text/plain');
      if (pastText != null) {
        setState(() {
          controller.text = pastText.text ?? controller.text;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          // selectedImage == null
          //     ? Image.asset(
          //         "image/rb.png",
          //         width: 200,
          //         height: 200,
          //       )
          //     : Container(
          //         width: 200,
          //         height: 200,
          //         padding: const EdgeInsets.all(20),
          //         child: InteractiveViewer(
          //           child: Image.file(selectedImage!),
          //         ),
          //       ),
          isLoading
              ? LinearProgressIndicator()
              : Image.asset(
                  "image/rb.png",
                  width: 200,
                  height: 200,
                ),

          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final snackBar = SnackBar(
                      content: const Text(''),
                      backgroundColor: Colors.white,
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'Text Pasted',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    _past();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 30),
                  ),
                  child: const Text('PASTE'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    final snackBar = SnackBar(
                      content: const Text(''),
                      backgroundColor: Colors.white,
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'Text Copied',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    _copy();
                  },
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
            padding:
                const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
            child: Card(
              child: SizedBox(
                width: 200,
                height: 200,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: controller,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: "Detected text ...",
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                  ),
                  maxLines: 20,
                  minLines: 3,
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Thank you 😎"),
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
                    print("File");
                  });
                  imageCropperView(value, context);
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
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     });
      await uploadImage(selectedImage!).then((resTextService) {
        if (resText != null) {
          setState(() {
            isLoading = true;
          });

          setState(() {
            controller.text = "";
            controller.text = resTextService;
            selectedImage = null;
          });
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            controller.text = "Текстийг таньсангүй";
          });
          print("resText: $resTextService");
        }
      });
    } else {
      print("Do nothing");
    }
  }
}
