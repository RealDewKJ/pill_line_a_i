import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../controllers/video_stream_controller.dart';

class VideoStreamWidget extends StatelessWidget {
  final VideoStreamController controller;
  final double videoWidth;
  final double videoHeight;

  const VideoStreamWidget({
    super.key,
    required this.controller,
    this.videoWidth = 480.0,
    this.videoHeight = 270.0,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: controller.leftPosition,
      builder: (context, left, _) {
        return ValueListenableBuilder<double>(
          valueListenable: controller.bottomPosition,
          builder: (context, bottom, _) {
            return Positioned(
              left: left,
              bottom: bottom,
              child: Container(
                width: videoWidth,
                height: videoHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Video frame
                    _buildVideoFrame(),
                    // Controls overlay
                    _buildControlsOverlay(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoFrame() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: StreamBuilder<Uint8List>(
        stream: controller.videoFrameStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildInteractiveVideo(snapshot.data!);
          } else {
            return _buildLoadingIndicator();
          }
        },
      ),
    );
  }

  Widget _buildInteractiveVideo(Uint8List frameData) {
    return Builder(
      builder: (context) {
        return RawGestureDetector(
          gestures: <Type, GestureRecognizerFactory>{
            PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
              () => PanGestureRecognizer(),
              (PanGestureRecognizer instance) {
                instance.onStart = (details) {
                  if (controller.currentScale <= 1.0) {
                    controller.setDragging(true);
                  }
                };
                instance.onUpdate = (details) {
                  if (controller.currentScale <= 1.0 && controller.isDragging) {
                    controller.updatePosition(details.delta.dx, -details.delta.dy);
                  }
                };
                instance.onEnd = (details) {
                  if (controller.currentScale <= 1.0) {
                    controller.handlePositionBounds(context);
                  }
                  controller.setDragging(false);
                };
              },
            ),
            ScaleGestureRecognizer: GestureRecognizerFactoryWithHandlers<ScaleGestureRecognizer>(
              () => ScaleGestureRecognizer(),
              (ScaleGestureRecognizer instance) {
                instance.onStart = controller.onScaleStart;
                instance.onUpdate = controller.onScaleUpdate;
                instance.onEnd = controller.onScaleEnd;
              },
            ),
            DoubleTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
              () => DoubleTapGestureRecognizer(),
              (DoubleTapGestureRecognizer instance) {
                instance.onDoubleTapDown = controller.handleDoubleTapDown;
                instance.onDoubleTap = controller.handleDoubleTap;
              },
            ),
          },
          child: InteractiveViewer(
            transformationController: controller.transformationController,
            minScale: 1.0,
            maxScale: 4.0,
            panEnabled: controller.currentScale > 1.0,
            scaleEnabled: false,
            child: Image.memory(
              frameData,
              gaplessPlayback: true,
              cacheWidth: (480 * 2).toInt(),
              cacheHeight: (270 * 2).toInt(),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            'Connecting to stream...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Drag handle
          _buildDragHandle(),
          // Close button
          _buildCloseButton(),
          // Zoom controls
          _buildZoomControls(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Builder(
      builder: (context) {
        return Positioned(
          top: 8,
          left: 8,
          child: GestureDetector(
            onPanStart: controller.onHandleDragStart,
            onPanUpdate: controller.onHandleDragUpdate,
            onPanEnd: (details) => controller.onHandleDragEnd(details, context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.drag_indicator,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
          onPressed: controller.hideVideoDialog,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scale indicator
          if (controller.currentScale > 1.0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.currentScale.toStringAsFixed(1)}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (controller.currentScale > 1.0) const SizedBox(width: 8),
          // Zoom toggle button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                controller.isZoomed ? Icons.zoom_out : Icons.zoom_in,
                color: Colors.white,
              ),
              onPressed: controller.isZoomed ? controller.resetZoom : controller.zoomIn,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
