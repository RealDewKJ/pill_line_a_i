import 'package:pill_line_a_i/features/home/presentation/widgets/home_page_widget.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/pages/widget/app_bar/app_bar_widget.dart';
import '/pages/widget/item_drug/item_drug_widget.dart';
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AppBar component.
  late AppBarModel appBarModel;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel1;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel2;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel3;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel4;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel5;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel6;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel7;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel8;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel9;
  // Model for Item_drug component.
  late ItemDrugModel itemDrugModel10;

  @override
  void initState(BuildContext context) {
    appBarModel = createModel(context, () => AppBarModel());
    itemDrugModel1 = createModel(context, () => ItemDrugModel());
    itemDrugModel2 = createModel(context, () => ItemDrugModel());
    itemDrugModel3 = createModel(context, () => ItemDrugModel());
    itemDrugModel4 = createModel(context, () => ItemDrugModel());
    itemDrugModel5 = createModel(context, () => ItemDrugModel());
    itemDrugModel6 = createModel(context, () => ItemDrugModel());
    itemDrugModel7 = createModel(context, () => ItemDrugModel());
    itemDrugModel8 = createModel(context, () => ItemDrugModel());
    itemDrugModel9 = createModel(context, () => ItemDrugModel());
    itemDrugModel10 = createModel(context, () => ItemDrugModel());
  }

  @override
  void dispose() {
    appBarModel.dispose();
    itemDrugModel1.dispose();
    itemDrugModel2.dispose();
    itemDrugModel3.dispose();
    itemDrugModel4.dispose();
    itemDrugModel5.dispose();
    itemDrugModel6.dispose();
    itemDrugModel7.dispose();
    itemDrugModel8.dispose();
    itemDrugModel9.dispose();
    itemDrugModel10.dispose();
  }
}
