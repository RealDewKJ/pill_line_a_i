import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/button_primary/button_primary_widget.dart';
import 'alert_dialog_not_drug_in_list_widget.dart' show AlertDialogNotDrugInListWidget;
import 'package:flutter/material.dart';

class AlertDialogNotDrugInListModel extends FlutterFlowModel<AlertDialogNotDrugInListWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for Button_Primary component.
  late ButtonPrimaryModel buttonPrimaryModel;

  @override
  void initState(BuildContext context) {
    buttonPrimaryModel = createModel(context, () => ButtonPrimaryModel());
  }

  @override
  void dispose() {
    buttonPrimaryModel.dispose();
  }
}
