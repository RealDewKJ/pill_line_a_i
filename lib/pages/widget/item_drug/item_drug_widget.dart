import 'package:pill_line_a_i/services/ehp_endpoint/ehp_endpoint.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'item_drug_model.dart';
export 'item_drug_model.dart';

class ItemDrugWidget extends StatefulWidget {
  const ItemDrugWidget({
    super.key,
    this.tmt,
    this.drugname,
    this.icon,
    Color? color1,
    Color? color2,
    Color? colorbg2,
    Color? colorbg1,
    this.iconbg,
    this.icode,
  })  : color1 = color1 ?? const Color(0xFFA9A9A9),
        color2 = color2 ?? const Color(0xFF818181),
        colorbg2 = colorbg2 ?? Colors.white,
        colorbg1 = colorbg1 ?? Colors.white;

  final String? tmt;
  final String? drugname;
  final String? icode;
  final Widget? icon;
  final Color color1;
  final Color color2;
  final Color colorbg2;
  final Color colorbg1;
  final double? iconbg;

  @override
  State<ItemDrugWidget> createState() => _ItemDrugWidgetState();
}

class _ItemDrugWidgetState extends State<ItemDrugWidget> {
  late ItemDrugModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemDrugModel());

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
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 8.0,
            color: Color(0x80E3E3E3),
            offset: Offset(
              0.0,
              0.0,
            ),
          )
        ],
        gradient: LinearGradient(
          colors: [
            valueOrDefault<Color>(
              widget.colorbg1,
              FlutterFlowTheme.of(context).primaryBackground,
            ),
            valueOrDefault<Color>(
              widget.colorbg2,
              FlutterFlowTheme.of(context).primaryBackground,
            )
          ],
          stops: const [0.0, 1.0],
          begin: const AlignmentDirectional(0.0, -1.0),
          end: const AlignmentDirectional(0, 1.0),
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryBackground,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (widget.icode?.isEmpty ?? true)
                      ? Container(
                          width: () {
                            if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                              return 56.0;
                            } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                              return 56.0;
                            } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                              return 64.0;
                            } else {
                              return 64.0;
                            }
                          }(),
                          height: () {
                            if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                              return 56.0;
                            } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                              return 56.0;
                            } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                              return 64.0;
                            } else {
                              return 64.0;
                            }
                          }(),
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
                            ],
                          ),
                        )
                      : Container(
                          width: () {
                            if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                              return 56.0;
                            } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                              return 56.0;
                            } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                              return 64.0;
                            } else {
                              return 64.0;
                            }
                          }(),
                          height: () {
                            if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                              return 56.0;
                            } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                              return 56.0;
                            } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                              return 64.0;
                            } else {
                              return 64.0;
                            }
                          }(),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [const Color(0xFFD1EFFF), FlutterFlowTheme.of(context).alternate],
                              stops: const [0.0, 1.0],
                              begin: const AlignmentDirectional(0.0, -1.0),
                              end: const AlignmentDirectional(0, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.network(
                              '${Endpoints.baseUrl}${Endpoints.restAPIPath}/${Endpoints.getHospitalCode()}/drugitems_picture_list/?icode=${widget.icode}&\$image=drugitems_picture_blob&timestamp=${DateTime.timestamp()}',
                              headers: {'Authorization': 'Bearer ${Endpoints.apiUserJWT}'},
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;

                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/Artboard_5.png',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                  Container(
                    width: () {
                      if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                        return 56.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                        return 56.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                        return 64.0;
                      } else {
                        return 64.0;
                      }
                    }(),
                    height: () {
                      if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                        return 56.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                        return 56.0;
                      } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                        return 64.0;
                      } else {
                        return 64.0;
                      }
                    }(),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFF82E7C5), FlutterFlowTheme.of(context).accent3],
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                valueOrDefault<Color>(
                                  widget.color1,
                                  FlutterFlowTheme.of(context).customColor2,
                                ),
                                valueOrDefault<Color>(
                                  widget.color2,
                                  FlutterFlowTheme.of(context).customColor1,
                                )
                              ],
                              stops: const [0.0, 1.0],
                              begin: const AlignmentDirectional(0.56, -1.0),
                              end: const AlignmentDirectional(-0.56, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 16.0, 2.0),
                            child: Text(
                              valueOrDefault<String>(
                                widget.tmt,
                                'TMT 00000',
                              ),
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.sarabun(
                                      fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
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
                                    fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                  ),
                            ),
                          ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            widget.drugname,
                            'Drug name',
                          ),
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                font: GoogleFonts.sarabun(
                                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                ),
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
                                fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                              ),
                        ),
                      ].divide(const SizedBox(height: 8.0)),
                    ),
                  ),
                ].divide(const SizedBox(width: 16.0)),
              ),
            ),
            Opacity(
              opacity: valueOrDefault<double>(
                widget.iconbg,
                0.05,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                child: widget.icon!,
              ),
            ),
          ].divide(const SizedBox(width: 12.0)),
        ),
      ),
    );
  }
}
