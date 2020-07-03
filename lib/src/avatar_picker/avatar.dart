import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'image_source_selector.dart';

typedef OnCapture = Function(String imagePath, File imageFile);

class Avatar extends StatefulWidget {
  final double radius;
  final OnCapture onCapture;
  final String networkImage;
  final bool isSelectionEnabled;

  Avatar({
    this.radius = 30.0,
    this.onCapture,
    this.networkImage,
    this.isSelectionEnabled = true,
  });

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  String imagePath;
  File imageFile;
  PictureSource _pictureSource;

  @override
  void initState() {
    super.initState();
    imagePath = 'assets/test.jpg';
    _pictureSource = PictureSource.gallery;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isSelectionEnabled,
      child: InkWell(
        onTap: () {
          if (widget.isSelectionEnabled) {
            showDialog(
              context: context,
              builder: (context) {
                return ImageSourceSelector(
                  pictureSourceSelected: (PictureSource picSource) {
                    setState(() {
                      _pictureSource = picSource;
                      _pickImage();
                    });
                  },
                );
              },
            );
          }
        },
        child: CircleAvatar(
          radius: widget.radius,
          backgroundImage: widget.networkImage != null
              ? NetworkImage(widget.networkImage)
              : AssetImage(imagePath),
        ),
      ),
    );
  }

  void _pickImage() async {
    if (await Permission.storage.request().isGranted) {
      final picker = ImagePicker();

      final pickedFile = await picker.getImage(
        source: _pictureSource == PictureSource.camera
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
