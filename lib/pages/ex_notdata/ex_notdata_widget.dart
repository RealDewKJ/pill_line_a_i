import 'dart:developer';
import 'dart:typed_data';

import 'package:pill_line_a_i/controllers/pill_line_controller.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';
import 'package:pill_line_a_i/pages/widget/video_stream_dialog.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/app_bar/app_bar_widget.dart';
import '/pages/widget/no_data/no_data_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'ex_notdata_model.dart';
export 'ex_notdata_model.dart';

class ExNotdataWidget extends StatefulWidget {
  const ExNotdataWidget({super.key});

  static String routeName = 'Ex_notdata';
  static String routePath = '/exNotdata';

  @override
  State<ExNotdataWidget> createState() => _ExNotdataWidgetState();
}

class _ExNotdataWidgetState extends State<ExNotdataWidget> with SingleTickerProviderStateMixin {
  late ExNotdataModel _model;
  final socketController = serviceLocator<SocketController>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pillLineController = serviceLocator<PillLineController>();
  bool showVideoDialog = false;
  late VideoFrameController videoFrameController;
  late AnimationController animationController;

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
        setState(() {});
      },
    );

    // Show video dialog when socket is connected
    socketController.videoFrameStream.listen((_) {
      if (!showVideoDialog) {
        setState(() {
          showVideoDialog = true;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    animationController.dispose();
    videoFrameController.dispose();
    super.dispose();
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

  String? extractVNFromMessage(String msg, String prefix) {
    if (msg.contains(prefix)) {
      return msg.substring(msg.indexOf(prefix) + prefix.length).trim();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final videoWidth = 480.0;
    final videoHeight = videoWidth * 9 / 16;

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
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

          // Draggable Video Stream
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
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          videoFrameController.leftPosition.value += details.delta.dx;
                          videoFrameController.bottomPosition.value -= details.delta.dy;
                        },
                        onPanEnd: (details) {
                          videoFrameController.handlePositionBounds(context);
                        },
                        child: Container(
                          width: videoWidth,
                          height: videoHeight,
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                StreamBuilder<Uint8List>(
                                  stream: socketController.videoFrameStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        gaplessPlayback: true,
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
                                // Close button
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showVideoDialog = false;
                                        });
                                      },
                                      padding: const EdgeInsets.all(8),
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                ),
                                // Drag handle
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.drag_indicator,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
