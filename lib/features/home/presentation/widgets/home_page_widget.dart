import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pill_line_a_i/controllers/endpoint_controllers/ehp_pill_conveyor_controller.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/pages/ex_notdata_page.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/widgets/ex_notdata_widget.dart';
import 'package:pill_line_a_i/features/home/presentation/widgets/home_page_model.dart';
import 'package:pill_line_a_i/features/home/presentation/bloc/home_bloc.dart';
import 'package:pill_line_a_i/features/home/presentation/bloc/pill_line_bloc.dart';
import 'package:pill_line_a_i/models/ehp_pill_conveyor_model.dart';
import 'package:pill_line_a_i/models/ovst_pill_line_model.dart';
import 'package:pill_line_a_i/pages/widget/alert_dialog_error/alert_dialog_error_widget.dart';
import 'package:pill_line_a_i/pages/widget/alert_dialog_not_drug_in_list/alert_dialog_not_drug_in_list_widget.dart';
import 'package:pill_line_a_i/pages/widget/alert_dialog_success/alert_dialog_success_widget.dart';
import 'package:pill_line_a_i/pages/widget/alert_dialog_warning/alert_dialog_warning_widget.dart';
import 'package:pill_line_a_i/utils/global_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/app_bar/app_bar_widget.dart';
import '/pages/widget/item_drug/item_drug_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  List<String> messages = [];
  final socketController = serviceLocator<SocketController>();
  bool isConnected = false;
  bool isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePillLine();
      safeSetState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _model.dispose();
    // socketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            // Handle Home BLoC state changes
            if (state is HomeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<PillLineBloc, PillLineState>(
          listener: (context, state) {
            // Handle PillLine BLoC state changes
            if (state is PillLineError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is PillLineNoPatientFound) {
              _handleNoPatientFound(state);
            }

            if (state is PillLineFinished) {
              _handlePillLineFinished(state);
            }
          },
        ),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, homeState) {
          return BlocBuilder<PillLineBloc, PillLineState>(
            builder: (context, pillLineState) {
              // Show loading indicator while either BLoC is loading
              if (homeState is HomeLoading || pillLineState is PillLineLoading) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Show error state if either BLoC has error
              if (homeState is HomeError) {
                return _buildErrorScaffold(homeState.message);
              }

              if (pillLineState is PillLineError) {
                return _buildErrorScaffold(pillLineState.message);
              }

              // Use the original UI for all other states
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) async {
                  if (pillLineState is PillLineLoaded && pillLineState.isLoading) {
                    final shouldPop = await GlobalWidget.showModalMethod(context, const AlertDialogWarningWidget());
                    if (shouldPop) {
                      socketController.dispose();
                      SystemNavigator.pop();
                    } else {
                      return;
                    }
                  } else {
                    // context.pushReplacementNamed('_initialize', extra: <String, dynamic>{
                    //   kTransitionInfoKey: const TransitionInfo(
                    //         hasTransition: true,
                    //         transitionType: PageTransitionType.fade,
                    //         duration: Duration(milliseconds: 0),
                    //       ),
                    // });
                  }
                },
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Scaffold(
                    key: scaffoldKey,
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    body: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              valueOrDefault<double>(
                                () {
                                  if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                                    return 48.0;
                                  } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                                    return 48.0;
                                  } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                                    return 0.0;
                                  } else {
                                    return 0.0;
                                  }
                                }(),
                                0.0,
                              ),
                              0.0,
                              0.0),
                          child: wrapWithModel(
                            model: _model.appBarModel,
                            updateCallback: () => safeSetState(() {}),
                            child: AppBarWidget(
                              ovstPillLine:
                                  pillLineState is PillLineLoaded && pillLineState.pillLines.isNotEmpty ? pillLineState.pillLines.first : null,
                              patientinfo: pillLineState is PillLineLoaded && pillLineState.isLoading,
                              nodata: false,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: const ScrollBehavior().copyWith(overscroll: false),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [const Color(0x00F8F9FA), const Color(0xE6F8F9FA), FlutterFlowTheme.of(context).primaryBackground],
                                  stops: const [0.0, 0.15, 0.2],
                                  begin: const AlignmentDirectional(0.0, -1.0),
                                  end: const AlignmentDirectional(0, 1.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    valueOrDefault<double>(
                                      () {
                                        if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                                          return 12.0;
                                        } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                                          return 12.0;
                                        } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                                          return 16.0;
                                        } else {
                                          return 16.0;
                                        }
                                      }(),
                                      0.0,
                                    ),
                                    0.0,
                                    valueOrDefault<double>(
                                      () {
                                        if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                                          return 12.0;
                                        } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                                          return 12.0;
                                        } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                                          return 16.0;
                                        } else {
                                          return 16.0;
                                        }
                                      }(),
                                      0.0,
                                    ),
                                    0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'รายการยา',
                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                font: GoogleFonts.sarabun(
                                                  fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                ),
                                                fontSize: () {
                                                  if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                                                    return 16.0;
                                                  } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                                                    return 16.0;
                                                  } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                                                    return 18.0;
                                                  } else {
                                                    return 18.0;
                                                  }
                                                }(),
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                              ),
                                        ),
                                        Row(
                                          children: [
                                            if (pillLineState is PillLineLoaded && pillLineState.isLoading)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const CupertinoActivityIndicator(radius: 10),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      'กำลังรอสายพานยา...',
                                                      style: FlutterFlowTheme.of(context).titleMedium.override(
                                                            font: GoogleFonts.sarabun(
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            fontSize: MediaQuery.sizeOf(context).width < kBreakpointSmall ? 16.0 : 18.0,
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            Container(
                                              decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 4.0,
                                                    color: Color(0x336C757D),
                                                    offset: Offset(
                                                      0.0,
                                                      2.0,
                                                    ),
                                                  )
                                                ],
                                                gradient: const LinearGradient(
                                                  colors: [Color(0xFF0099DB), Color(0xFF005483)],
                                                  stops: [0.0, 1.0],
                                                  begin: AlignmentDirectional(0.0, -1.0),
                                                  end: AlignmentDirectional(0, 1.0),
                                                ),
                                                borderRadius: BorderRadius.circular(100.0),
                                                border: Border.all(
                                                  color: const Color(0x7FE9ECEF),
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: pillLineState is PillLineLoaded
                                                  ? _buildPillCountWidget(pillLineState.pillLines)
                                                  : const Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                                                      child: Text('0/0'),
                                                    ),
                                            ),
                                          ].divide(const SizedBox(width: 8.0)),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: pillLineState is PillLineLoaded
                                          ? _buildPillListWidget(pillLineState.pillLines)
                                          : const Center(
                                              child: Text('ไม่มีข้อมูลยา'),
                                            ),
                                    )
                                  ].divide(const SizedBox(height: 12.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorScaffold(String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'เกิดข้อผิดพลาด',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<PillLineBloc>().add(const FetchDrugFromVN());
              },
              child: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillCountWidget(List<OvstPillLine> pillLines) {
    final foundCount = pillLines.where((e) => e.isFound == true).length;
    final totalCount = pillLines.length;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
      child: Text(
        '$foundCount/$totalCount',
        style: FlutterFlowTheme.of(context).titleMedium.override(
              font: GoogleFonts.sarabun(
                fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
              ),
              color: FlutterFlowTheme.of(context).secondaryBackground,
              fontSize: () {
                if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                  return 16.0;
                } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                  return 16.0;
                } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                  return 18.0;
                } else {
                  return 18.0;
                }
              }(),
              letterSpacing: 2.0,
              fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _buildPillListWidget(List<OvstPillLine> pillLines) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 12.0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 24.0),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: pillLines.length,
      itemBuilder: (context, index) {
        final item = pillLines[index];

        Icon iconWidget;
        Color color1;
        Color color2;
        Color? colorbg1;
        Color? colorbg2;
        double iconbg;

        if (item.isFound == true) {
          iconWidget = Icon(
            Icons.check_rounded,
            color: FlutterFlowTheme.of(context).secondary,
            size: 40.0,
          );
          color1 = FlutterFlowTheme.of(context).customColor5;
          color2 = FlutterFlowTheme.of(context).customColor4;
          colorbg1 = FlutterFlowTheme.of(context).customColor7;
          colorbg2 = FlutterFlowTheme.of(context).customColor6;
          iconbg = 1.0;
        } else if (item.isFound == false) {
          iconWidget = Icon(
            Icons.close_rounded,
            color: FlutterFlowTheme.of(context).error,
            size: 40.0,
          );
          color1 = FlutterFlowTheme.of(context).customColor10;
          color2 = FlutterFlowTheme.of(context).customColor9;
          colorbg1 = FlutterFlowTheme.of(context).customColor12;
          colorbg2 = FlutterFlowTheme.of(context).customColor11;
          iconbg = 1.0;
        } else {
          // กรณี null หรืออื่น ๆ
          iconWidget = Icon(
            Icons.circle_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 40.0,
          );
          color1 = FlutterFlowTheme.of(context).customColor2;
          color2 = FlutterFlowTheme.of(context).customColor1;
          colorbg1 = null;
          colorbg2 = null;
          iconbg = 0.1;
        }

        return wrapWithModel(
          model: _model.itemDrugModel1,
          updateCallback: () => safeSetState(() {}),
          child: ItemDrugWidget(
            icode: item.icode ?? '',
            tmt: item.tmtTpCode != null ? 'TMT ${item.tmtTpCode}' : '',
            drugname: '${item.drugName} ${item.strength} ${item.units}',
            icon: iconWidget,
            color1: color1,
            color2: color2,
            colorbg1: colorbg1,
            colorbg2: colorbg2,
            iconbg: iconbg,
          ),
        );
      },
    );
  }

  void _handlePillLineFinished(PillLineFinished state) async {
    bool navigated = false;

    if (!state.hasMissingPills) {
      Future.delayed(const Duration(seconds: 5)).then((_) {
        context.pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.push(ExNotDataPage.routePath);
      });

      final result = await GlobalWidget.showModalMethod(
        context,
        const AlertDialogSuccessWidget(),
      );

      if (result == true && !navigated && mounted) {
        navigated = true;
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.push(ExNotDataPage.routePath);
      }
    } else {
      final missingDrugNames = state.missingDrugNames.join('\n');

      final result = await GlobalWidget.showModalMethod(
        context,
        AlertDialogNotDrugInListWidget(message: '\n$missingDrugNames'),
      );

      if (result) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.push(ExNotDataPage.routePath);
      }
    }
  }

  void _handleNoPatientFound(PillLineNoPatientFound state) async {
    // แสดง dialog แจ้งเตือนว่าไม่พบคนไข้
    final result = await GlobalWidget.showModalMethod(
      context,
      AlertDialogWarningWidget(
        message: 'ไม่พบคนไข้รหัส VN: ${state.vn} ในระบบ\n\nกรุณาตรวจสอบรหัส VN อีกครั้ง',
      ),
    );

    if (result == true && mounted) {
      // ส่งกลับไปหน้า exnotdata
      Navigator.of(context).popUntil((route) => route.isFirst);
      context.push(ExNotDataPage.routePath);
    }
  }

  void _initializePillLine() {
    if (_hasInitialized) {
      log('HomePage: Already initialized, skipping...');
      return;
    }

    final extra = GoRouterState.of(context).extra;
    log('extra: $extra');
    if (extra != null && extra is Map<String, dynamic>) {
      final vn = extra['vn'] as String?;
      if (vn != null) {
        print('HomePage: Received VN from navigation: $vn');
        log('HomePage: Received VN from navigation: $vn');
        context.read<PillLineBloc>().add(FetchDrugFromVN(vn: vn));
        _hasInitialized = true;
        log('HomePage: Initialized with VN: $vn');
      }
    } else {
      log('HomePage: No VN from navigation, calling without VN');
      context.read<PillLineBloc>().add(const FetchDrugFromVN());
      _hasInitialized = true;
    }
  }
}
