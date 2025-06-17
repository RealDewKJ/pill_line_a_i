import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/button_primary/button_primary_widget.dart';
import 'alert_dialog_success_widget.dart' show AlertDialogSuccessWidget;
import 'package:flutter/material.dart';

class AlertDialogSuccessModel extends FlutterFlowModel<AlertDialogSuccessWidget> {
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
