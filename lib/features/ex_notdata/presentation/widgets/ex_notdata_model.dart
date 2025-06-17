import 'package:pill_line_a_i/features/ex_notdata/presentation/widgets/ex_notdata_widget.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/app_bar/app_bar_widget.dart';
import '/pages/widget/no_data/no_data_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';

class ExNotdataModel extends FlutterFlowModel<ExNotDataWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AppBar component.
  late AppBarModel appBarModel;
  // Model for No_Data component.
  late NoDataModel noDataModel;

  @override
  void initState(BuildContext context) {
    appBarModel = createModel(context, () => AppBarModel());
    noDataModel = createModel(context, () => NoDataModel());
  }

  @override
  void dispose() {
    appBarModel.dispose();
    noDataModel.dispose();
  }
}
