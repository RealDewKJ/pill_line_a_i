import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pill_line_a_i/features/video_stream/presentation/controllers/video_stream_controller.dart';
import 'package:pill_line_a_i/features/video_stream/presentation/widgets/video_stream_widget.dart';
import 'package:pill_line_a_i/features/video_stream/presentation/widgets/reopen_video_button.dart';
import '/pages/widget/app_bar/app_bar_widget.dart';
import '/pages/widget/no_data/no_data_widget.dart';
import '/index.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:pill_line_a_i/features/video_stream/core/di/video_stream_di.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/bloc/ex_notdata_bloc.dart';
import 'dart:async';

class ExNotDataWidget extends StatefulWidget {
  const ExNotDataWidget({super.key});

  @override
  State<ExNotDataWidget> createState() => _ExNotDataWidgetState();
}

class _ExNotDataWidgetState extends State<ExNotDataWidget> with SingleTickerProviderStateMixin {
  late final VideoStreamController _videoController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _errorTimer;

  @override
  void initState() {
    super.initState();
    log('ExNotDataWidget: initState');
    final usecase = VideoStreamDI.getVideoStreamUseCase();

    _videoController = VideoStreamController(usecase);
    _videoController.initialize(this);
    _videoController.addListener(_handleNavigation);

    // Set navigation callback for ExNotDataBloc
    final exNotDataBloc = context.read<ExNotDataBloc>();
    exNotDataBloc.add(SetNavigationCallback((route, arguments) {
      print('Navigation callback triggered: $route with arguments: $arguments');
      // Handle navigation here using GoRouter
      if (route == '/home' && arguments != null) {
        final vn = arguments['vn'] as String?;
        if (vn != null) {
          print('Navigating to homepage with VN: $vn');
          // Stop WebSocket before navigating
          exNotDataBloc.add(StopWebSocket());

          // Navigate to homepage with vn using GoRouter
          context.pushNamed('home', extra: {'vn': vn});
        }
      }
    }));

    // Initialize WebSocket
    exNotDataBloc.add(InitializeWebSocket());
  }

  void _handleNavigation() {
    // ตัวอย่าง: ถ้า controller มี state ที่ต้องการ navigation
    // if (_videoController.currentState.vn != null) {
    //   Navigator.pushNamed(context, HomePageWidget.routeName);
    // }
    // สามารถปรับ logic นี้ตาม business จริง
  }

  String _getStatusMessage(ExNotDataState state) {
    if (state is ExNotDataWebSocketConnecting) {
      return 'กำลังเชื่อมต่อ WebSocket...';
    } else if (state is ExNotDataWebSocketReconnecting) {
      return 'กำลังเชื่อมต่อใหม่ (${state.attempt}/${state.maxAttempts})...';
    } else if (state is ExNotDataWebSocketConnected) {
      return 'เชื่อมต่อ WebSocket สำเร็จ';
    } else if (state is ExNotDataWebSocketDisconnected) {
      return 'WebSocket ถูกหยุดการทำงาน';
    } else if (state is ExNotDataError) {
      return 'เกิดข้อผิดพลาด: ${state.message}';
    }
    return '';
  }

  Color _getStatusColor(ExNotDataState state) {
    if (state is ExNotDataWebSocketConnected) {
      return Colors.green;
    } else if (state is ExNotDataWebSocketConnecting || state is ExNotDataWebSocketReconnecting) {
      return Colors.orange;
    } else if (state is ExNotDataWebSocketDisconnected || state is ExNotDataError) {
      return Colors.red;
    }
    return Colors.grey;
  }

  @override
  void dispose() {
    // Cancel timers
    _errorTimer?.cancel();

    // Stop WebSocket when leaving the page
    final exNotDataBloc = context.read<ExNotDataBloc>();
    exNotDataBloc.add(DisconnectWebSocket());

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
      body: BlocListener<ExNotDataBloc, ExNotDataState>(
        listenWhen: (previous, current) {
          if (previous.runtimeType != current.runtimeType) return true;

          if (current is ExNotDataError) return true;

          if (previous is ExNotDataLoading && current is ExNotDataLoading) return false;
          if (previous is ExNotDataWebSocketConnecting && current is ExNotDataWebSocketConnecting) return false;
          if (previous is ExNotDataWebSocketReconnecting && current is ExNotDataWebSocketReconnecting) {
            return previous.attempt != current.attempt;
          }

          return false;
        },
        listener: (context, state) {
          // Handle error states with debouncing
          if (state is ExNotDataError) {
            // Cancel any existing error timer
            _errorTimer?.cancel();

            _errorTimer = Timer(Duration(milliseconds: 500), () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'ลองใหม่',
                      textColor: Colors.white,
                      onPressed: () {
                        context.read<ExNotDataBloc>().add(ReconnectWebSocket());
                      },
                    ),
                  ),
                );
              }
            });
          }
        },
        child: BlocBuilder<ExNotDataBloc, ExNotDataState>(
          buildWhen: (previous, current) {
            // Only rebuild when status actually changes
            if (previous.runtimeType != current.runtimeType) return true;

            // For reconnecting state, only rebuild when attempt changes
            if (previous is ExNotDataWebSocketReconnecting && current is ExNotDataWebSocketReconnecting) {
              return previous.attempt != current.attempt;
            }

            // For connected state, only rebuild when data changes
            if (previous is ExNotDataWebSocketConnected && current is ExNotDataWebSocketConnected) {
              return previous.data?.message != current.data?.message || previous.data?.type != current.data?.type;
            }

            return false;
          },
          builder: (context, state) {
            return Column(
              children: [
                // Status indicator - only show when not initial
                if (state is! ExNotDataInitial)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: _getStatusColor(state).withOpacity(0.1),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(state),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getStatusMessage(state),
                            style: TextStyle(
                              color: _getStatusColor(state),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (state is ExNotDataWebSocketDisconnected || state is ExNotDataError)
                          TextButton(
                            onPressed: () {
                              context.read<ExNotDataBloc>().add(ReconnectWebSocket());
                            },
                            child: Text(
                              'เชื่อมต่อใหม่',
                              style: TextStyle(
                                color: _getStatusColor(state),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (state is ExNotDataWebSocketConnected)
                          TextButton(
                            onPressed: () {
                              context.read<ExNotDataBloc>().add(StopWebSocket());
                            },
                            child: Text(
                              'หยุดการทำงาน',
                              style: TextStyle(
                                color: _getStatusColor(state),
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                // Main content - use ListenableBuilder to avoid unnecessary rebuilds
                Expanded(
                  child: ListenableBuilder(
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
