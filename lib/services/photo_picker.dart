import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

/// Thin wrapper over image_picker so that tests can replace it.
class PhotoPicker {
  const PhotoPicker();

  /// Paths of the picked photos (several from the gallery, one from the
  /// camera); empty when cancelled. Photos are compressed later, so
  /// full-resolution originals are requested here.
  Future<List<String>> pick(PhotoSource source) async {
    final picker = ImagePicker();
    if (source == PhotoSource.camera) {
      final file = await picker.pickImage(source: ImageSource.camera);
      return [?file?.path];
    }
    final files = await picker.pickMultiImage();
    return [for (final f in files) f.path];
  }
}

/// Asks where to take photos from: camera or gallery.
Future<PhotoSource?> askPhotoSource(BuildContext context) {
  return showModalBottomSheet<PhotoSource>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Take a photo'),
            onTap: () => Navigator.pop(context, PhotoSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(context, PhotoSource.gallery),
          ),
        ],
      ),
    ),
  );
}
