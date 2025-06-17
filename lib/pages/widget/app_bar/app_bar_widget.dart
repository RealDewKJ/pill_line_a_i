import 'package:pill_line_a_i/models/ovst_pill_line_model.dart';
import 'package:pill_line_a_i/pages/widget/patient_info_loadingdata/patient_info_loadingdata_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/patient_info/patient_info_widget.dart';
import '/pages/widget/patient_info_nodata/patient_info_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_bar_model.dart';
export 'app_bar_model.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    super.key,
    this.patientinfo,
    this.nodata,
    this.ovstPillLine,
  });

  final OvstPillLine? ovstPillLine;
  final bool? patientinfo;
  final bool? nodata;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  late AppBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppBarModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: () {
        if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
          return 150.0;
        } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
          return 150.0;
        } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
          return 200.0;
        } else {
          return 200.0;
        }
      }(),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Align(
              alignment: const AlignmentDirectional(-1.0, 1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/Artboard_2_1.png',
                  height: () {
                    if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                      return 120.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                      return 120.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                      return 220.0;
                    } else {
                      return 220.0;
                    }
                  }(),
                  fit: BoxFit.cover,
                  alignment: const Alignment(1.0, 1.0),
                ),
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Align(
              alignment: const AlignmentDirectional(1.0, 1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  'assets/images/Artboard_1.png',
                  height: () {
                    if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                      return 120.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                      return 120.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                      return 220.0;
                    } else {
                      return 220.0;
                    }
                  }(),
                  fit: BoxFit.cover,
                  alignment: const Alignment(1.0, 1.0),
                ),
              ),
            ),
          ),
          Padding(
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
                valueOrDefault<double>(
                  () {
                    if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                      return 12.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                      return 12.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                      return 32.0;
                    } else {
                      return 32.0;
                    }
                  }(),
                  0.0,
                ),
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
                )),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.safePop();
                      },
                      child: Container(
                        width: () {
                          if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                            return 32.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                            return 32.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                            return 40.0;
                          } else {
                            return 40.0;
                          }
                        }(),
                        height: () {
                          if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                            return 32.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                            return 32.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                            return 40.0;
                          } else {
                            return 40.0;
                          }
                        }(),
                        decoration: BoxDecoration(
                          color: const Color(0xA6F8F9FA),
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: const Color(0x35F8F9FA),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/Artboard_5.png',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Odin Check',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.sarabun(
                          fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                          fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        fontSize: () {
                          if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                            return 20.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                            return 20.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                            return 24.0;
                          } else {
                            return 24.0;
                          }
                        }(),
                        letterSpacing: 1.0,
                        fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                        fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                        shadows: [
                          const Shadow(
                            color: Color(0x806C757D),
                            offset: Offset(2.0, 2.0),
                            blurRadius: 2.0,
                          )
                        ],
                      ),
                    ),
                  ].divide(const SizedBox(width: 12.0)),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      widget.nodata == true
                          ? wrapWithModel(
                              model: _model.patientInfoNodataModel,
                              updateCallback: () => safeSetState(() {}),
                              child: const PatientInfoNodataWidget(),
                            )
                          : widget.patientinfo == false
                              ? wrapWithModel(
                                  model: _model.patientInfoNodataModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: const PatientInfoLoadingdataWidget(),
                                )
                              : wrapWithModel(
                                  model: _model.patientInfoModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: PatientInfoWidget(
                                    ovstPillLine: widget.ovstPillLine,
                                  ),
                                ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
