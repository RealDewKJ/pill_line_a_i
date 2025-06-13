import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/button_cancel/button_cancel_widget.dart';
import '/pages/widget/button_primary/button_primary_widget.dart';
import 'alert_dialog_warning_widget.dart' show AlertDialogWarningWidget;
import 'package:flutter/material.dart';

class AlertDialogWarningModel extends FlutterFlowModel<AlertDialogWarningWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for Button_Cancel component.
  late ButtonCancelModel buttonCancelModel;
  // Model for Button_Primary component.
  late ButtonPrimaryModel buttonPrimaryModel;

  @override
  void initState(BuildContext context) {
    buttonCancelModel = createModel(context, () => ButtonCancelModel());
    buttonPrimaryModel = createModel(context, () => ButtonPrimaryModel());
  }

  @override
  void dispose() {
    buttonCancelModel.dispose();
    buttonPrimaryModel.dispose();
  }
}
