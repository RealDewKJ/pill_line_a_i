import 'package:pill_line_a_i/models/ovst_pill_line_model.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/widget/app_bar/app_bar_widget.dart';
import '/pages/widget/no_data/no_data_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExNotdataModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
                child: AppBarWidget(
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
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                HomePageWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            child: wrapWithModel(
                              model: _model.noDataModel,
                              updateCallback: () => safeSetState(() {}),
                              child: NoDataWidget(),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12.0)),
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
