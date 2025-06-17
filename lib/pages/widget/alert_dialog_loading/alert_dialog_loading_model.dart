import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/button_cancel/button_cancel_widget.dart';
import 'alert_dialog_loading_widget.dart' show AlertDialogLoadingWidget;
import 'package:flutter/material.dart';

class AlertDialogLoadingModel extends FlutterFlowModel<AlertDialogLoadingWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for Button_Cancel component.
  late ButtonCancelModel buttonCancelModel;

  @override
  void initState(BuildContext context) {
    buttonCancelModel = createModel(context, () => ButtonCancelModel());
  }

  @override
  void dispose() {
    buttonCancelModel.dispose();
  }
}
