import 'package:pill_line_a_i/pages/widget/patient_info_loadingdata/patient_info_loadingdata_model.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/patient_info/patient_info_widget.dart';
import '/pages/widget/patient_info_nodata/patient_info_nodata_widget.dart';
import 'dart:ui';
import 'app_bar_widget.dart' show AppBarWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppBarModel extends FlutterFlowModel<AppBarWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for PatientInfo_nodata component.
  late PatientInfoNodataModel patientInfoNodataModel;
  late PatientInfoLoadingdataModel patientInfoLoadingdataModel;
  // Model for PatientInfo component.
  late PatientInfoModel patientInfoModel;

  @override
  void initState(BuildContext context) {
    patientInfoNodataModel = createModel(context, () => PatientInfoNodataModel());
    patientInfoLoadingdataModel = createModel(context, () => PatientInfoLoadingdataModel());
    patientInfoModel = createModel(context, () => PatientInfoModel());
  }

  @override
  void dispose() {
    patientInfoNodataModel.dispose();
    patientInfoLoadingdataModel.dispose();
    patientInfoModel.dispose();
  }
}
