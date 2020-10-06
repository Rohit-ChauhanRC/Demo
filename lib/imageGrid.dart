import 'dart:typed_data';

import 'package:demo/dataHolder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  Widget makeImagesGrid() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 34,
        itemBuilder: (context, index) {
          return ImageGridItem(index + 1);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: makeImagesGrid(),
    );
  }
}

class ImageGridItem extends StatefulWidget {
  final int index;

  ImageGridItem(this.index);
  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  Uint8List imageFile;

  StorageReference photosReference =
      FirebaseStorage.instance.ref().child("folder");

  getImage() {
    if (!requestedIndexes.contains(widget.index)) {
      int maxSize = 4 * 1024 * 1024;
      photosReference
          .child('imageName${widget.index}.jpg')
          .getData(maxSize)
          .then((value) {
        this.setState(() {
          imageFile = value;
        });
        imageData.putIfAbsent(widget.index, () => value);
      }).catchError((error) {});
      requestedIndexes.add(widget.index);
    }
  }

  Widget decideGridView() {
    if (imageFile == null) {
      return Center(child: Text("No Data"));
    } else {
      return Image.memory(
        imageFile,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (!imageData.containsKey(widget.index)) {
      getImage();
    } else {
      this.setState(() {
        imageFile = imageData[widget.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: decideGridView(),
    );
  }
}
