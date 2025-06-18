import 'dart:typed_data';
import 'dart:ui';

class VideoStreamEntity {
  final bool isConnected;
  final bool isVisible;
  final double scale;
  final bool isZoomed;
  final Offset position;
  final Uint8List? currentFrame;

  const VideoStreamEntity({
    this.isConnected = false,
    this.isVisible = false,
    this.scale = 1.0,
    this.isZoomed = false,
    this.position = const Offset(16, 16),
    this.currentFrame,
  });

  VideoStreamEntity copyWith({
    bool? isConnected,
    bool? isVisible,
    double? scale,
    bool? isZoomed,
    Offset? position,
    Uint8List? currentFrame,
  }) {
    return VideoStreamEntity(
      isConnected: isConnected ?? this.isConnected,
      isVisible: isVisible ?? this.isVisible,
      scale: scale ?? this.scale,
      isZoomed: isZoomed ?? this.isZoomed,
      position: position ?? this.position,
      currentFrame: currentFrame ?? this.currentFrame,
    );
  }
}
