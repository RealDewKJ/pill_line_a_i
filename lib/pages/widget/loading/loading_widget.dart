import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'loading_model.dart';
export 'loading_model.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  late LoadingModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadingModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xC9FFFFFF),
                shape: BoxShape.circle,
              ),
              child: Lottie.asset(
                'assets/jsons/RQc9UTkiIW.json',
                width: () {
                  if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                    return 84.0;
                  } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                    return 84.0;
                  } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                    return 92.0;
                  } else {
                    return 92.0;
                  }
                }(),
                height: () {
                  if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                    return 84.0;
                  } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                    return 84.0;
                  } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                    return 92.0;
                  } else {
                    return 92.0;
                  }
                }(),
                fit: BoxFit.contain,
                animate: true,
              ),
            ),
          ),
        ),
        Text(
          'กำลังโหลด...',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.sarabun(
                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).secondaryBackground,
                fontSize: () {
                  if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                    return 14.0;
                  } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                    return 14.0;
                  } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                    return 16.0;
                  } else {
                    return 16.0;
                  }
                }(),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
      ].divide(const SizedBox(height: 16.0)),
    );
  }
}
