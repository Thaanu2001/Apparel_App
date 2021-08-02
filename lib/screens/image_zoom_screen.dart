import 'dart:ui';
import 'package:flutter/material.dart';

//* Image Zoom Page -----------------------------------------------------------------------------------------
// ignore: must_be_immutable
class ImageZoom extends StatelessWidget {
  final imageLink;
  final detailedHeroId;
  ImageZoom({required this.imageLink, required this.detailedHeroId});

  final _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            //* Image -------------------------------------------------------------------------------
            GestureDetector(
              child: Center(
                child: Hero(
                  tag: detailedHeroId,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    panEnabled: true,
                    minScale: 1,
                    maxScale: 2,
                    child: Image.network(
                      imageLink,
                    ),
                  ),
                ),
              ),
              onDoubleTapDown: _handleDoubleTapDown,
              onDoubleTap: _handleDoubleTap,
            ),
            //* Close button --------------------------------------------------------------------------
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              alignment: Alignment.topRight,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  //* Double tab to zoom image
  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        //   ..translate(-position.dx * 2, -position.dy * 2)
        //   ..scale(2.0);
        //
        // Fox a 2x zoom
        ..translate(-position.dx - 50, -position.dy / 2)
        ..scale(2.0);
    }
  }
}
