import 'dart:developer';

import 'package:pill_line_a_i/controllers/pill_line_controller.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/models/ovst_pill_line_model.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';
import 'package:pill_line_a_i/utils/socket_error_handler.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/widget/app_bar/app_bar_widget.dart';
import '/pages/widget/item_drug/item_drug_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  late SocketController socketController;
  PillLineController? pillLineController;
  bool isConnected = false;
  bool isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    socketController = SocketController(
      context: context,
      onMessage: (msg) {
        log('message: $msg');
        if (msg.contains('Fetched drugitems for VN:')) {
          handleFetchedDrugitemsMessage(msg);
        }
      },
      onConnectionStatusChanged: (status) {
        setState(() {
          isConnected = status;
        });
      },
    );

    socketController.initSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    socketController.dispose();
    super.dispose();
  }

  void handleFetchedDrugitemsMessage(String msg) async {
    const prefix = 'Fetched drugitems for VN:';
    final vn = extractVNFromMessage(msg, prefix);
    if (vn == null || vn.isEmpty) {
      log('VN not found in message.');
      return;
    }

    try {
      setState(() {
        isLoading = false;
      });

      pillLineController = PillLineController();
      await Future.delayed(const Duration(seconds: 1));
      await pillLineController?.fetchDrugitemsFromVN(vn: vn);

      final rawItems = pillLineController?.pillLine ?? [];
      final drugItems = prepareDrugItems(rawItems);

      if (drugItems.isNotEmpty) {
        socketController.sendDrugDataToBackend(
          vn: vn,
          drugItems: drugItems,
        );
      }

      setState(() {
        isLoading = true;
      });
    } catch (e) {
      log('Error: $e');
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

  @override
  Widget build(BuildContext context) {
    final foundCount = pillLineController?.pillLine.where((e) => e.isFound == true).length ?? 0;
    final totalCount = pillLineController?.pillLine.length ?? 0;

    return GestureDetector(
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
                  ovstPillLine: pillLineController?.pillLine.isEmpty ?? true ? null : pillLineController?.pillLine.first,
                  patientinfo: isLoading,
                  nodata: false,
                ),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(overscroll: false),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0x00F8F9FA), Color(0xE6F8F9FA), FlutterFlowTheme.of(context).primaryBackground],
                      stops: [0.0, 0.15, 0.2],
                      begin: AlignmentDirectional(0.0, -1.0),
                      end: AlignmentDirectional(0, 1.0),
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
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x336C757D),
                                    offset: Offset(
                                      0.0,
                                      2.0,
                                    ),
                                  )
                                ],
                                gradient: LinearGradient(
                                  colors: [Color(0xFF0099DB), Color(0xFF005483)],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(0.0, -1.0),
                                  end: AlignmentDirectional(0, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(
                                  color: Color(0x7FE9ECEF),
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
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
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(height: 12.0),
                            padding: EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              24.0,
                            ),
                            shrinkWrap: true,
                            itemCount: pillLineController?.pillLine.length ?? 0,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final item = pillLineController?.pillLine[index];
                              return wrapWithModel(
                                model: _model.itemDrugModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: item?.tmtTpCode != null ? 'TMT ${item!.tmtTpCode}' : '',
                                  drugname: '${item?.drugName ?? ''} ${item?.strength ?? ''} ${item?.units ?? ''}',
                                  icon: Icon(
                                    Icons.circle_outlined,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor2,
                                  color2: FlutterFlowTheme.of(context).customColor1,
                                ),
                              );
                            },
                            /*  children: [
                              wrapWithModel(
                                model: _model.itemDrugModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000001',
                                  drugname: 'พาราเซตามอล 500 มก.',
                                  icon: Icon(
                                    Icons.circle_outlined,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor2,
                                  color2: FlutterFlowTheme.of(context).customColor1,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.itemDrugModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000002',
                                  drugname: 'ซิโปรฟล็อกซาซิน 250 มก.',
                                  icon: Icon(
                                    Icons.circle_outlined,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor2,
                                  color2: FlutterFlowTheme.of(context).customColor1,
                                  iconbg: 0.1,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.itemDrugModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000003',
                                  drugname: 'ลอราทาดีน 10 มก.',
                                  icon: Icon(
                                    Icons.circle_outlined,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor2,
                                  color2: FlutterFlowTheme.of(context).customColor1,
                                  iconbg: 0.1,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.itemDrugModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000004',
                                  drugname: 'ซิมวาสแตติน 20 มก.',
                                  icon: Icon(
                                    Icons.circle_outlined,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor2,
                                  color2: FlutterFlowTheme.of(context).customColor1,
                                  iconbg: 0.1,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.itemDrugModel5,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000005',
                                  drugname: 'เมโทรนิดาโซล 400 มก.',
                                  icon: Icon(
                                    Icons.circle_outlined,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor2,
                                  color2: FlutterFlowTheme.of(context).customColor1,
                                  iconbg: 0.1,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.itemDrugModel6,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000006',
                                  drugname: 'แคลเซียมคาร์บอเนต 500 มก.',
                                  icon: Icon(
                                    Icons.circle_outlined,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor2,
                                  color2: FlutterFlowTheme.of(context).customColor1,
                                  iconbg: 0.1,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.itemDrugModel7,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000007',
                                  drugname: 'โซเดียมคลอไรด์ 0.9% (สำหรับฉีด)',
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: FlutterFlowTheme.of(context).error,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor10,
                                  color2: FlutterFlowTheme.of(context).customColor9,
                                  colorbg2: FlutterFlowTheme.of(context).customColor11,
                                  colorbg1: FlutterFlowTheme.of(context).customColor12,
                                  iconbg: 1.0,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.itemDrugModel8,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000008',
                                  drugname: 'ฟลูโคนาโซล 150 มก.',
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: FlutterFlowTheme.of(context).error,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor10,
                                  color2: FlutterFlowTheme.of(context).customColor9,
                                  colorbg2: FlutterFlowTheme.of(context).customColor11,
                                  colorbg1: FlutterFlowTheme.of(context).customColor12,
                                  iconbg: 1.0,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.itemDrugModel9,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000009',
                                  drugname: 'ไอบูโพรเฟน 200 มก.',
                                  icon: Icon(
                                    Icons.check_rounded,
                                    color: FlutterFlowTheme.of(context).secondary,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor5,
                                  color2: FlutterFlowTheme.of(context).customColor4,
                                  colorbg2: FlutterFlowTheme.of(context).customColor6,
                                  colorbg1: FlutterFlowTheme.of(context).customColor7,
                                  iconbg: 1.0,
                                ),
                              ),
                              wrapWithModel(
                                model: _model.itemDrugModel10,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDrugWidget(
                                  tmt: 'TMT 000010',
                                  drugname: 'อะม็อกซี่ซิลลิน 500 มก.',
                                  icon: Icon(
                                    Icons.check_rounded,
                                    color: FlutterFlowTheme.of(context).secondary,
                                    size: 40.0,
                                  ),
                                  color1: FlutterFlowTheme.of(context).customColor5,
                                  color2: FlutterFlowTheme.of(context).customColor4,
                                  colorbg2: FlutterFlowTheme.of(context).customColor6,
                                  colorbg1: FlutterFlowTheme.of(context).customColor7,
                                  iconbg: 1.0,
                                ),
                              ),
                            ].divide(SizedBox(height: 12.0)), */
                          ),
                        ),
                      ].divide(SizedBox(height: 12.0)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
