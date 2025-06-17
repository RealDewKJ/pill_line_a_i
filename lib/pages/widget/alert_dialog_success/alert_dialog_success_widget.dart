import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/button_primary/button_primary_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'alert_dialog_success_model.dart';
export 'alert_dialog_success_model.dart';

class AlertDialogSuccessWidget extends StatefulWidget {
  const AlertDialogSuccessWidget({super.key});

  @override
  State<AlertDialogSuccessWidget> createState() => _AlertDialogSuccessWidgetState();
}

class _AlertDialogSuccessWidgetState extends State<AlertDialogSuccessWidget> with TickerProviderStateMixin {
  late AlertDialogSuccessModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlertDialogSuccessModel());

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
          ScaleEffect(
            curve: Curves.elasticOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 0.0),
            end: const Offset(1.0, 1.0),
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
            color: const Color(0xE5FFFFFF),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: const Color(0xB2F1F4F8),
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
                        'assets/images/ChatGPT_Image_5_.._2568_15_19_57.png',
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
                          'ดำเนินการสำเร็จ!',
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
                          'คุณได้ตรวจสอบรายการยาทั้งหมดเรียบร้อยแล้ว',
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
                      ].divide(const SizedBox(height: 8.0)),
                    ),
                  ].divide(const SizedBox(height: 24.0)),
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
                        model: _model.buttonPrimaryModel,
                        updateCallback: () => safeSetState(() {}),
                        child: InkWell(
                          onTap: () async {
                            Navigator.pop(context, true);
                          },
                          child: const ButtonPrimaryWidget(
                            text: 'ตกลง',
                          ),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(width: 12.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
