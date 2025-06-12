import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/button_cancel/button_cancel_widget.dart';
import '/pages/widget/button_primary/button_primary_widget.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'alert_dialog_warning_model.dart';
export 'alert_dialog_warning_model.dart';

class AlertDialogWarningWidget extends StatefulWidget {
  final String? message;
  const AlertDialogWarningWidget({super.key, this.message});

  @override
  State<AlertDialogWarningWidget> createState() => _AlertDialogWarningWidgetState();
}

class _AlertDialogWarningWidgetState extends State<AlertDialogWarningWidget> with TickerProviderStateMixin {
  late AlertDialogWarningModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlertDialogWarningModel());

    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ShakeEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 600.0.ms,
            hz: 10,
            offset: Offset(-1.0, 0.0),
            rotation: 0.087,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          width: () {
            if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
              return 280.0;
            } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
              return 280.0;
            } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
              return 380.0;
            } else {
              return 380.0;
            }
          }(),
          decoration: BoxDecoration(
            color: Color(0xE5FFFFFF),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: Color(0xB2F1F4F8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(valueOrDefault<double>(
                  () {
                    if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                      return 12.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                      return 12.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                      return 24.0;
                    } else {
                      return 24.0;
                    }
                  }(),
                  0.0,
                )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/ChatGPT_Image_5_.._2568_14_58_59.png',
                        width: () {
                          if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                            return 56.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                            return 56.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                            return 74.0;
                          } else {
                            return 74.0;
                          }
                        }(),
                        height: () {
                          if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                            return 56.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                            return 56.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                            return 74.0;
                          } else {
                            return 74.0;
                          }
                        }(),
                        fit: BoxFit.cover,
                      ),
                    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation']!),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'คำเตือน!',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.sarabun(
                                  fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                              ),
                        ),
                        Text(
                          widget.message ?? 'คุณยังไม่ได้ตรวจสอบรายการยาครบถ้วน กรุณาตรวจสอบอีกครั้งก่อนดำเนินการต่อ',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                font: GoogleFonts.sarabun(
                                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                lineHeight: 1.8,
                              ),
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              Padding(
                padding: EdgeInsets.all(valueOrDefault<double>(
                  () {
                    if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                      return 12.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                      return 12.0;
                    } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                      return 24.0;
                    } else {
                      return 24.0;
                    }
                  }(),
                  0.0,
                )),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: wrapWithModel(
                        model: _model.buttonCancelModel,
                        updateCallback: () => safeSetState(() {}),
                        child: ButtonCancelWidget(),
                      ),
                    ),
                    Expanded(
                      child: wrapWithModel(
                        model: _model.buttonPrimaryModel,
                        updateCallback: () => safeSetState(() {}),
                        child: ButtonPrimaryWidget(
                          text: 'ยืนยัน',
                        ),
                      ),
                    ),
                  ].divide(SizedBox(width: 12.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
