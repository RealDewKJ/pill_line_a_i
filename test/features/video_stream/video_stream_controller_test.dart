import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:pill_line_a_i/features/video_stream/domain/entities/video_stream_entity.dart';
import 'package:pill_line_a_i/features/video_stream/domain/entities/message_entity.dart';
import 'package:pill_line_a_i/features/video_stream/domain/usecases/video_stream_usecase.dart';
import 'package:pill_line_a_i/features/video_stream/presentation/controllers/video_stream_controller.dart';

import 'video_stream_controller_test.mocks.dart';

@GenerateMocks([VideoStreamUseCase])
void main() {
  group('VideoStreamController', () {
    late MockVideoStreamUseCase mockUseCase;
    late VideoStreamController controller;
    late TestWidgetsFlutterBinding binding;

    setUp(() {
      binding = TestWidgetsFlutterBinding.ensureInitialized();
      mockUseCase = MockVideoStreamUseCase();
      controller = VideoStreamController(mockUseCase);
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state should be correct', () {
      expect(controller.showVideoDialog, false);
      expect(controller.currentScale, 1.0);
      expect(controller.isZoomed, false);
      expect(controller.isDragging, false);
      expect(controller.currentState, isA<VideoStreamEntity>());
    });

    group('Video Dialog Management', () {
      test('openVideoDialog should set showVideoDialog to true', () {
        controller.openVideoDialog();
        expect(controller.showVideoDialog, true);
      });

      test('hideVideoDialog should set showVideoDialog to false', () {
        controller.openVideoDialog();
        controller.hideVideoDialog();
        expect(controller.showVideoDialog, false);
      });

      test('toggleVideoDialog should toggle showVideoDialog', () {
        expect(controller.showVideoDialog, false);

        controller.toggleVideoDialog();
        expect(controller.showVideoDialog, true);

        controller.toggleVideoDialog();
        expect(controller.showVideoDialog, false);
      });
    });

    group('Position Management', () {
      test('updatePosition should update left and bottom positions', () {
        final initialLeft = controller.leftPosition.value;
        final initialBottom = controller.bottomPosition.value;

        controller.updatePosition(10.0, 20.0);

        expect(controller.leftPosition.value, initialLeft + 10.0);
        expect(controller.bottomPosition.value, initialBottom + 20.0);
      });

      test('setDragging should update isDragging state', () {
        expect(controller.isDragging, false);

        controller.setDragging(true);
        expect(controller.isDragging, true);

        controller.setDragging(false);
        expect(controller.isDragging, false);
      });
    });

    group('Socket Management', () {
      test('initVideoStream should call useCase.connectToStream', () {
        controller.initVideoStream();
        verify(mockUseCase.connectToStream()).called(1);
      });
    });
  });
}
