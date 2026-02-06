import 'dart:io';
import 'package:flutter/material.dart';
import '../services/data_service.dart';

class ImageDisplayWidget extends StatelessWidget {
  final int id;
  final String? heroTag;

  const ImageDisplayWidget({super.key, required this.id, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final imageWidget = _buildImage();

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildImage() {
    final jpg = File('${DataService.imagePath}/$id.jpg');
    final jpeg = File('${DataService.imagePath}/$id.jpeg');

    if (jpg.existsSync()) {
      return Image.file(
        jpg,
        fit: BoxFit.fitHeight,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: const Center(
              child: Text(
                "Không có ảnh",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    } else if (jpeg.existsSync()) {
      return Image.file(
        jpeg,
        fit: BoxFit.fitHeight,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: const Center(
              child: Text(
                "Không có ảnh",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[900],
        child: const Center(
          child: Text("Không có ảnh", style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }
}
