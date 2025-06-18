import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/video_stream_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/video_stream_usecase.dart';

class VideoStreamController extends ChangeNotifier {
  final VideoStreamUseCase _useCase;

  VideoStreamEntity _currentState = const VideoStreamEntity();
  StreamSubscription<VideoStreamEntity>? _stateSubscription;
  StreamSubscription<MessageEntity>? _messageSubscription;

  // UI State
  bool _showVideoDialog = false;
  double _currentScale = 1.0;
  bool _isZoomed = false;
  bool _isDragging = false;
  bool _isDraggingFromHandle = false;
  Offset _dragStartPosition = Offset.zero;
  Offset _focalPoint = Offset.zero;
  double _baseScale = 1.0;

  // Position controllers
  final ValueNotifier<double> leftPosition = ValueNotifier(20.0);
  final ValueNotifier<double> bottomPosition = ValueNotifier(16.0);
  final TransformationController transformationController = TransformationController();

  // Animation controller for position bounds
  AnimationController? _animationController;
  late TickerProvider _vsync;

  // Zoom and tap details
  TapDownDetails? _doubleTapDetails;

  // Getters
  bool get showVideoDialog => _showVideoDialog;
  double get currentScale => _currentScale;
  bool get isZoomed => _isZoomed;
  bool get isDragging => _isDragging;
  VideoStreamEntity get currentState => _currentState;
  Stream<Uint8List> get videoFrameStream => _useCase.videoFrameStream;

  VideoStreamController(this._useCase);

  void initialize(TickerProvider vsync) {
    _vsync = vsync;
    _animationController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 300),
    );
    _initializeSubscriptions();
  }

  void _initializeSubscriptions() {
    _stateSubscription = _useCase.videoStreamState.listen((state) {
      _currentState = state;
      notifyListeners();
    });

    _messageSubscription = _useCase.messageStream.listen((message) {
      _handleMessage(message);
    });
  }

  void _handleMessage(MessageEntity message) {
    switch (message.type) {
      case MessageType.drugItemsFetched:
        _handleDrugItemsFetched(message);
        break;
      case MessageType.error:
        _handleError(message);
        break;
      case MessageType.connection:
        _handleConnection(message);
        break;
      default:
        break;
    }
  }

  void _handleDrugItemsFetched(MessageEntity message) {
    // Handle drug items fetched message
    if (message.vn != null) {
      // Navigate to home page or update state
    }
  }

  void _handleError(MessageEntity message) {
    // Handle error message
  }

  void _handleConnection(MessageEntity message) {
    // Handle connection status message
  }

  // Video Dialog Management
  void openVideoDialog() {
    _showVideoDialog = true;
    // Reconnect WebSocket if needed
    initVideoStream();
    notifyListeners();
  }

  void hideVideoDialog() {
    _showVideoDialog = false;
    _useCase.disconnectFromStream();
    notifyListeners();
  }

  void toggleVideoDialog() {
    _showVideoDialog = !_showVideoDialog;
    if (_showVideoDialog) {
      initVideoStream();
    } else {
      _useCase.disconnectFromStream();
    }
    notifyListeners();
  }

  // Socket Management
  void initVideoStream() {
    log('Initializing socket for video stream...');
    _useCase.connectToStream();
  }

  // Position Management
  void updatePosition(double deltaX, double deltaY) {
    leftPosition.value += deltaX;
    bottomPosition.value += deltaY;
  }

  void setDragging(bool dragging) {
    _isDragging = dragging;
    notifyListeners();
  }

  void handlePositionBounds(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const containerWidth = 480.0;
    const containerHeight = containerWidth * 9 / 16;

    const appBarHeight = 170.0;
    const minTopPosition = appBarHeight + 10;

    double targetLeft = leftPosition.value;
    double targetBottom = bottomPosition.value;
    bool needsAnimation = false;

    // ตรวจสอบขอบเขตด้านซ้าย-ขวา
    if (leftPosition.value < 0) {
      targetLeft = 10;
      needsAnimation = true;
    } else if (leftPosition.value + containerWidth > screenWidth) {
      targetLeft = screenWidth - containerWidth - 10;
      needsAnimation = true;
    }

    final currentTopPosition = screenHeight - bottomPosition.value - containerHeight;

    if (currentTopPosition < minTopPosition) {
      targetBottom = screenHeight - minTopPosition - containerHeight;
      needsAnimation = true;
    } else if (bottomPosition.value < 0) {
      targetBottom = 10;
      needsAnimation = true;
    }

    if (needsAnimation) {
      Animation<double> leftAnim = Tween<double>(
        begin: leftPosition.value,
        end: targetLeft,
      ).animate(
        CurvedAnimation(
          parent: _animationController ?? AnimationController(vsync: _vsync),
          curve: Curves.easeOutBack,
        ),
      );

      Animation<double> bottomAnim = Tween<double>(
        begin: bottomPosition.value,
        end: targetBottom,
      ).animate(
        CurvedAnimation(
          parent: _animationController ?? AnimationController(vsync: _vsync),
          curve: Curves.easeOutBack,
        ),
      );

      _animationController?.addListener(() {
        leftPosition.value = leftAnim.value;
        bottomPosition.value = bottomAnim.value;
      });

      _animationController?.reset();
      _animationController?.forward();
    }
  }

  // Zoom and Scale Management
  void handleDoubleTapDown(TapDownDetails details) {
    log('handleDoubleTapDown');
    _doubleTapDetails = details;
  }

  void handleDoubleTap() {
    log('handleDoubleTap');
    if (_doubleTapDetails == null) return;

    if (_isZoomed) {
      resetZoom();
    } else {
      zoomIn();
    }
  }

  void zoomIn() {
    log('zoomIn');
    _currentScale = 2.0;
    _isZoomed = true;
    transformationController.value = Matrix4.identity()..scale(2.0);
    _useCase.updateVideoScale(_currentScale);
    notifyListeners();
  }

  void resetZoom() {
    log('resetZoom');
    _currentScale = 1.0;
    _isZoomed = false;
    transformationController.value = Matrix4.identity();
    _useCase.updateVideoScale(_currentScale);
    notifyListeners();
  }

  void onScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
    _focalPoint = details.localFocalPoint;
    _isDragging = false;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount == 1 && _currentScale <= 1.0) {
      // Handle dragging when not zoomed
      if (!_isDragging) {
        _isDragging = true;
      }
      leftPosition.value += details.focalPointDelta.dx;
      bottomPosition.value -= details.focalPointDelta.dy;
    } else if (details.pointerCount > 1 || _currentScale > 1.0) {
      // Handle zooming
      _isDragging = false;
      double newScale = (_baseScale * details.scale).clamp(1.0, 4.0);

      _currentScale = newScale;
      _isZoomed = _currentScale > 1.0;
      _useCase.updateVideoScale(_currentScale);
      notifyListeners();

      final Offset focalPointDelta = details.localFocalPoint - _focalPoint;
      final double scaleDelta = newScale / _baseScale;

      final Matrix4 matrix = Matrix4.identity()
        ..translate(
          focalPointDelta.dx * (1 - scaleDelta),
          focalPointDelta.dy * (1 - scaleDelta),
        )
        ..scale(newScale);

      transformationController.value = matrix;
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (_currentScale < 1.0) {
      resetZoom();
    }
    _isDragging = false;
  }

  void onHandleDragStart(DragStartDetails details) {
    _isDraggingFromHandle = true;
    _dragStartPosition = details.globalPosition;
  }

  void onHandleDragUpdate(DragUpdateDetails details) {
    if (_isDraggingFromHandle) {
      final delta = details.globalPosition - _dragStartPosition;
      leftPosition.value += delta.dx;
      bottomPosition.value -= delta.dy;
      _dragStartPosition = details.globalPosition;
    }
  }

  void onHandleDragEnd(DragEndDetails details, BuildContext context) {
    _isDraggingFromHandle = false;
    handlePositionBounds(context);
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _messageSubscription?.cancel();
    leftPosition.dispose();
    bottomPosition.dispose();
    transformationController.dispose();
    _animationController?.dispose();
    super.dispose();
  }
}
