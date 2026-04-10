import 'dart:io';
import 'package:gal/gal.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AppImageFilter {
  final String name;
  final List<double> matrix;

  const AppImageFilter(this.name, this.matrix);

  static const List<AppImageFilter> presets = [
    AppImageFilter('Original', [
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ]),
    AppImageFilter('Grayscale', [
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ]),
    AppImageFilter('Sepia', [
      0.393, 0.769, 0.189, 0, 0,
      0.349, 0.686, 0.168, 0, 0,
      0.272, 0.534, 0.131, 0, 0,
      0,     0,     0,     1, 0,
    ]),
    AppImageFilter('Invert', [
      -1,  0,  0, 0, 255,
       0, -1,  0, 0, 255,
       0,  0, -1, 0, 255,
       0,  0,  0, 1, 0,
    ]),
    AppImageFilter('Vivid', [
      1.2, 0,   0,   0, 0,
      0,   1.2, 0,   0, 0,
      0,   0,   1.2, 0, 0,
      0,   0,   0,   1, 0,
    ]),
  ];
}

class ImageService {
  /// Save image to gallery
  static Future<void> saveToGallery(String path) async {
    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      final granted = await Gal.requestAccess();
      if (!granted) throw Exception('Gallery access denied');
    }
    await Gal.putImage(path);
  }

  /// Apply filter and save as a new file, returns the new path
  static Future<String> applyFilter(String sourcePath, AppImageFilter filter) async {
    if (filter.name == 'Original') return sourcePath;

    final bytes = await File(sourcePath).readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Could not decode image');

    // Apply pixel-level logic for filters that aren't native ColorFiltered
    // For simplicity, we'll implement B&W directly for demonstration
    if (filter.name == 'Grayscale') {
      img.grayscale(image);
    } else if (filter.name == 'Sepia') {
      img.sepia(image);
    } else if (filter.name == 'Invert') {
      img.invert(image);
    } else if (filter.name == 'Vivid') {
      img.contrast(image, contrast: 120);
      img.adjustColor(image, saturation: 1.2);
    }

    final directory = await getTemporaryDirectory();
    final name = p.basenameWithoutExtension(sourcePath);
    final ext = p.extension(sourcePath);
    final newPath = p.join(directory.path, '${name}_${filter.name.toLowerCase()}$ext');
    
    await File(newPath).writeAsBytes(img.encodeJpg(image));
    return newPath;
  }
}
