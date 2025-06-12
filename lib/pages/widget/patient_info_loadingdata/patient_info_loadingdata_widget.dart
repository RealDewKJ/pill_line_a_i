import 'package:pill_line_a_i/pages/widget/patient_info_nodata/patient_info_nodata_model.dart';

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
import 'patient_info_loadingdata_model.dart';
export 'patient_info_loadingdata_model.dart';

class PatientInfoLoadingdataWidget extends StatefulWidget {
  const PatientInfoLoadingdataWidget({super.key});

  @override
  State<PatientInfoLoadingdataWidget> createState() => _PatientInfoLoadingdataWidgetState();
}

class _PatientInfoLoadingdataWidgetState extends State<PatientInfoLoadingdataWidget> with TickerProviderStateMixin {
  late PatientInfoLoadingdataModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PatientInfoLoadingdataModel());

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
            child: Container(
              width: 80,
              height: 80,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 24),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'กำลังโหลดข้อมูล...',
                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                fontFamily: 'Sarabun',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'กรุณารอสักครู่ Pill Line AI กำลังเตรียมข้อมูลให้คุณ',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Sarabun',
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
            ),
          ),
        ),
      ),
    );
  }
}
