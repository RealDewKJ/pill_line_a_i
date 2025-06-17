import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:pill_line_a_i/controllers/pill_line_controller.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/widgets/ex_notdata_model.dart';
import 'package:pill_line_a_i/features/home/presentation/widgets/home_page_widget.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';
import 'package:pill_line_a_i/pages/widget/video_stream_dialog.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/app_bar/app_bar_widget.dart';
import '/pages/widget/no_data/no_data_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';

class ExNotDataWidget extends StatefulWidget {
  const ExNotDataWidget({super.key});

  static String routeName = 'Ex_notdata';
  static String routePath = '/exNotdata';

  @override
  State<ExNotDataWidget> createState() => _ExNotDataWidgetState();
}

class _ExNotDataWidgetState extends State<ExNotDataWidget> with SingleTickerProviderStateMixin {
  late ExNotdataModel _model;
  final socketController = serviceLocator<SocketController>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pillLineController = serviceLocator<PillLineController>();
  bool showVideoDialog = false;
  late VideoFrameController videoFrameController;
  late AnimationController animationController;

  // Enhanced zoom control variables
  final TransformationController _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  bool _isZoomed = false;
  StreamSubscription<Uint8List>? _videoStreamSubscription;

  // Variables for smooth pinch-to-zoom
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  Offset _focalPoint = Offset.zero;
  bool _isDragging = false;

  // Add new variables for drag handle
  bool _isDraggingFromHandle = false;
  Offset _dragStartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExNotdataModel());

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    videoFrameController = VideoFrameController(
      animationController: animationController,
    );

    socketController.configure(
      context: context,
      onMessage: (msg) {
        if (msg.contains('Fetched drugitems for VN:')) {
          handleFetchedDrugitemsMessage(msg);
        }
      },
      onConnectionStatusChanged: (status) {
        if (mounted) {
          setState(() {});
        }
      },
    );

    _videoStreamSubscription = socketController.videoFrameStream.listen((_) {
      if (!showVideoDialog && mounted) {
        setState(() {
          showVideoDialog = true;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        safeSetState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    animationController.dispose();
    videoFrameController.dispose();
    _transformationController.dispose();
    _videoStreamSubscription?.cancel();
    super.dispose();
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
      videoFrameController.leftPosition.value += details.focalPointDelta.dx;
      videoFrameController.bottomPosition.value -= details.focalPointDelta.dy;
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
  }

  void _resetZoom() {
    setState(() {
      _transformationController.value = Matrix4.identity();
      _currentScale = 1.0;
      _isZoomed = false;
    });
  }

  void handleVideoDialogClose() {
    if (mounted) {
      setState(() {
        showVideoDialog = false;
      });
    }
    socketController.disconnect();
  }

  handleFetchedDrugitemsMessage(msg) async {
    const prefix = 'Fetched drugitems for VN:';
    pillLineController.vn = extractVNFromMessage(msg, prefix) ?? '';
    log('VN: ${pillLineController.vn}');
    if (pillLineController.vn.isEmpty) {
      log('VN not found in message.');
      return;
    }
    pillLineController.pillLine = [];
    if (mounted) {
      context.pushNamed(
        HomePageWidget.routeName,
        extra: <String, dynamic>{
          kTransitionInfoKey: const TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
            duration: Duration(milliseconds: 0),
          ),
        },
      );
    }
  }

  String? extractVNFromMessage(String msg, String prefix) {
    if (msg.contains(prefix)) {
      return msg.substring(msg.indexOf(prefix) + prefix.length).trim();
    }
    return null;
  }

  // Add new method for handle drag
  void _onHandleDragStart(DragStartDetails details) {
    _isDraggingFromHandle = true;
    _dragStartPosition = details.globalPosition;
  }

  void _onHandleDragUpdate(DragUpdateDetails details) {
    if (_isDraggingFromHandle) {
      final delta = details.globalPosition - _dragStartPosition;
      videoFrameController.leftPosition.value += delta.dx;
      videoFrameController.bottomPosition.value -= delta.dy;
      _dragStartPosition = details.globalPosition;
    }
  }

  void _onHandleDragEnd(DragEndDetails details) {
    _isDraggingFromHandle = false;
    videoFrameController.handlePositionBounds(context);
  }

  // Add new method to handle reopening video stream
  void _handleReopenVideo() {
    if (mounted) {
      setState(() {
        showVideoDialog = true;
      });
      // Reconnect WebSocket if needed
      socketController.initSocket();
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoWidth = 480.0;
    final videoHeight = videoWidth * 9 / 16;

    return Scaffold(
      key: scaffoldKey,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBarWidget(
          nodata: true,
        ),
      ),
      body: Stack(
        children: [
          // No Data Widget (Full Width)
          const Center(
            child: NoDataWidget(),
          ),

          // Reopen video button (when video is closed)
          if (!showVideoDialog)
            Positioned(
              left: 16,
              bottom: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleReopenVideo,
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.videocam,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Real Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Draggable Video Stream with Enhanced Zoom
          if (showVideoDialog)
            ValueListenableBuilder<double>(
              valueListenable: videoFrameController.leftPosition,
              builder: (context, left, _) {
                return ValueListenableBuilder<double>(
                  valueListenable: videoFrameController.bottomPosition,
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
                            // Video frame at the bottom
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: StreamBuilder<Uint8List>(
                                stream: socketController.videoFrameStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return RawGestureDetector(
                                      gestures: <Type, GestureRecognizerFactory>{
                                        PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
                                          () => PanGestureRecognizer(),
                                          (PanGestureRecognizer instance) {
                                            instance.onStart = (details) {
                                              if (_currentScale <= 1.0) {
                                                _isDragging = true;
                                              }
                                            };
                                            instance.onUpdate = (details) {
                                              if (_currentScale <= 1.0 && _isDragging) {
                                                videoFrameController.leftPosition.value += details.delta.dx;
                                                videoFrameController.bottomPosition.value -= details.delta.dy;
                                              }
                                            };
                                            instance.onEnd = (details) {
                                              if (_currentScale <= 1.0) {
                                                videoFrameController.handlePositionBounds(context);
                                              }
                                              _isDragging = false;
                                            };
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
                                        child: Image.memory(
                                          snapshot.data!,
                                          gaplessPlayback: true,
                                          cacheWidth: (MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio).toInt(),
                                          cacheHeight: (MediaQuery.of(context).size.height * MediaQuery.of(context).devicePixelRatio).toInt(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  } else {
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
                                },
                              ),
                            ),
                            // Controls overlay on top
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
                                        onPressed: handleVideoDialogClose,
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
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
