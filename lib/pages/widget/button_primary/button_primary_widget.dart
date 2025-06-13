import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'button_primary_model.dart';
export 'button_primary_model.dart';

class ButtonPrimaryWidget extends StatefulWidget {
  const ButtonPrimaryWidget({
    super.key,
    this.text,
  });

  final String? text;

  @override
  State<ButtonPrimaryWidget> createState() => _ButtonPrimaryWidgetState();
}

class _ButtonPrimaryWidgetState extends State<ButtonPrimaryWidget> {
  late ButtonPrimaryModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ButtonPrimaryModel());

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
          return 40.0;
        } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
          return 40.0;
        } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
          return 48.0;
        } else {
          return 48.0;
        }
      }(),
      constraints: const BoxConstraints(
        minWidth: 120.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [FlutterFlowTheme.of(context).primary, const Color(0xFF25708E)],
          stops: const [0.0, 1.0],
          begin: const AlignmentDirectional(0.0, -1.0),
          end: const AlignmentDirectional(0, 1.0),
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              valueOrDefault<String>(
                widget.text,
                'Button Primary',
              ),
              textAlign: TextAlign.start,
              maxLines: 1,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.sarabun(
                      fontWeight: FontWeight.normal,
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
                    fontWeight: FontWeight.normal,
                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
