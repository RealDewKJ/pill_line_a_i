// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:event_bus/event_bus.dart';
import 'package:encrypt/encrypt.dart' as enc;

// import 'ehp_api.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

EventBus eventBus = EventBus();

class Endpoints {
  Endpoints._();

  static String baseDomain = "https://wg3.bmscloud.in.th"; //*Prod
  static String baseUrl = "https://wg3.bmscloud.in.th/99999/phapi"; //*Prod
  // static String baseDomain = "https://uat.deverloper.bmscloud.in.th"; //*Dev
  // static String baseUrl = "https://uat.deverloper.bmscloud.in.th/99999/phapi"; //*Dev
  // static String baseDomain = "http://10.91.114.73:8001/99999/phapi"; //*Dev
  // static String baseUrl = "http://10.91.114.73:8001/99999/phapi"; //*Dev
  static String lineAPIUrl = "https://notify-api.line.me/api/notify";

  static String dbType = '';
  static bool isEHPConnect = false;

  // receiveTimeout
  static const int receiveTimeout = 60000;

  // connectTimeout
  static const int connectionTimeout = 15000;
  static int pageSize = 15;

  static const String tokenPath = '/Token';
  static const String encryptPath = '/Encrypt';
  static const String dataPath = '/Data';
  static const String restAPIPath = '/RestAPI';

  static const String apiSystemCode = 'EHP-CLIENT-1';
  static const String apiKeyCode = 'FFFFFFFFFFFFFFFFFFFF';

  // static String apiUserJWT = '';
  static String apiSessionToken = '';
  static String apiUserJWT = '';
  static String apiJWT = '';
  static String mophAPIJWT = '';

  static String apiIDPJWT = '';
  static bool hasErrorAPI = false;

  static String houseInRegionRegistTypeIDlist = '1,3';

  static int dbVillageMooZeroID = 0;

  static Map<String, dynamic> apiIDPJWTPayload = {};
  static Map<String, dynamic> apiUserJWTPayload = {};

  static bool apiTokenInitOK = false;

  static const String mqttHostUrl = 'wss://rbr1.hosxp.net:15676/ws';
  static const String mqttUser = 'bms';
  static const String mqttPassword = 'bms';

  static const String mophBaseUrl = "https://cvp1.moph.go.th";
  // need to configured before use
  static String mophAccountUser = '';
  static String mophAccountHospitalCode = '';
  static String mophAccountPassword = '';

  static String mophapiUserJWT = '';

  // firebase api key
  static String FCMAPIKey = '';

  static const String idpBaseUrl = 'https://phr1.moph.go.th/idp/api';

  static const String phrBaseUrl = 'https://phr1.moph.go.th/api';

  static bool errorDialogVisible = false;

  static String getHospitalCode() => EHPMobile.hospitalCode.isNotEmpty
      ? EHPMobile.hospitalCode
      : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];
}

class EHPMobile {
  static int appStartTick = (DateTime.now().millisecondsSinceEpoch ~/ 1000);
  static String buildID = '1.2.9';
  static String clientIP = '';
  static String hospitalCode = '';
  static String hospitalName = '';
  static String doctorCode = '';
  static String loginName = '';
  static String userName = '';
  static String doctorCid = '';
  static String bmsUserID = '';
  static String bmsUserName = '';
  static int? employeeID;
  static String employeeFullName = '';
  static int? empPositionID;
  static String empPositionName = '';
  static String empCid = '';
  static String providerRole = '';

  static String hospitalProvinceName = '';
  static String hospitalDistrictName = '';
  static String hospitalTambolName = '';
  static String hospitalAddressCode = '';
  static String onlineID = getNewGUID();

  static String fcmToken = '';

  static bool videoCallBusy = false;

  static AppLifecycleState? appLifecycleState;

  static BuildContext? lastContext;

  static String deviceModel = '';

  static int idleSecond = 0;

  static String clientPlatformName = 'EHP-Mobile';
  static String currentLocationName = '-';
  static String currentLocationNameFine = '-';

  static String expectedPONGFrom = '';
  static bool expectedPONGReceived = false;

  static bool forceCheckMOPHPersonnelOnNewRegister = true;

  // static Future<void> Function()? loginInitFunction;  not use use await login instead
  static Future<void> Function()? onOTPPinOKCallBack;

  static StreamSubscription? videoCallMQTTSubscription;
  static late GetStorage prefs;
  static String currentAddress = '';
  // static Position? currentLocationPosition;

  static bool canOpenChatPage = false;
  static bool canOpenVideoCallDirectory = false;
  // static CidModel cidModel = CidModel();
}

class VideoCallerInfo {
  final String name;
  final String organizationCode;
  final String organizationName;
  final String callReason;
  final String callChannel;
  final String callerID;
  final DateTime callerDateTime;
  String? callerData;

  VideoCallerInfo(this.name, this.organizationCode, this.organizationName, this.callReason, this.callChannel, this.callerID, this.callerDateTime);

  Map<String, dynamic> toJson() => {
        'name': name,
        'organization_code': organizationCode,
        'organization_name': organizationName,
        'call_reason': callReason,
        'call_channel': callChannel,
        'caller_id': callerID,
        'caller_datetime_tick': (callerDateTime.toUtc().millisecondsSinceEpoch / 1000).round()
      };
}

class MQTTChatEvent {
  final dynamic payload;
  MQTTChatEvent(this.payload);
}

class UserEKYCCompleteEvent {}

class IoTMessageEvent {
  String event_id;
  int person_vt_type_id;
  String? system_name;
  String hospital_code;
  String cid;
  DateTime? acquired_datetime;
  String? device_manufacturer;
  String? device_model;
  String? device_serial_no;
  String value_text;
  double? value_decimal;

  IoTMessageEvent(this.event_id, this.person_vt_type_id, this.system_name, this.hospital_code, this.cid, this.acquired_datetime,
      this.device_manufacturer, this.device_model, this.device_serial_no, this.value_text, this.value_decimal);

  static IoTMessageEvent fromJson(Map<String, dynamic> json) {
    return IoTMessageEvent(
      json['event_id']?.toString() ?? '',
      json['person_vt_type_id'] ?? 0,
      json['system_name']?.toString() ?? '',
      json['hospital_code']?.toString() ?? '',
      json['cid']?.toString() ?? '',
      json['acquired_datetime'] == null ? null : parseDateTimeFormat(json['acquired_datetime'].toString()),
      json['device_manufacturer']?.toString() ?? '',
      json['device_model']?.toString() ?? '',
      json['device_serial_no']?.toString() ?? '',
      json['value_text']?.toString() ?? '',
      double.tryParse('${json['value_decimal']}'),
    );
  }
}

class NewVideoCallIncomingEvent {
  VideoCallerInfo callInfo;
  NewVideoCallIncomingEvent(this.callInfo);
}

class AcceptVideoCallIncomingEvent {
  VideoCallerInfo callInfo;
  AcceptVideoCallIncomingEvent(this.callInfo);
}

String addZero(String input, int length) {
  String s = input;
  while (s.length < length) {
    s = '0$s';
  }
  return s;
}

String getNewGUID() {
  return '{${const Uuid().v4()}}'.toUpperCase();
}

bool xcheckPID(String cid) {
  final cidStr = cid.replaceAll(RegExp(r'[^0-9]'), '');
  if (cidStr.length == 13) {
    return true;
  }

  return false;
}

bool checkPID(String cid) {
  if (cid.length != 13) return false;
  //if (!id.startsWith('1') && !id.startsWith('2')) return false;
  var sum = 0;
  for (var i = 0; i < 12; i++) {
    sum += int.parse(cid[i]) * (13 - i);
  }
  var mod = sum % 11;
  var checkDigit = 11 - mod;
  if (checkDigit >= 10) checkDigit = checkDigit - 10;
  if (int.parse(cid[12]) != checkDigit) return false;
  return true;
}

String sortUser(String user1, String user2) {
  List<Map<String, dynamic>> user = [
    {'name': user1},
    {'name': user2}
  ];
  user.sort((a, b) {
    return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
  });

  return (user[0]['name'] ?? '') + ':' + (user[1]['name'] ?? '');
}

Future<void> initPlatformData() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var deviceData = <String, dynamic>{};

  try {
    if (kIsWeb) {
      deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
    } else {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      } else if (Platform.isLinux) {
        deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
      } else if (Platform.isMacOS) {
        deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
      } else if (Platform.isWindows) {
        deviceData = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
      }
    }

    debugPrint('deviceData = $deviceData');
  } on PlatformException {
    deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
  }
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  EHPMobile.deviceModel = '${build.manufacturer} ${build.model} (${build.version.release}) - ${build.version.incremental}';

  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,

    // 'displaySizeInches': ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
    // 'displayWidthPixels': build.displayMetrics.widthPx,
    // 'displayWidthInches': build.displayMetrics.widthInches,
    // 'displayHeightPixels': build.displayMetrics.heightPx,
    // 'displayHeightInches': build.displayMetrics.heightInches,
    // 'displayXDpi': build.displayMetrics.xDpi,
    // 'displayYDpi': build.displayMetrics.yDpi,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  EHPMobile.deviceModel = '${data.utsname.nodename} ${data.systemVersion}';

  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'version': data.version,
    'id': data.id,
    'idLike': data.idLike,
    'versionCodename': data.versionCodename,
    'versionId': data.versionId,
    'prettyName': data.prettyName,
    'buildId': data.buildId,
    'variant': data.variant,
    'variantId': data.variantId,
    'machineId': data.machineId,
  };
}

Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  EHPMobile.deviceModel = '${data.vendor} ${data.browserName} ${data.appVersion} ';

  return <String, dynamic>{
    // ignore: deprecated_member_use
    'browserName': describeEnum(data.browserName),
    'appCodeName': data.appCodeName,
    'appName': data.appName,
    'appVersion': data.appVersion,
    'deviceMemory': data.deviceMemory,
    'language': data.language,
    'languages': data.languages,
    'platform': data.platform,
    'product': data.product,
    'productSub': data.productSub,
    'userAgent': data.userAgent,
    'vendor': data.vendor,
    'vendorSub': data.vendorSub,
    'hardwareConcurrency': data.hardwareConcurrency,
    'maxTouchPoints': data.maxTouchPoints,
  };
}

Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
  return <String, dynamic>{
    'computerName': data.computerName,
    'hostName': data.hostName,
    'arch': data.arch,
    'model': data.model,
    'kernelVersion': data.kernelVersion,
    'osRelease': data.osRelease,
    'activeCPUs': data.activeCPUs,
    'memorySize': data.memorySize,
    'cpuFrequency': data.cpuFrequency,
    'systemGUID': data.systemGUID,
  };
}

Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    'numberOfCores': data.numberOfCores,
    'computerName': data.computerName,
    'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    'userName': data.userName,
    'majorVersion': data.majorVersion,
    'minorVersion': data.minorVersion,
    'buildNumber': data.buildNumber,
    'platformId': data.platformId,
    'csdVersion': data.csdVersion,
    'servicePackMajor': data.servicePackMajor,
    'servicePackMinor': data.servicePackMinor,
    'suitMask': data.suitMask,
    'productType': data.productType,
    'reserved': data.reserved,
    'buildLab': data.buildLab,
    'buildLabEx': data.buildLabEx,
    'digitalProductId': data.digitalProductId,
    'displayVersion': data.displayVersion,
    'editionId': data.editionId,
    'installDate': data.installDate,
    'productId': data.productId,
    'productName': data.productName,
    'registeredOwner': data.registeredOwner,
    'releaseId': data.releaseId,
    'deviceId': data.deviceId,
  };
}

Future waitWhile(bool Function() test, [int maxMSWait = 2000]) {
  var completer = Completer();
  final stopwatch = Stopwatch()..start();
  check() {
    if (test() || (stopwatch.elapsedMilliseconds > maxMSWait)) {
      completer.complete();
    } else {
      Timer(Duration.zero, check);
    }
  }

  check();
  return completer.future;
}

int getAgeYear(DateTime dateOfBirth) {
  try {
    var currentDate = DateTime.now();
    int ageInYears = currentDate.year - dateOfBirth.year;
    if (currentDate.month < dateOfBirth.month || (currentDate.month == dateOfBirth.month && currentDate.day < dateOfBirth.day)) {
      ageInYears--;
    }

    return ageInYears;
  } catch (e) {
    return 0;
  }
}

String getAgeString(DateTime dateOfBirth) {
  try {
    var currentDate = DateTime.now();
    int ageInYears = currentDate.year - dateOfBirth.year;
    int ageInMonths = currentDate.month - dateOfBirth.month;
    if (currentDate.month < dateOfBirth.month || (currentDate.month == dateOfBirth.month && currentDate.day < dateOfBirth.day)) {
      ageInYears--;
    }
    if (currentDate.month < dateOfBirth.month) {
      ageInMonths += 12;
    }
    return "$ageInYears ปี, $ageInMonths เดือน";
  } catch (e) {
    return '';
  }
}

String getDatePassedString(DateTime refDate) {
  var sReturn = '';

  try {
    var currentDate = DateTime.now();
    int ageInYears = currentDate.year - refDate.year;
    int ageInMonths = currentDate.month - refDate.month;
    if (currentDate.month < refDate.month || (currentDate.month == refDate.month && currentDate.day < refDate.day)) {
      ageInYears--;
    }
    if (currentDate.month < refDate.month) {
      ageInMonths += 12;
    }

    if (ageInYears > 0) {
      sReturn = '$ageInYears ปี';
    }

    if (ageInMonths > 0) {
      sReturn = '$sReturn, $ageInMonths เดือน';
    }

    if ((ageInYears + ageInMonths) == 0) {
      sReturn = '${refDate.difference(currentDate).inDays} วัน';
    }

    return sReturn;
  } catch (e) {
    return '';
  }
}

DateTime? parseDateFormat(String dateString) {
  try {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  } catch (e) {
    debugPrint('parseDateFormat $dateString error $e');
  }
  return null;
}

DateTime? parseDateTimeFormat(String dateString) {
  try {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateString);
  } catch (e) {
    debugPrint('parseDateTimeFormat $dateString error $e');
  }
  return null;
}

String replaceAllSpaceToSingleSpace(String spaceString) {
  return spaceString.replaceAllMapped(RegExp(r'\s+'), (m) => ' ');
}

String getAssetImageNameForPerson(DateTime birthDate, String sex) {
  final ageY = getAgeYear(birthDate);

  if (ageY <= 1) {
    return 'assets/images/icon/person_baby_256px.png';
  } else if (ageY <= 18) {
    switch (sex) {
      case '1':
        return 'assets/images/icon/person_male_boy_256px.png';
      default:
        return 'assets/images/icon/person_male_girl_256px.png';
    }
  } else if (ageY <= 60) {
    switch (sex) {
      case '1':
        return 'assets/images/icon/person_male_adult_256px.png';
      default:
        return 'assets/images/icon/person_female_adult_256px.png';
    }
  } else {
    switch (sex) {
      case '1':
        return 'assets/images/icon/person_male_old_256px.png';
      default:
        return 'assets/images/icon/person_female_old_256px.png';
    }
  }

  // return 'assets/images/icon/person_unknown_256px.png';
}

// Custom Encrypt / Decrypt

final key = enc.Key.fromUtf8('put32charactershereeeeeeeeeeeee!'); //32 chars
final iv = enc.IV.fromUtf8('put16characters!'); //16 chars

//encrypt
String encryptMyData(String text) {
  final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final encrypted_data = e.encrypt(text, iv: iv);
  return encrypted_data.base64;
}

//dycrypt
String decryptMyData(String text) {
  final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final decrypted_data = e.decrypt(enc.Encrypted.fromBase64(text), iv: iv);
  return decrypted_data;
}

// void printFormatJSON(String json) {
//   final x = JsonEditor.string(
//     jsonString: json,
//     onValueChanged: (value) {
//       logFull(value.toPrettyString());
//     },
//   );
// }

Future<void> showErrorDialog(String errorMessage) async {
  //await EHPApi.showErrorDialog(errorMessage);

  await Get.defaultDialog(
      title: "Error",
      middleText: errorMessage,
      backgroundColor: Colors.white,
      titleStyle: TextStyle(color: Colors.red.shade700),
      middleTextStyle: const TextStyle(color: Colors.indigo),
      radius: 10);
}

void exitApplication() {
  FlutterExitApp.exitApp(iosForceExit: true);
}

String formatThaiDateFull(DateTime? date) {
  if (date == null) {
    return '';
  }
  return DateFormat.yMMMMEEEEd().formatInBuddhistCalendarThai(date);
}

String formatThaiDateShort1(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${DateFormat.d().formatInBuddhistCalendarThai(date)} ${DateFormat.MMMM('th').formatInBuddhistCalendarThai(date)} ${int.tryParse(DateFormat('yyyy').format(date))! + 543}';
}

String formatThaiDateShort2(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${DateFormat('dd').format(date)}-${DateFormat('MM').format(date)}-${int.tryParse(DateFormat('yyyy').format(date))! + 543}';
}

String formatThaiDateShort3(DateTime? date) {
  if (date == null) {
    return '';
  }

  return '${DateFormat.d().formatInBuddhistCalendarThai(date)} ${DateFormat.MMM('th').formatInBuddhistCalendarThai(date)} ${int.tryParse(DateFormat('yyyy').format(date))! + 543}';
}

String getCurrentDate() {
  final date = DateTime.now();

  return '${DateFormat.d().formatInBuddhistCalendarThai(date)} ${DateFormat.MMM('th').formatInBuddhistCalendarThai(date)} ${int.tryParse(DateFormat('yyyy').format(date))! + 543}';
}

String getCurrentDateStr() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

String formatThaiTime(DateTime? date) {
  if (date == null) {
    return '';
  }

  return DateFormat('HH:mm:ss').format(date);
}

// Future<bool> _handleLocationPermission() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     Get.snackbar(
//       'Location Error',
//       'Location services are disabled. Please enable the services',
//     );

//     return false;
//   }
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       Get.snackbar(
//         'Location Error',
//         'Location permissions are denied',
//       );

//       return false;
//     }
//   }
//   if (permission == LocationPermission.deniedForever) {
//     Get.snackbar(
//       'Location Error',
//       'Location permissions are permanently denied, we cannot request permissions.',
//     );

//     return false;
//   }
//   return true;
// }

// Future<void> _getAddressFromLatLng(Position position) async {
//   await placemarkFromCoordinates(position.latitude, position.longitude).then((List<Placemark> placemarks) {
//     Placemark place = placemarks[0];

//     EHPMobile.currentLocationName = '${place.subLocality}, ${place.subAdministrativeArea}';
//     EHPMobile.currentLocationNameFine = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
//   }).catchError((e) {
//     debugPrint(e);
//   });
// }

// Future<void> updateCurrentPosition() async {
//   final hasPermission = await _handleLocationPermission();
//   if (!hasPermission) return;
//   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
//     EHPMobile.currentLocationPosition = position;

//     _getAddressFromLatLng(EHPMobile.currentLocationPosition!);
//   }).catchError((e) {
//     debugPrint(e);
//   });
// }
