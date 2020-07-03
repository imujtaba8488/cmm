import 'package:flutter/material.dart';

import '../widgets/basic_dialog.dart';

typedef PictureSourceSelected = void Function(PictureSource);

class ImageSourceSelector extends StatelessWidget {
  final PictureSourceSelected pictureSourceSelected;

  ImageSourceSelector({this.pictureSourceSelected});

  @override
  Widget build(BuildContext context) {
    return BasicDialog(
      hasRoundedCorners: false,
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
              pictureSourceSelected(PictureSource.camera);
              Navigator.pop(context);
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
              pictureSourceSelected(PictureSource.gallery);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

enum PictureSource {
  camera,
  gallery,
}
