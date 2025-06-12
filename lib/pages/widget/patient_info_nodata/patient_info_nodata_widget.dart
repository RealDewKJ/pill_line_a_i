import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'patient_info_nodata_model.dart';
export 'patient_info_nodata_model.dart';

class PatientInfoNodataWidget extends StatefulWidget {
  const PatientInfoNodataWidget({super.key});

  @override
  State<PatientInfoNodataWidget> createState() => _PatientInfoNodataWidgetState();
}

class _PatientInfoNodataWidgetState extends State<PatientInfoNodataWidget> with TickerProviderStateMixin {
  late PatientInfoNodataModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PatientInfoNodataModel());

    animationsMap.addAll({
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(-40.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });

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
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: Color(0x19F8F9FA),
            offset: Offset(
              0.0,
              0.0,
            ),
            spreadRadius: 2.0,
          )
        ],
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20.0,
            sigmaY: 20.0,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 16.0,
                  color: Color(0x1AF8F9FA),
                  offset: Offset(
                    0.0,
                    0.0,
                  ),
                  spreadRadius: 8.0,
                )
              ],
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(
                color: Color(0x4CE9ECEF),
                width: () {
                  if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                    return 2.0;
                  } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                    return 2.0;
                  } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                    return 4.0;
                  } else {
                    return 4.0;
                  }
                }(),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: () {
                      if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                        return 56.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                        return 56.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                        return 80.0;
                      } else {
                        return 80.0;
                      }
                    }(),
                    height: () {
                      if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                        return 56.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                        return 56.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                        return 80.0;
                      } else {
                        return 80.0;
                      }
                    }(),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                        width: 200.0,
                        height: 200.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/welcome.png',
                          fit: BoxFit.cover,
                        )),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              font: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                              ),
                              fontSize: () {
                                if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                                  return 16.0;
                                } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                                  return 20.0;
                                } else {
                                  return 20.0;
                                }
                              }(),
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                            ),
                      ),
                      Text(
                        'เริ่มต้นใช้งาน Pill Line AI ตอนนี้',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.sarabun(
                                fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                              ),
                              letterSpacing: 1.0,
                              fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(height: () {
                      if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                        return 8.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                        return 8.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                        return 12.0;
                      } else {
                        return 12.0;
                      }
                    }())),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
            ),
          ),
        ),
      ),
    );
  }
}
