import 'package:flutter/material.dart';

void imagePickerModel(BuildContext context,
    {VoidCallback? onCameraTap, VoidCallback? onGalleryTap}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 130,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onCameraTap,
                    child: Card(
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(15),
                          //decoration: BoxDecoration(color: Colors.grey),
                          child: const Text(
                            "Camera",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: onGalleryTap,
                    child: Card(
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(15),
                          //  decoration: BoxDecoration(color: Colors.grey),
                          child: const Text(
                            "Gallery",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      });
}
