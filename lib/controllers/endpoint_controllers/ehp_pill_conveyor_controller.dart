import 'dart:math';

import 'package:pill_line_a_i/models/ehp_pill_conveyor_model.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';

class PillConveyorController {
  static Future<List<PillConveyor>> getPillConveyors(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
        PillConveyor.newInstance(),
        // '?village_name[like]%${filter}%&\$orderby=village_moo_int,village_moo'
        '?$filter&${PillConveyor.newInstance().getDefaultRestURIParam()}&\$limit=100');

    return List<PillConveyor>.from(value.map((e) => e as PillConveyor));
  }

  static Future<PillConveyor> getPillConveyorFromID(int pillConveyorID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(PillConveyor.newInstance(), '=$pillConveyorID');

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(PillConveyor.newInstance(), '?=$pillConveyorID') as PillConveyor;
    } else {
      return PillConveyor.newInstance();
    }
  }

  static Future<bool> savePillConveyor(PillConveyor pillConveyorData) async {
    return await serviceLocator<EHPApi>().postRestAPIData(pillConveyorData, '?vn=${pillConveyorData.vn}&icode=${pillConveyorData.icode}');
  }

  static Future<bool> deletePillConveyor(PillConveyor pillConveyorData) async {
    return await serviceLocator<EHPApi>().deleteRestAPI(pillConveyorData);
  }
}
