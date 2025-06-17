import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';

class VideoStreamDialog extends StatefulWidget {
  final VoidCallback onClose;
  final VideoFrameController videoFrameController;

  const VideoStreamDialog({
    Key? key,
    required this.onClose,
    required this.videoFrameController,
  }) : super(key: key);

  @override
  State<VideoStreamDialog> createState() => _VideoStreamDialogState();
}

class _VideoStreamDialogState extends State<VideoStreamDialog> {
  final socketController = serviceLocator<SocketController>();
  final TransformationController _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  bool _isZoomed = false;

  // Variables for smooth pinch-to-zoom
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  Offset _focalPoint = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _currentScale = 1.0;
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_doubleTapDetails == null) return;

    if (_isZoomed) {
      _resetZoom();
    } else {
      // Zoom in at tap point
      final Matrix4 zoomedMatrix = Matrix4.identity()
        ..translate(-_doubleTapDetails!.localPosition.dx, -_doubleTapDetails!.localPosition.dy)
        ..scale(2.0)
        ..translate(_doubleTapDetails!.localPosition.dx, _doubleTapDetails!.localPosition.dy);
      _transformationController.value = zoomedMatrix;
      _currentScale = 2.0;
      _isZoomed = true;
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
    _focalPoint = details.localFocalPoint;
    _isDragging = false;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount == 1 && _currentScale <= 1.0) {
      // Handle dragging when not zoomed
      if (!_isDragging) {
        _isDragging = true;
      }
      widget.videoFrameController.leftPosition.value += details.focalPointDelta.dx;
      widget.videoFrameController.bottomPosition.value -= details.focalPointDelta.dy;
    } else if (details.pointerCount > 1 || _currentScale > 1.0) {
      // Handle zooming
      _isDragging = false;
      double newScale = (_baseScale * details.scale).clamp(1.0, 4.0);

      setState(() {
        _currentScale = newScale;
        _isZoomed = _currentScale > 1.0;
      });

      final Offset focalPointDelta = details.localFocalPoint - _focalPoint;
      final double scaleDelta = newScale / _baseScale;

      final Matrix4 matrix = Matrix4.identity()
        ..translate(
          focalPointDelta.dx * (1 - scaleDelta),
          focalPointDelta.dy * (1 - scaleDelta),
        )
        ..scale(newScale);

      _transformationController.value = matrix;
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    if (_currentScale < 1.0) {
      _resetZoom();
    }
    _isDragging = false;
    widget.videoFrameController.handlePositionBounds(context);
  }

  void _resetZoom() {
    setState(() {
      _transformationController.value = Matrix4.identity();
      _currentScale = 1.0;
      _isZoomed = false;
    });
  }

  void _onHandleDragStart(DragStartDetails details) {
    _isDragging = true;
  }

  void _onHandleDragUpdate(DragUpdateDetails details) {
    if (_isDragging) {
      widget.videoFrameController.leftPosition.value += details.delta.dx;
      widget.videoFrameController.bottomPosition.value -= details.delta.dy;
    }
  }

  void _onHandleDragEnd(DragEndDetails details) {
    _isDragging = false;
    widget.videoFrameController.handlePositionBounds(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.width * 0.85 * 9 / 16,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Video frame
            StreamBuilder<Uint8List>(
              stream: socketController.videoFrameStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RawGestureDetector(
                    gestures: <Type, GestureRecognizerFactory>{
                      PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
                        () => PanGestureRecognizer(),
                        (PanGestureRecognizer instance) {
                          instance.onStart = (DragStartDetails details) {
                            if (_currentScale <= 1.0) {
                              _isDragging = true;
                            }
                          };
                          instance.onUpdate = (details) {
                            if (_currentScale <= 1.0) {
                              _onHandleDragUpdate(details);
                            }
                          };
                          instance.onEnd = _onHandleDragEnd;
                        },
                      ),
                      ScaleGestureRecognizer: GestureRecognizerFactoryWithHandlers<ScaleGestureRecognizer>(
                        () => ScaleGestureRecognizer(),
                        (ScaleGestureRecognizer instance) {
                          instance.onStart = _onScaleStart;
                          instance.onUpdate = _onScaleUpdate;
                          instance.onEnd = _onScaleEnd;
                        },
                      ),
                      DoubleTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
                        () => DoubleTapGestureRecognizer(),
                        (DoubleTapGestureRecognizer instance) {
                          instance.onDoubleTapDown = _handleDoubleTapDown;
                          instance.onDoubleTap = _handleDoubleTap;
                        },
                      ),
                    },
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      minScale: 1.0,
                      maxScale: 4.0,
                      panEnabled: _currentScale > 1.0,
                      scaleEnabled: false,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Connecting to stream...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Controls overlay
            Positioned.fill(
              child: Stack(
                children: [
                  // Drag handle in top-left corner
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onPanStart: _onHandleDragStart,
                      onPanUpdate: _onHandleDragUpdate,
                      onPanEnd: _onHandleDragEnd,
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
                  ),
                  // Close button in top-right corner
                  Positioned(
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
                        onPressed: () {
                          socketController.disconnect();
                          widget.onClose();
                        },
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                  // Zoom controls and scale indicator
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Scale indicator
                        if (_currentScale > 1.0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_currentScale.toStringAsFixed(1)}x',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (_currentScale > 1.0) const SizedBox(width: 8),
                        // Zoom toggle button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isZoomed ? Icons.zoom_out : Icons.zoom_in,
                              color: Colors.white,
                            ),
                            onPressed: _isZoomed
                                ? _resetZoom
                                : () {
                                    _transformationController.value = Matrix4.identity()..scale(2.0);
                                    setState(() {
                                      _currentScale = 2.0;
                                      _isZoomed = true;
                                    });
                                  },
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
