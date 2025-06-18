import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:pill_line_a_i/models/ovst_pill_line_model.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';

class OvstPillLineAPIController {
  static Future<List<OvstPillLine>> getOvstPillLines(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
      OvstPillLine.newInstance(),
      '?$filter',
    );

    return List<OvstPillLine>.from(value.map((e) => e as OvstPillLine));
  }

  static Future<OvstPillLine> getOvstPillLineFromID(int ovstPillLineID) async {
    final dataCount = await serviceLocator<EHPApi>().getRestAPIDataCount(
      OvstPillLine.newInstance(),
      'hos_guid=$ovstPillLineID',
    );

    if ((dataCount ?? 0) > 0) {
      return await serviceLocator<EHPApi>().getRestAPISingleFirstObject(
        OvstPillLine.newInstance(),
        '?hos_guid=$ovstPillLineID',
      ) as OvstPillLine;
    } else {
      return OvstPillLine.newInstance();
    }
  }

  static Future<List<OvstPillLine>> getOvstPillLineCount(String filter) async {
    final value = await serviceLocator<EHPApi>().getRestAPI(
      OvstPillLine.newInstance(),
      '?$filter&\$getcount=1',
    );

    return List<OvstPillLine>.from(value.map((e) => e as OvstPillLine));
  }
}
