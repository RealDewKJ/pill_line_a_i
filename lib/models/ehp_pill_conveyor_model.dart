import 'package:pill_line_a_i/flutter_flow/flutter_flow_util.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_endpoint.dart';

class PillConveyor extends EHPData {
  String? vn;
  String? icode;
  String? is_found;
  DateTime? update_datetime;
  static PillConveyor newInstance() {
    return PillConveyor(null, null, null, null);
  }

  PillConveyor(this.vn, this.icode, this.is_found, this.update_datetime);
  @override
  PillConveyor fromJson(Map<String, dynamic> json) {
    return PillConveyor(
      json['vn']?.toString(),
      json['icode']?.toString(),
      json['is_found'].toString(),
      json['update_datetime'] == null ? null : parseDateTimeFormat(json['update_datetime'].toString()),
    );
  }

  @override
  EHPData getInstance() {
    return PillConveyor.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'vn': vn,
        'icode': icode,
        'is_found': is_found,
        'update_datetime': update_datetime == null ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(update_datetime!),
      };
  @override
  String getTableName() {
    return 'pill_conveyor';
  }

  @override
  String getKeyFieldName() {
    return '';
  }

  @override
  String getKeyFieldValue() {
    return 'vn,icode';
  }

  @override
  String getDefaultRestURIParam() {
    return 'vn>0';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return ["vn", "icode", "is_found", "update_datetime"];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [6, 6, 6, 4];
  }
}
