import 'package:pill_line_a_i/models/ovst_pill_line_model.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'patient_info_model.dart';
export 'patient_info_model.dart';

class PatientInfoWidget extends StatefulWidget {
  const PatientInfoWidget({
    super.key,
    this.ovstPillLine,
  });

  final OvstPillLine? ovstPillLine;

  @override
  State<PatientInfoWidget> createState() => _PatientInfoWidgetState();
}

class _PatientInfoWidgetState extends State<PatientInfoWidget> with TickerProviderStateMixin {
  late PatientInfoModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PatientInfoModel());

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
            begin: const Offset(-40.0, 0.0),
            end: const Offset(0.0, 0.0),
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

  String getAgeInYearsAndDays(DateTime birthday) {
    final now = DateTime.now();

    int years = now.year - birthday.year;
    int months = now.month - birthday.month;
    int days = now.day - birthday.day;
    if (days < 0) {
      months--;
      final previousMonth = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1)).day;
      days += previousMonth;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    return '$years ปี $months เดือน';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
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
          filter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(32.0),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  spreadRadius: 4,
                  offset: Offset(0, 0),
                  color: Colors.white.withOpacity(0.1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/ChatGPT_Image_20_.._2568_16_00_35.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        valueOrDefault<String>(
                          '${widget.ovstPillLine?.pname ?? ''}${widget.ovstPillLine?.fname ?? ''} ${widget.ovstPillLine?.lname ?? ''}',
                          '',
                        ),
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0099DB), Color(0xFF005483)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                color: const Color(0x7FF8F9FA),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                              child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'คิว ',
                                      style: TextStyle(),
                                    ),
                                    TextSpan(
                                      text: valueOrDefault<String>('${widget.ovstPillLine?.oqueue ?? ''}', '0'),
                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                            font: GoogleFonts.sarabun(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            fontSize: () {
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
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                          ),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        fontSize: () {
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
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3EB7EC), Color(0xFF1188B9)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                color: const Color(0x7FF8F9FA),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                              child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'อายุ ',
                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                            font: GoogleFonts.sarabun(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            fontSize: () {
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
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                          ),
                                    ),
                                    TextSpan(
                                      text: valueOrDefault<String>(
                                        widget.ovstPillLine?.birthday == null ? '0' : getAgeInYearsAndDays(widget.ovstPillLine!.birthday!),
                                        '0',
                                      ),
                                      style: const TextStyle(),
                                    ),
                                    const TextSpan(
                                      text: ' ปี',
                                      style: TextStyle(),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        font: GoogleFonts.sarabun(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        fontSize: () {
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
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3EB7EC), Color(0xFF1188B9)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                color: const Color(0x7FF8F9FA),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                              child: Text(
                                valueOrDefault<String>(
                                  widget.ovstPillLine?.sexName ?? '',
                                  '',
                                ),
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      fontSize: () {
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
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                    ),
                              ),
                            ),
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     gradient: const LinearGradient(
                          //       colors: [Color(0xFF3EB7EC), Color(0xFF1188B9)],
                          //       stops: [0.0, 1.0],
                          //       begin: AlignmentDirectional(0.0, -1.0),
                          //       end: AlignmentDirectional(0, 1.0),
                          //     ),
                          //     borderRadius: BorderRadius.circular(100.0),
                          //     border: Border.all(
                          //       color: const Color(0x7FF8F9FA),
                          //       width: 1.0,
                          //     ),
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                          //     child: Text(
                          //       valueOrDefault<String>(
                          //         'VN ${widget.ovstPillLine?.vn ?? ''}',
                          //         'VN 000000',
                          //       ),
                          //       style: FlutterFlowTheme.of(context).bodyLarge.override(
                          //             font: GoogleFonts.sarabun(
                          //               fontWeight: FontWeight.w500,
                          //               fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                          //             ),
                          //             color: FlutterFlowTheme.of(context).secondaryBackground,
                          //             fontSize: () {
                          //               if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                          //                 return 12.0;
                          //               } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                          //                 return 12.0;
                          //               } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                          //                 return 16.0;
                          //               } else {
                          //                 return 16.0;
                          //               }
                          //             }(),
                          //             letterSpacing: 0.0,
                          //             fontWeight: FontWeight.w500,
                          //             fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                          //           ),
                          //     ),
                          //   ),
                          // ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3EB7EC), Color(0xFF1188B9)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                color: const Color(0x7FF8F9FA),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                              child: Text(
                                valueOrDefault<String>(
                                  'HN ${widget.ovstPillLine?.hn ?? ''}',
                                  'HN 000000',
                                ),
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      fontSize: () {
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
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                    ),
                              ),
                            ),
                          ),
                        ].divide(const SizedBox(width: 8.0)),
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
                ].divide(const SizedBox(width: 16.0)),
              ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
            ),
          ),
        ),
      ),
    );
  }
}
