// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class AvatarPhoto extends StatefulWidget {
  final Function(File image) onImageSelected;

  const AvatarPhoto({super.key, required this.onImageSelected});

  @override
  State<AvatarPhoto> createState() => _AvatarPhotoState();
}

class _AvatarPhotoState extends State<AvatarPhoto> {
  late File _pickedImage;
  bool _load = false;

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
            child: !_load
                ? const CircleAvatar(
                    radius: 70,
                    backgroundColor: kLightColor,
                    child: Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.white,
                    ))
                : !kIsWeb
                    ? Image.file(File(_pickedImage.path))
                    : Image.network(_pickedImage.path),
          ),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: kDarkColor),
          onPressed: () async {
            final picker = ImagePicker();
            final pickedImage =
                await picker.getImage(source: ImageSource.gallery);
            final pickedImageFile = File(pickedImage!.path);
            _load = true;
            final cropped = await _cropImage(
              imageFile: pickedImageFile,
            );
            setState(() {
              _pickedImage = cropped!;
            });
            widget.onImageSelected(_pickedImage);
          },
          icon: const Icon(Icons.image),
          label: _load
              ? const Text('Change your logo')
              : const Text('Upload your logo'),
        ),
      ],
    );
  }
}
