import 'dart:io';
import 'package:flutter/material.dart';
import '../services/data_service.dart';
import 'layout_constants.dart';

class CachedImageWidget extends StatefulWidget {
  final int id;
  final String? heroTag;

  const CachedImageWidget({super.key, required this.id, this.heroTag});

  @override
  State<CachedImageWidget> createState() => _CachedImageWidgetState();
}

class _CachedImageWidgetState extends State<CachedImageWidget> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _findImageFile();
  }

  Future<void> _findImageFile() async {
    final imagePath = DataService.imagePath;

    // Return early if image path is not set
    if (imagePath == null) {
      return;
    }

    final jpg = File('$imagePath/${widget.id}.jpg');
    final jpeg = File('$imagePath/${widget.id}.jpeg');

    if (await jpg.exists()) {
      setState(() {
        _imageFile = jpg;
      });
    } else if (await jpeg.exists()) {
      setState(() {
        _imageFile = jpeg;
      });
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[900],
      child: const Center(
        child: Text("Không có ảnh", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_imageFile == null) {
      return _buildErrorWidget();
    }

    final imageWidget = Image.file(
      _imageFile!,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.fitHeight,
      cacheWidth: _calculateMemCacheWidth(context),
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image load error for ${widget.id}: $error');
        return _buildErrorWidget();
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: LayoutConstants.imageAnimationDuration,
          curve: Curves.easeOut,
          child: child,
        );
      },
    );

    if (widget.heroTag != null) {
      return Hero(tag: widget.heroTag!, child: imageWidget);
    }

    return imageWidget;
  }

  /// Calculate optimal memory cache width based on screen size
  int? _calculateMemCacheWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Cache at 2x screen resolution for sharpness
    return (screenWidth * 2).round();
  }
}
