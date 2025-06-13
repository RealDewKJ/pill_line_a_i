import 'dart:async';
import 'dart:developer';

import 'package:pill_line_a_i/controllers/endpoint_controllers/ovst_pill_line_controller.dart';
import 'package:pill_line_a_i/models/ovst_pill_line_model.dart';

class PillLineController {
  static final PillLineController _instance = PillLineController._internal();
  factory PillLineController() => _instance;
  PillLineController._internal();
  final _pillLineController = StreamController<List<OvstPillLine>>.broadcast();
  List<OvstPillLine> _pillLine = [];
  List<OvstPillLine> get pillLine => _pillLine;
  String vn = '';
  Stream<List<OvstPillLine>> get pillLineStream => _pillLineController.stream;
  set pillLine(List<OvstPillLine> value) {
    _pillLine = value;
    _pillLineController.sink.add(_pillLine);
  }

  bool isLoading = false;

  void updateIsCheckByIcode(String icode, bool found) async {
    for (var p in _pillLine) {
      if (p.icode == icode) {
        p.isFound = found;
      }
    }
    _pillLineController.sink.add(_pillLine);
  }

  void dispose() {
    _pillLineController.close();
  }

  Future<void> fetchDrugitemsFromVN({required String vn}) async {
    log('vn: $vn');

    final joins = [
      r'$join[left]patient:hn:ovst.hn',
      r'$join[left]sex:code:patient.sex',
      r'$join[left]opitemrece:vn:ovst.vn',
      r'$join[left]drugitems:icode:opitemrece.icode',
    ].join('&');

    const fields = r'$field=hn,oqueue,vn';
    const subFields =
        r'$sfield=patient.fname,patient.pname,patient.lname,patient.birthday,sex.name:sex_name,opitemrece.icode,drugitems.name:drug_name,drugitems.strength,drugitems.units,drugitems.tmt_tp_code';
    const filter = r"$jwhere=opitemrece.icode:like%20'1%25'";

    final queryString = 'vn=$vn&$joins&$fields&$subFields&$filter';

    pillLine = await OvstPillLineAPIController.getOvstPillLines(queryString);
  }
}
