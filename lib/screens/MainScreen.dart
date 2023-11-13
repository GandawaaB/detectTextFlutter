import 'dart:io';
import 'package:flutter/material.dart';

File? selectedImage;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, selectedImage});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        selectedImage == null
            ? Image.asset(
                "image/rb.png",
                width: 200,
                height: 200,
              )
            : InteractiveViewer(child: Image.file(selectedImage!)),
      ],
    );
  }
}
