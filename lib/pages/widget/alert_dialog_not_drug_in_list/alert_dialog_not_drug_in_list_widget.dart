import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/button_primary/button_primary_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'alert_dialog_not_drug_in_list_model.dart';
export 'alert_dialog_not_drug_in_list_model.dart';

class AlertDialogNotDrugInListWidget extends StatefulWidget {
  final String? message;
  const AlertDialogNotDrugInListWidget({super.key, this.message});

  @override
  State<AlertDialogNotDrugInListWidget> createState() => _AlertDialogNotDrugInListWidgetState();
}

class _AlertDialogNotDrugInListWidgetState extends State<AlertDialogNotDrugInListWidget> with TickerProviderStateMixin {
  late AlertDialogNotDrugInListModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlertDialogNotDrugInListModel());

    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 750.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          RotateEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 750.0.ms,
            begin: 0.5,
            end: 0.0,
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
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFFD1EFFF), FlutterFlowTheme.of(context).alternate],
                          stops: const [0.0, 1.0],
                          begin: const AlignmentDirectional(0.0, -1.0),
                          end: const AlignmentDirectional(0, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              'assets/images/Artboard_5.png',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                              alignment: const Alignment(0.0, 0.0),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(1.52, 1.34),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/ChatGPT_Image_5_.._2568_15_09_45.png',
                                width: 40.0,
                                height: 40.0,
                                fit: BoxFit.cover,
                              ),
                            ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation']!),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'เกิดข้อผิดพลาด!',
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
                        RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              // TextSpan(
                              //   text: 'ยา ',
                              //   style: FlutterFlowTheme.of(context).bodyLarge.override(
                              //         font: GoogleFonts.sarabun(
                              //           fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                              //           fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                              //         ),
                              //         letterSpacing: 0.0,
                              //         fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                              //         fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                              //       ),
                              // ),
                              TextSpan(
                                text: 'ไม่พบยา',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                    ),
                              ),
                              TextSpan(
                                text: ' ${widget.message ?? ''} \nกรุณาตรจสอบอีกครั้ง',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.sarabun(
                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                    ),
                              )
                            ],
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.sarabun(
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  lineHeight: 1.8,
                                ),
                          ),
                          textAlign: TextAlign.center,
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
                            text: 'ยืนยัน',
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
