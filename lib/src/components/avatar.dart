import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/basic_dialog.dart';

typedef OnCapture = Function(String imagePath, File imageFile);

class Avatar extends StatefulWidget {
  final double radius;
  final OnCapture onCapture;

  Avatar({this.radius = 30.0, this.onCapture});

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  String imagePath;
  File imageFile;
  _PictureSource _pictureSource;

  @override
  void initState() {
    super.initState();
    imagePath = imagePath = 'assets/test.jpg';
    _pictureSource = _PictureSource.gallery;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (context) {
            return _sourceSelector();
          }),
      child: CircleAvatar(
        radius: widget.radius,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }

  Widget _sourceSelector() {
    return BasicDialog(
      roundedCornors: false,
      borderWidth: 0.5,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          OutlineButton(
            child: Text(
              'Camera',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              setState(() {
                _pictureSource = _PictureSource.camera;
                Navigator.pop(context);
                _pickImage();
              });
            },
          ),
          OutlineButton(
            child: Text(
              'Gallery',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              setState(() {
                _pictureSource = _PictureSource.gallery;
                Navigator.pop(context);
                _pickImage();
              });
            },
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    if (await Permission.storage.request().isGranted) {
      final picker = ImagePicker();

      final pickedFile = await picker.getImage(
        source: _pictureSource == _PictureSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 25,
      );

      if (pickedFile != null) {
        imageFile = File(pickedFile.path);

        setState(() {
          imagePath = pickedFile.path;
        });

        widget.onCapture(imagePath, imageFile);
      }
    }
  }
}

enum _PictureSource {
  camera,
  gallery,
}
