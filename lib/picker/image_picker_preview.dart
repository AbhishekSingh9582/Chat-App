import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPreview extends StatefulWidget {
  ImagePickerPreview(this._imagePickFn);
  final Function(File image) _imagePickFn;
  @override
  _ImagePickerPreviewState createState() => _ImagePickerPreviewState();
}

class _ImagePickerPreviewState extends State<ImagePickerPreview> {
  File _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickImage = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    final pickImageFile = File(pickImage.path);
    setState(() {
      _pickedImage = pickImageFile;
    });
    widget._imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.camera),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
