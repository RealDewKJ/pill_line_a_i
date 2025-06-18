import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pill_line_a_i/features/video_stream/domain/entities/video_stream_entity.dart';

void main() {
  group('VideoStreamEntity', () {
    test('should create VideoStreamEntity with default values', () {
      const entity = VideoStreamEntity();

      expect(entity.isConnected, false);
      expect(entity.isVisible, false);
      expect(entity.scale, 1.0);
      expect(entity.isZoomed, false);
      expect(entity.position, const Offset(16, 16));
      expect(entity.currentFrame, null);
    });

    test('should create VideoStreamEntity with custom values', () {
      final testFrame = Uint8List.fromList([1, 2, 3, 4]);
      final entity = VideoStreamEntity(
        isConnected: true,
        isVisible: true,
        scale: 2.0,
        isZoomed: true,
        position: Offset(100, 200),
        currentFrame: testFrame,
      );

      expect(entity.isConnected, true);
      expect(entity.isVisible, true);
      expect(entity.scale, 2.0);
      expect(entity.isZoomed, true);
      expect(entity.position, const Offset(100, 200));
      expect(entity.currentFrame, testFrame);
    });

    test('copyWith should create new instance with updated values', () {
      const originalEntity = VideoStreamEntity(
        isConnected: false,
        isVisible: false,
        scale: 1.0,
        isZoomed: false,
        position: Offset(16, 16),
      );

      final updatedEntity = originalEntity.copyWith(
        isConnected: true,
        scale: 1.5,
        position: Offset(50, 100),
      );

      expect(updatedEntity.isConnected, true);
      expect(updatedEntity.isVisible, false); // unchanged
      expect(updatedEntity.scale, 1.5);
      expect(updatedEntity.isZoomed, false); // unchanged
      expect(updatedEntity.position, const Offset(50, 100));
      expect(updatedEntity.currentFrame, null); // unchanged
    });

    test('copyWith should keep original values when not specified', () {
      const originalEntity = VideoStreamEntity(
        isConnected: true,
        isVisible: true,
        scale: 2.0,
        isZoomed: true,
        position: Offset(100, 200),
      );

      final updatedEntity = originalEntity.copyWith(
        scale: 1.0,
      );

      expect(updatedEntity.isConnected, true); // unchanged
      expect(updatedEntity.isVisible, true); // unchanged
      expect(updatedEntity.scale, 1.0); // changed
      expect(updatedEntity.isZoomed, true); // unchanged
      expect(updatedEntity.position, const Offset(100, 200)); // unchanged
    });

    test('should handle currentFrame in copyWith', () {
      final testFrame1 = Uint8List.fromList([1, 2, 3]);
      final testFrame2 = Uint8List.fromList([4, 5, 6]);

      final originalEntity = VideoStreamEntity(
        currentFrame: testFrame1,
      );

      final updatedEntity = originalEntity.copyWith(
        currentFrame: testFrame2,
      );

      expect(updatedEntity.currentFrame, testFrame2);
    });
  });
}
