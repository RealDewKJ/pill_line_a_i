import 'package:flutter/material.dart';
import 'package:pill_line_a_i/features/video_stream/presentation/controllers/video_stream_controller.dart';
import 'package:pill_line_a_i/features/video_stream/presentation/widgets/video_stream_widget.dart';
import 'package:pill_line_a_i/features/video_stream/presentation/widgets/reopen_video_button.dart';
import '/pages/widget/app_bar/app_bar_widget.dart';
import '/pages/widget/no_data/no_data_widget.dart';
import '/index.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:pill_line_a_i/features/video_stream/core/di/video_stream_di.dart';
import 'package:pill_line_a_i/controllers/pill_line_controller.dart';

class ExNotDataWidget extends StatefulWidget {
  const ExNotDataWidget({super.key});

  static String routeName = 'Ex_notdata';
  static String routePath = '/exNotdata';

  @override
  State<ExNotDataWidget> createState() => _ExNotDataWidgetState();
}

class _ExNotDataWidgetState extends State<ExNotDataWidget> with SingleTickerProviderStateMixin {
  late final VideoStreamController _videoController;
  final pillLineController = serviceLocator<PillLineController>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final usecase = VideoStreamDI.getVideoStreamUseCase();

    _videoController = VideoStreamController(usecase);
    _videoController.initialize(this);
    _videoController.addListener(_handleNavigation);
  }

  void _handleNavigation() {
    // ตัวอย่าง: ถ้า controller มี state ที่ต้องการ navigation
    // if (_videoController.currentState.vn != null) {
    //   Navigator.pushNamed(context, HomePageWidget.routeName);
    // }
    // สามารถปรับ logic นี้ตาม business จริง
  }

  @override
  void dispose() {
    _videoController.removeListener(_handleNavigation);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBarWidget(nodata: true),
      ),
      body: ListenableBuilder(
        listenable: _videoController,
        builder: (context, child) {
          return Stack(
            children: [
              const Center(child: NoDataWidget()),
              if (!_videoController.showVideoDialog) ReopenVideoButton(controller: _videoController),
              if (_videoController.showVideoDialog) VideoStreamWidget(controller: _videoController),
            ],
          );
        },
      ),
    );
  }
}
