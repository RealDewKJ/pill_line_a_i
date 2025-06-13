import 'dart:developer';

import 'package:pill_line_a_i/controllers/pill_line_controller.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';

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

class _ExNotdataWidgetState extends State<ExNotdataWidget> {
  late ExNotdataModel _model;
  final socketController = serviceLocator<SocketController>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pillLineController = serviceLocator<PillLineController>();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExNotdataModel());
    log('configure socket');
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

    // socketController.initSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    // socketController.dispose();
    super.dispose();
  }
  // @override
  // void did

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
                child: const AppBarWidget(
                  patientinfo: false,
                  nodata: true,
                ),
              ),
            ),
            Expanded(
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
                      Expanded(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: wrapWithModel(
                            model: _model.noDataModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const NoDataWidget(),
                          ),
                        ),
                      ),
                    ].divide(const SizedBox(height: 12.0)),
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
