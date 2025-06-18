import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pill_line_a_i/controllers/endpoint_controllers/ehp_pill_conveyor_controller.dart';
import 'package:pill_line_a_i/controllers/pill_line_controller.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/widgets/ex_notdata_widget.dart';
import 'package:pill_line_a_i/features/home/presentation/widgets/home_page_model.dart';
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
  final pillLineController = serviceLocator<PillLineController>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    fetchDrugFormVN();
    socketController.configure(
      context: context,
      onMessage: (msg) {
        if (msg.contains('Changed status for VN:')) {
          handleChangedStatusMessage(msg);
        }
        if (msg.contains('Finished for VN:')) {
          handleFinishedMessage(msg);
        }
      },
      onConnectionStatusChanged: (status) {
        setState(() {
          isConnected = status;
        });
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    // socketController.dispose();
    super.dispose();
  }

  void handleChangedStatusMessage(String msg) async {
    log('msg: $msg');

    try {
      // ดึง VN ด้วย RegExp
      final vnMatch = RegExp(r'VN:\s*(\d+)').firstMatch(msg);
      if (vnMatch == null) return;
      final vnValue = vnMatch.group(1)!;

      // ดึง Drug JSON string
      final drugDataStart = msg.indexOf('Drug: ');
      if (drugDataStart == -1) return;

      final drugStr = msg.substring(drugDataStart + 6).trim();

      var cleanStr = drugStr;
      if (cleanStr.startsWith('{') && cleanStr.endsWith('}')) {
        cleanStr = cleanStr.substring(1, cleanStr.length - 1);
      }

      final parts = cleanStr.split(RegExp(r', (?=[a-zA-Z0-9_]+:)'));

      final Map<String, String> map = {};
      for (var part in parts) {
        final idx = part.indexOf(':');
        if (idx == -1) continue;
        final key = part.substring(0, idx).trim();
        var value = part.substring(idx + 1).trim();

        if ((value.startsWith("'") && value.endsWith("'")) || (value.startsWith('"') && value.endsWith('"'))) {
          value = value.substring(1, value.length - 1);
        }

        map[key] = value;
      }

      bool foundValue = map['found']?.toLowerCase() == 'true';
      final icodeValue = map['icode'] ?? '';
      PillConveyor pillConveyor = PillConveyor.newInstance();
      pillConveyor.vn = vnValue;
      pillConveyor.icode = icodeValue;
      pillConveyor.is_found = foundValue == true ? 'Y' : 'N';
      pillConveyor.update_datetime = DateTime.now();

      await PillConveyorController.savePillConveyor(pillConveyor);
      pillLineController.updateIsCheckByIcode(icodeValue, foundValue);
    } catch (e) {
      log('Error parsing changed status message: $e');
    }
  }

  void handleFetchedDrugitemsMessage(String msg) async {
    const prefix = 'Fetched drugitems for VN:';
    pillLineController.vn = extractVNFromMessage(msg, prefix) ?? '';
    if (pillLineController.vn.isEmpty) {
      log('VN not found in message.');
      return;
    }

    try {
      setState(() {
        isLoading = false;
      });

      await Future.delayed(const Duration(seconds: 1));
      await pillLineController.fetchDrugitemsFromVN(vn: pillLineController.vn);

      final rawItems = pillLineController.pillLine;
      final drugItems = prepareDrugItems(rawItems);
      setState(() {
        pillLineController.isLoading = true;
      });
      if (drugItems.isNotEmpty) {
        socketController.sendDrugDataToBackend(
          vn: pillLineController.vn,
          drugItems: drugItems,
        );
      }

      setState(() {
        isLoading = true;
      });
    } catch (e) {
      log('Error fetching drugitems: $e');
      if (!mounted) return;
      await GlobalWidget.showModalMethod(context, const AlertDialogErrorWidget());
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void handleFinishedMessage(String msg) async {
    log('msg: $msg');
    setState(() {
      pillLineController.isLoading = false;
    });

    bool navigated = false;

    final notFoundPills = pillLineController.pillLine.where((pill) => pill.isFound == false).toList();

    if (notFoundPills.isEmpty) {
      Future.delayed(const Duration(seconds: 5)).then((_) {
        context.pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.push(ExNotDataWidget.routePath);
      });

      final result = await GlobalWidget.showModalMethod(
        context,
        const AlertDialogSuccessWidget(),
      );

      if (result == true && !navigated && mounted) {
        navigated = true;
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.push(ExNotDataWidget.routePath);
      }
    } else {
      final missingDrugNames = notFoundPills.map((pill) => '• ${pill.drugName}').join('\n');

      final result = await GlobalWidget.showModalMethod(
        context,
        AlertDialogNotDrugInListWidget(message: '\n$missingDrugNames'),
      );

      if (result) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.push(ExNotDataWidget.routePath);
      }
    }
  }

  List<Map<String, dynamic>> prepareDrugItems(List<OvstPillLine> items) {
    return items
        .map((item) => {
              'icode': item.icode ?? '',
              'tmt': item.tmtTpCode ?? '',
              'name': item.drugName ?? '',
            })
        .toList();
  }

  String? extractVNFromMessage(String msg, String prefix) {
    if (msg.contains(prefix)) {
      return msg.substring(msg.indexOf(prefix) + prefix.length).trim();
    }
    return null;
  }

  fetchDrugFormVN() async {
    try {
      setState(() {
        isLoading = false;
      });

      await Future.delayed(const Duration(seconds: 1));
      log('vn = ${pillLineController.vn}');
      await pillLineController.fetchDrugitemsFromVN(vn: pillLineController.vn);

      final rawItems = pillLineController.pillLine;
      final drugItems = prepareDrugItems(rawItems);
      log('drugItems: $drugItems');
      setState(() {
        pillLineController.isLoading = true;
      });
      if (drugItems.isNotEmpty) {
        socketController.sendDrugDataToBackend(
          vn: pillLineController.vn,
          drugItems: drugItems,
        );
      }

      setState(() {
        isLoading = true;
      });
    } catch (e) {
      log('Error fetching drugitems: $e');
      if (!mounted) return;
      await GlobalWidget.showModalMethod(context, const AlertDialogErrorWidget());
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (pillLineController.isLoading) {
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
          //     hasTransition: true,
          //     transitionType: PageTransitionType.fade,
          //     duration: Duration(milliseconds: 0),
          //   ),
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
                    ovstPillLine: pillLineController.pillLine.isEmpty ?? true ? null : pillLineController.pillLine.first,
                    patientinfo: isLoading,
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
                                  if (pillLineController.isLoading == true)
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
                                    child: StreamBuilder<List<OvstPillLine>>(
                                        stream: pillLineController.pillLineStream,
                                        builder: (context, snapshot) {
                                          final pillLines = snapshot.data ?? [];
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
                                        }),
                                  ),
                                ].divide(const SizedBox(width: 8.0)),
                              ),
                            ],
                          ),
                          Expanded(
                            child: StreamBuilder<List<OvstPillLine>>(
                              stream: pillLineController.pillLineStream,
                              builder: (context, snapshot) {
                                final pillLines = snapshot.data ?? [];
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
                              },
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
  }
}
