// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class AvatarPhotoUpdate extends StatefulWidget {
  final Function(File image) onImageSelected;
  final String logoURL;
  const AvatarPhotoUpdate(
      {super.key, required this.onImageSelected, required this.logoURL});

  @override
  State<AvatarPhotoUpdate> createState() => _AvatarPhotoState();
}

class _AvatarPhotoState extends State<AvatarPhotoUpdate> {
  late File _pickedImage;
  bool _changed = false;

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: kDarkColor,
            activeControlsWidgetColor: kDarkColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
          boundary: CroppieBoundary(
            width: (MediaQuery.of(context).size.width * 0.8).toInt(),
            height: (MediaQuery.of(context).size.width * 0.8).toInt(),
          ),
          enableZoom: true,
          mouseWheelZoom: true,
          enableResize: true,
          showZoomer: true,
        ),
      ],
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 75,
          backgroundColor: kBorderColor,
          child: ClipOval(
            child: _changed
                ? Image.file(
                    _pickedImage,
                    fit: BoxFit.cover,
                    width: 140,
                    height: 140,
                  )
                : Image.network(
                    widget.logoURL,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/loading.png',
                        width: 140,
                        height: 140,
                      );
                    },
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: kLightColor),
            onPressed: () async {
              final picker = ImagePicker();
              final pickedImage =
                  await picker.getImage(source: ImageSource.gallery);
              final pickedImageFile = File(pickedImage!.path);
              _changed = true;
              final cropped = await _cropImage(
                imageFile: pickedImageFile,
              );
              setState(() {
                _pickedImage = cropped!;
              });
              widget.onImageSelected(_pickedImage);
            },
            icon: const Icon(Icons.image),
            label: const Text('Change your logo')),
      ],
    );
  }
}
