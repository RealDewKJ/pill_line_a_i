import 'package:flutter/material.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:pill_line_a_i/flutter_flow/flutter_flow_theme.dart';
import 'package:pill_line_a_i/flutter_flow/flutter_flow_util.dart';
import 'package:pill_line_a_i/index.dart';
import 'package:pill_line_a_i/pages/widget/app_bar/app_bar_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_endpoint.dart';

class NotFoundWidget extends StatefulWidget {
  const NotFoundWidget({super.key});
  static String routeName = 'NotFound';
  static String routePath = '/notFound';
  @override
  State<NotFoundWidget> createState() => _NotFoundWidgetState();
}

class _NotFoundWidgetState extends State<NotFoundWidget> {
  bool _isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _handleReload() async {
    setState(() {
      _isLoading = true;
    });
    Endpoints.isEHPConnect = await serviceLocator<EHPApi>().initializeEHPToken();
    if (Endpoints.isEHPConnect) {
      // await serviceLocator<EHPApi>().getUserJWT('0000000000001', 'admin');
      context.go('/');
    }
    safeSetState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      0.0,
                      valueOrDefault<double>(
                        () {
                          if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
                            return 48.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
                            return 48.0;
                          } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
                            return 0.0;
                          } else {
                            return 0.0;
                          }
                        }(),
                        0.0,
                      ),
                      0.0,
                      0.0),
                  child: const AppBarWidget(
                    patientinfo: false,
                    nodata: true,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0x00F8F9FA), const Color(0xE6F8F9FA), FlutterFlowTheme.of(context).primaryBackground],
                        stops: const [0.0, 0.15, 0.2],
                        begin: const AlignmentDirectional(0.0, -1.0),
                        end: const AlignmentDirectional(0, 1.0),
                      ),
                    ),
                    child: Padding(
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
                          0.0,
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
                          0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/jsons/404.json',
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'การเชื่อมต่อขัดข้อง ไม่พบการเชื่อมต่อกับเซิร์ฟเวอร์',
                            style: FlutterFlowTheme.of(context).headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'กรุณาตรวจสอบการเชื่อมต่อกับอินเตอร์เน็ต และลองใหม่อีกครั้ง',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              await _handleReload();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: FlutterFlowTheme.of(context).primary,
                              foregroundColor: Colors.white,
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'ลองใหม่อีกครั้ง',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
