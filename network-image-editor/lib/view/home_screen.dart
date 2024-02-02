import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:network_image_editor/utils/file_saver.dart';

import '../utils/network_image_editor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NetworkImageEditor networkImageEditor;
  Uint8List? editedImage;
  @override
  void initState() {
    networkImageEditor = NetworkImageEditor(context);
    super.initState();
  }

  void editImage() async {
    editedImage = await networkImageEditor.initialize(
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg",
        savedFileType: SavedFileType.image);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Editor')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Column(children: [
          editedImage != null
              ? Image.memory(editedImage!)
              : Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg'),
          ElevatedButton(
              onPressed: () {
                editImage();
              },
              child: const Text('Edit Image'))
        ]),
      ),
    );
  }
}
