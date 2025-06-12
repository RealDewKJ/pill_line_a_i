import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_endpoint.dart';

class OvstPillLine extends EHPData {
  String? hn;
  String? vn;
  int? oqueue;
  String? fname;
  String? pname;
  String? lname;
  DateTime? birthday;
  String? sexName;
  String? icode;
  String? tmtTpCode;
  String? drugName;
  String? strength;
  String? units;
  bool? isFound;

  static OvstPillLine newInstance() {
    return OvstPillLine(
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    );
  }

  OvstPillLine(
    this.hn,
    this.vn,
    this.oqueue,
    this.fname,
    this.pname,
    this.lname,
    this.birthday,
    this.sexName,
    this.icode,
    this.tmtTpCode,
    this.drugName,
    this.strength,
    this.units,
    this.isFound,
  );

  @override
  OvstPillLine fromJson(Map<String, dynamic> json) {
    return OvstPillLine(
      json['hn']?.toString(),
      json['vn']?.toString(),
      json['oqueue'],
      json['fname']?.toString(),
      json['pname']?.toString(),
      json['lname']?.toString(),
      json['birthday'] == null ? null : parseDateFormat(json['birthday'].toString()),
      json['sex_name']?.toString(),
      json['icode']?.toString(),
      json['tmt_tp_code']?.toString(),
      json['drug_name']?.toString(),
      json['strength']?.toString(),
      json['units']?.toString(),
      json['isFound'],
    );
  }

  @override
  EHPData getInstance() {
    return OvstPillLine.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'hn': hn,
        'vn': vn,
        'oqueue': oqueue,
        'fname': fname,
        'pname': pname,
        'lname': lname,
        'sex_name': sexName,
        'icode': icode,
        'tmt_tp_code': tmtTpCode,
        'drug_name': drugName,
        'strength': strength,
        'units': units,
        'isFound': isFound,
      };

  @override
  String getTableName() {
    return 'ovst';
  }

  @override
  String getKeyFieldName() {
    return 'hos_guid';
  }

  @override
  String getKeyFieldValue() {
    return '';
  }

  @override
  String getDefaultRestURIParam() {
    return '';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return ["hn", "vn", "oqueue", "fname", "pname", "lname", "birthday", "sex_name", "icode", "tmt_tp_code"];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [6, 2, 6, 6, 6, 4, 6, 6, 6];
  }
}
