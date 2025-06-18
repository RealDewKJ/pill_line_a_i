import 'dart:developer';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/controllers/endpoint_controllers/ehp_pill_conveyor_controller.dart';
import 'package:pill_line_a_i/controllers/endpoint_controllers/ovst_pill_line_controller.dart';
import 'package:pill_line_a_i/models/ehp_pill_conveyor_model.dart';
import 'package:pill_line_a_i/models/ovst_pill_line_model.dart';

// Events
abstract class PillLineEvent extends Equatable {
  const PillLineEvent();

  @override
  List<Object> get props => [];
}

class FetchDrugFromVN extends PillLineEvent {
  final String? vn;

  const FetchDrugFromVN({this.vn});

  @override
  List<Object> get props => [vn ?? ''];
}

class HandleChangedStatusMessage extends PillLineEvent {
  final String message;

  const HandleChangedStatusMessage(this.message);

  @override
  List<Object> get props => [message];
}

class HandleFetchedDrugitemsMessage extends PillLineEvent {
  final String message;

  const HandleFetchedDrugitemsMessage(this.message);

  @override
  List<Object> get props => [message];
}

class HandleFinishedMessage extends PillLineEvent {
  final String message;

  const HandleFinishedMessage(this.message);

  @override
  List<Object> get props => [message];
}

class UpdatePillLineStatus extends PillLineEvent {
  final String icode;
  final bool isFound;

  const UpdatePillLineStatus({required this.icode, required this.isFound});

  @override
  List<Object> get props => [icode, isFound];
}

// States
abstract class PillLineState extends Equatable {
  const PillLineState();

  @override
  List<Object> get props => [];
}

class PillLineInitial extends PillLineState {}

class PillLineLoading extends PillLineState {}

class PillLineLoaded extends PillLineState {
  final List<OvstPillLine> pillLines;
  final bool isLoading;
  final String? vn;

  const PillLineLoaded({
    required this.pillLines,
    this.isLoading = false,
    this.vn,
  });

  @override
  List<Object> get props => [pillLines, isLoading, vn ?? ''];

  PillLineLoaded copyWith({
    List<OvstPillLine>? pillLines,
    bool? isLoading,
    String? vn,
  }) {
    return PillLineLoaded(
      pillLines: pillLines ?? this.pillLines,
      isLoading: isLoading ?? this.isLoading,
      vn: vn ?? this.vn,
    );
  }
}

class PillLineNoPatientFound extends PillLineState {
  final String vn;

  const PillLineNoPatientFound({required this.vn});

  @override
  List<Object> get props => [vn];
}

class PillLineError extends PillLineState {
  final String message;

  const PillLineError(this.message);

  @override
  List<Object> get props => [message];
}

class PillLineFinished extends PillLineState {
  final List<OvstPillLine> pillLines;
  final bool hasMissingPills;
  final List<String> missingDrugNames;

  const PillLineFinished({
    required this.pillLines,
    required this.hasMissingPills,
    required this.missingDrugNames,
  });

  @override
  List<Object> get props => [pillLines, hasMissingPills, missingDrugNames];
}

// BLoC
class PillLineBloc extends Bloc<PillLineEvent, PillLineState> {
  final SocketController socketController;

  // Internal data management
  List<OvstPillLine> _pillLines = [];
  String _currentVn = '';

  PillLineBloc({
    required this.socketController,
  }) : super(PillLineInitial()) {
    on<FetchDrugFromVN>(_onFetchDrugFromVN);
    on<HandleChangedStatusMessage>(_onHandleChangedStatusMessage);
    on<HandleFetchedDrugitemsMessage>(_onHandleFetchedDrugitemsMessage);
    on<HandleFinishedMessage>(_onHandleFinishedMessage);
    on<UpdatePillLineStatus>(_onUpdatePillLineStatus);
  }

  // Getters for external access
  List<OvstPillLine> get pillLines => _pillLines;
  String get currentVn => _currentVn;

  Future<void> _onFetchDrugFromVN(
    FetchDrugFromVN event,
    Emitter<PillLineState> emit,
  ) async {
    try {
      emit(PillLineLoading());

      await Future.delayed(const Duration(seconds: 1));
      final vn = event.vn ?? _currentVn;
      log('vn = $vn');

      final pillLines = await _fetchDrugitemsFromVN(vn: vn);
      _pillLines = pillLines;
      _currentVn = vn;

      if (pillLines.isEmpty) {
        emit(PillLineNoPatientFound(vn: vn));
        return;
      }

      final drugItems = _prepareDrugItems(pillLines);
      log('drugItems: $drugItems', name: 'drugItems');

      emit(PillLineLoaded(
        pillLines: pillLines,
        isLoading: true,
        vn: vn,
      ));

      if (drugItems.isNotEmpty) {
        _sendDrugDataToBackend(
          vn: vn,
          drugItems: drugItems,
        );
      }
    } catch (e) {
      log('Error fetching drugitems: $e');
      emit(PillLineError('เกิดข้อผิดพลาดในการดึงข้อมูลยา: $e'));
    }
  }

  Future<void> _onHandleChangedStatusMessage(
    HandleChangedStatusMessage event,
    Emitter<PillLineState> emit,
  ) async {
    log('msg: ${event.message}');

    try {
      // ดึง VN ด้วย RegExp
      final vnMatch = RegExp(r'VN:\s*(\d+)').firstMatch(event.message);
      if (vnMatch == null) return;
      final vnValue = vnMatch.group(1)!;

      // ดึง Drug JSON string
      final drugDataStart = event.message.indexOf('Drug: ');
      if (drugDataStart == -1) return;

      final drugStr = event.message.substring(drugDataStart + 6).trim();

      var cleanStr = drugStr;
      if (cleanStr.startsWith('{') && cleanStr.endsWith('}')) {
        cleanStr = cleanStr.substring(1, cleanStr.length - 1);
      }

      final parts = cleanStr.split(RegExp(r', (?=[a-zA-Z0-9_]+:)'));

      final Map<String, String> map = {};
      for (var part in parts) {
        final idx = part.indexOf(':');
        if (idx == -1) continue;
        final key = part.substring(0, idx).trim();
        var value = part.substring(idx + 1).trim();

        if ((value.startsWith("'") && value.endsWith("'")) || (value.startsWith('"') && value.endsWith('"'))) {
          value = value.substring(1, value.length - 1);
        }

        map[key] = value;
      }

      bool foundValue = map['found']?.toLowerCase() == 'true';
      final icodeValue = map['icode'] ?? '';

      PillConveyor pillConveyor = PillConveyor.newInstance();
      pillConveyor.vn = vnValue;
      pillConveyor.icode = icodeValue;
      pillConveyor.is_found = foundValue == true ? 'Y' : 'N';
      pillConveyor.update_datetime = DateTime.now();

      await PillConveyorController.savePillConveyor(pillConveyor);
      _updatePillLineStatus(icodeValue, foundValue);

      // Update state with new pill line data
      if (state is PillLineLoaded) {
        final currentState = state as PillLineLoaded;
        emit(currentState.copyWith(pillLines: _pillLines));
      }
    } catch (e) {
      log('Error parsing changed status message: $e');
      emit(PillLineError('เกิดข้อผิดพลาดในการประมวลผลข้อความ: $e'));
    }
  }

  Future<void> _onHandleFetchedDrugitemsMessage(
    HandleFetchedDrugitemsMessage event,
    Emitter<PillLineState> emit,
  ) async {
    const prefix = 'Fetched drugitems for VN:';
    _currentVn = _extractVNFromMessage(event.message, prefix) ?? '';
    if (_currentVn.isEmpty) {
      log('VN not found in message.');
      return;
    }

    try {
      emit(PillLineLoaded(
        pillLines: _pillLines,
        isLoading: false,
        vn: _currentVn,
      ));

      await Future.delayed(const Duration(seconds: 1));

      final pillLines = await _fetchDrugitemsFromVN(vn: '680612084046');
      _pillLines = pillLines;

      // ตรวจสอบว่ามีข้อมูลคนไข้หรือไม่
      if (pillLines.isEmpty) {
        emit(PillLineNoPatientFound(vn: _currentVn));
        return;
      }

      final drugItems = _prepareDrugItems(pillLines);

      emit(PillLineLoaded(
        pillLines: pillLines,
        isLoading: true,
        vn: _currentVn,
      ));

      if (drugItems.isNotEmpty) {
        _sendDrugDataToBackend(
          vn: _currentVn,
          drugItems: drugItems,
        );
      }
    } catch (e) {
      log('Error fetching drugitems: $e');
      emit(PillLineError('เกิดข้อผิดพลาดในการดึงข้อมูลยา: $e'));
    }
  }

  Future<void> _onHandleFinishedMessage(
    HandleFinishedMessage event,
    Emitter<PillLineState> emit,
  ) async {
    log('msg: ${event.message}');

    final notFoundPills = _pillLines.where((pill) => pill.isFound == false).toList();
    final missingDrugNames = notFoundPills.map((pill) => '• ${pill.drugName}').toList();

    emit(PillLineFinished(
      pillLines: _pillLines,
      hasMissingPills: notFoundPills.isNotEmpty,
      missingDrugNames: missingDrugNames,
    ));
  }

  Future<void> _onUpdatePillLineStatus(
    UpdatePillLineStatus event,
    Emitter<PillLineState> emit,
  ) async {
    _updatePillLineStatus(event.icode, event.isFound);

    if (state is PillLineLoaded) {
      final currentState = state as PillLineLoaded;
      emit(currentState.copyWith(pillLines: _pillLines));
    }
  }

  // Internal helper methods
  void _updatePillLineStatus(String icode, bool found) {
    for (var pill in _pillLines) {
      if (pill.icode == icode) {
        pill.isFound = found;
        break;
      }
    }
  }

  // ฟังก์ชันส่งข้อมูลยาที่ย้ายมาจาก SocketController
  void _sendDrugDataToBackend({
    required String vn,
    required List<Map<String, dynamic>> drugItems,
  }) {
    // ตรวจสอบการเชื่อมต่อผ่าน socketController
    final data = {
      'action': 'submit_drug_list',
      'vn': vn,
      'total': drugItems.length,
      'drug': drugItems,
    };

    _sendMessage(data);
  }

  // ฟังก์ชันส่ง message ที่ย้ายมาจาก SocketController
  void _sendMessage(Map<String, dynamic> message) {
    socketController.sendMessage(message);
    log('Sent drug data: $message');
  }

  // ฟังก์ชันที่ย้ายมาจาก PillLineController
  Future<List<OvstPillLine>> _fetchDrugitemsFromVN({required String vn}) async {
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

    return await OvstPillLineAPIController.getOvstPillLines(queryString);
  }

  List<Map<String, dynamic>> _prepareDrugItems(List<OvstPillLine> items) {
    return items
        .map((item) => {
              'icode': item.icode ?? '',
              'tmt': item.tmtTpCode ?? '',
              'name': item.drugName ?? '',
            })
        .toList();
  }

  String? _extractVNFromMessage(String msg, String prefix) {
    if (msg.contains(prefix)) {
      return msg.substring(msg.indexOf(prefix) + prefix.length).trim();
    }
    return null;
  }
}
