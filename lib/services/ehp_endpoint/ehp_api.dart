import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:google_fonts/google_fonts.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';

/* import 'dio_client.dart';
import 'ehp_endpoint.dart'; 
import 'ehp_locator.dart';*/

import 'package:encrypt/encrypt.dart' as enc;
import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'dart:developer' as log_dev;

import 'package:pill_line_a_i/services/ehp_endpoint/dio_client.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/dio_exception.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_endpoint.dart';

Duration? durationParse(String time) {
  try {
    final dt = DateFormat('HH:mm:ss').parse(time);
    // final dt = DateTime.parse('2000-01-01 $time');
    return Duration(hours: dt.hour, minutes: dt.minute, seconds: dt.second);
  } catch (e) {
    debugPrint('durationParse error $time $e');
  }
  return null;
}

String printDurationHHMM(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
}

String printDurationHHMMSS(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

abstract class EHPData {
  // EHPData();
  EHPData fromJson(Map<String, dynamic> json); // => EHPData();
  Map<String, dynamic> toJson(); // => {};
  String getTableName(); // => '';
  EHPData getInstance(); // => EHPData.empty();
  String getKeyFieldName();
  String getKeyFieldValue();

  List<int> getFieldTypeForUpdate();
  List<String> getFieldNameForUpdate();
  String getDefaultRestURIParam();
}

class LineApi {
  final DioClient dioClient;
  LineApi({required this.dioClient});
}

class EHPApi {
  final DioClient dioClient;
  // final MqttConnection mqtt = MqttConnection.getInstanse();
  // for save field type map from api to use when post data update to rest api
  static Map<String, dynamic> ehpFieldTypeMap = {};

  EHPApi({required this.dioClient});

  static Future<bool> checkResponseIsValid(dio.Response response) async {
    final rdata = (response.data as Map);

    if (response.statusCode == 200) {
      if (response.data == null) return false;

      if (rdata.containsKey('call_stack')) {
        debugPrint('call_stack detected !');
        showAPIErrorDialog(response);
        return false;
      }

      if (rdata.containsKey('MessageCode') && rdata.containsKey('Message')) {
        if ((response.data['MessageCode'] == 500) && (response.data['Message'] == 'Record not found !')) return true;
      }

      if (rdata.containsKey('MessageCode') && rdata.containsKey('Message') && (response.data['MessageCode'] == 401)) {
        await showJWTErrorDialog();
        return true;
      }

      if (rdata.containsKey('MessageCode') && rdata.containsKey('Message') && (response.data['MessageCode'] != 200)) {
        showAPIErrorDialog(response);
        return false;
      }

      if (response.data['result'].toString().isNotEmpty) {
        return true;
      }
    } else {
      if (rdata.containsKey('MessageCode') && rdata.containsKey('Message') && (response.data['MessageCode'] == 401)) {
        await showJWTErrorDialog();
        return true;
      }

      log('showAPIErrorDialog from else checkResponseIsValid');
      showAPIErrorDialog(response);
    }

    return false;
  }

  /* static bool checkResponseIsValid(Response response) {
    if (response.statusCode == 200) {
      //  debugPrint('response.data = ${response.data}');

      if (response.data == null) return false;

      final rdata = (response.data as Map);

      if (rdata.containsKey('call_stack')) {
        debugPrint('call_stack detected !');

        final callStackString = '${rdata['call_stack'] ?? ''}';
        for (var s in callStackString.split('\r\n')) {
          debugPrint(s);
        }
      } else {
        debugPrint('no call_stack');
      }

      if (rdata.containsKey('sWhere')) {
        debugPrint('sWhere : ${rdata['sWhere']}');
      }

      if (rdata.containsKey('debug_sql')) {
        log('MessageCode : ${rdata['MessageCode']}');
        log('debug_sql : ${rdata['debug_sql']}');
      }

      if (rdata.containsKey('sWhereBinding')) {
        debugPrint('sWhereBinding : ${rdata['sWhereBinding']}');
      }

      //field_name

      if (rdata.containsKey('field_name')) {
        //  debugPrint('field_name : ${rdata['field_name']}');
        log_dev.log('${rdata['field_name']}', name: 'field_name');
      }

      if (rdata.containsKey('MessageCode') && rdata.containsKey('Message') && (response.data['MessageCode'] != 200)) {
        return false;
      }

      if (response.data['result'].toString().isNotEmpty) {
        return true;
      }
    } else {
      if (response.data == null) return false;
      final rdata = (response.data as Map);

      if (rdata.containsKey('call_stack')) {
        debugPrint('call_stack detected !');

        final callStackString = '${rdata['call_stack'] ?? ''}';
        for (var s in callStackString.split('\r\n')) {
          debugPrint(s);
        }
      } else {
        debugPrint('no call_stack');
      }
    }

    return false;
  } */

  static String getAPIResponseMessage(dio.Response response) {
    final rdata = response.data as Map;

    if (rdata.containsKey('MessageCode') && rdata.containsKey('Message')) {
      return '${response.data['MessageCode'] ?? ''} : ${rdata['Message'] ?? ''}';
    }

    return '${response.statusCode} : No Message';
  }

  static String getAPIResponseCallStack(dio.Response response) {
    final rdata = response.data as Map;

    if (rdata.containsKey('call_stack')) {
      return '${response.data['call_stack'] ?? ''}';
    }

    return '';
  }

  static Future<bool> checkAndShowResponseIsValid(dio.Response response) async {
    if (!await checkResponseIsValid(response)) {
      _showSnackBarWithTitle('Error', getResponseMessage(response));
      return false;
    }
    return true;

    // if (response.statusCode == 200) {
    //   final rdata = response.data as Map;

    //   if (rdata.containsKey('MessageCode') && rdata.containsKey('Message') && (response.data['MessageCode'] != 200)) {
    //     _showSnackBar(rdata['Message'] ?? '');

    //     return false;
    //   }

    //   if (response.data['result'].toString().isNotEmpty) {
    //     return true;
    //   }
    // }

    // _showSnackBar('Invalid response');

    // return false;
  }

  static String getResponseMessage(dio.Response response) {
    final rdata = response.data as Map;

    if (rdata.containsKey('MessageCode') && rdata.containsKey('Message')) {
      return response.data['Message'].toString();
    }

    return '';
  }

  static String hashString(String input) {
    var bytes = utf8.encode(input); // Convert the string to bytes
    var hash = sha256.convert(bytes); // Generate the SHA-256 hash
    return hash.toString(); // Convert the hash to a string
  }

  static String createHmacSha256Hash(String string, String secret) {
    // Encode the string and secret as bytes
    var stringBytes = utf8.encode(string);
    var secretBytes = utf8.encode(secret);

    // Create the HMAC SHA256 hash
    var hash = Hmac(sha256, secretBytes).convert(stringBytes);

    // Return the hexadecimal representation of the hash
    return hash.toString().toUpperCase();
  }

  ///Accepts encrypted data and decrypt it. Returns plain text
  static String decryptWithAES(String skey, enc.Encrypted encryptedData) {
    final cipherKey = enc.Key.fromUtf8(skey);
    final encryptService = enc.Encrypter(enc.AES(cipherKey, mode: enc.AESMode.cbc)); //Using AES CBC encryption
    final initVector = enc.IV.fromUtf8(skey.substring(
        0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    return encryptService.decrypt(encryptedData, iv: initVector);
  }

  ///Encrypts the given plainText using the key. Returns encrypted data
  static enc.Encrypted encryptWithAES(String skey, String plainText) {
    final cipherKey = enc.Key.fromUtf8(skey);
    final encryptService = enc.Encrypter(enc.AES(cipherKey, mode: enc.AESMode.cbc));
    final initVector = enc.IV.fromUtf8(skey.substring(
        0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    enc.Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  Future<dio.Response> getStatus() async {
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      log('Attempting to get status from server', name: 'getStatus');

      final dio.Response statusResponse = await dioClient.get(
        '/Status',
        authHeader: '',
      );

      log('Status response received: ${statusResponse.data}', name: 'getStatus');

      return statusResponse;
    } catch (e) {
      log('Error occurred while getting status: $e', name: 'getStatus', error: true);

      if (e is dio.DioException) {
        log('Dio Error details: ${e.response?.statusCode}, ${e.message}', name: 'getStatus', error: true);
      }

      return response;
    }
  }

  Future<dio.Response> getAPIJWT() async {
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      final dio.Response statusResponse = await dioClient.get(
        '/Status',
        authHeader: '',
      );

      // log('getAPIJWT() check status = ${statusResponse.data}');

      if (await checkResponseIsValid(statusResponse)) {
        EHPMobile.clientIP = statusResponse.data['client_ip'] ?? '';

        response = await dioClient.post(
          '${Endpoints.tokenPath}?Action=JWT',
          data: {
            'system_code': Endpoints.apiSystemCode,
            'key_code': Endpoints.apiKeyCode,
          },
          authHeader: '',
        );
        log('getAPIJWT() response = ${response.data}');
        if (await checkResponseIsValid(response)) {
          Endpoints.apiJWT = response.data['result'].toString();

          debugPrint('Endpoints.apiToken = ${Endpoints.apiJWT}');
        }

        return response;
      } else {
        debugPrint('Error response');
      }
    } catch (e) {
      log('getAPIJWT() error = $e', name: 'getAPIJWT', error: true);
      // rethrow;
    }
    return response;
  }

  Future<dio.Response> getAPIAccessToken() async {
    try {
      final dio.Response response = await dioClient.post(
        '${Endpoints.tokenPath}?Action=ACT',
        data: {
          'JWT': Endpoints.apiJWT,
        },
        authHeader: '',
      );

      debugPrint('response.data === ${response.data}');

      if (await checkResponseIsValid(response)) {
        Endpoints.apiSessionToken = response.data['result'].toString();

        debugPrint('Endpoints.apiSessionToken = ${Endpoints.apiSessionToken}');
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> getUserOTP(String cid, String password) async {
    Endpoints.apiUserJWT = '';
    Endpoints.apiUserJWTPayload.clear();

    try {
      debugPrint('try login with $cid and hash ${createHmacSha256Hash(password, 'bms+')}');
      debugPrint('session token : ${Endpoints.apiSessionToken}');

      final dio.Response response = await dioClient.post(
        '${Endpoints.tokenPath}?Action=USER',
        data: {'cid': cid, 'password_hash': createHmacSha256Hash(password, 'bms+'), 'need_otp': true},
        authHeader: Endpoints.apiSessionToken,
      );

      debugPrint('USER API response.data = $response.data');

      checkResponseIsValid(response);

      // if (checkResponseIsValid(response)) {
      //  Endpoints.apiUserJWT = response.data['result'].toString();

      //  }

      return response;
    } catch (e) {
      debugPrint('Error : $e');
      return dio.Response(data: {}, requestOptions: dio.RequestOptions(), statusCode: 500, statusMessage: 'Request Failed');
    }
  }

  // Future<Response> getUserJWT(
  //     String cid, String password, String otp) async {
  //   Endpoints.apiUserJWT = '';
  //   Endpoints.apiUserJWTPayload.clear();

  //   try {
  //     final Response response = await dioClient.post(
  //       '${Endpoints.tokenPath}?Action=CONFIRMOTP',
  //       data: {
  //         'cid': cid,
  //         'password_hash': createHmacSha256Hash(password, 'bms+'),
  //         // 'otp': otp
  //       },
  //       authHeader: Endpoints.apiSessionToken,
  //     );

  //     // debugPrint('getUserJWT response.data = $response.data');

  //     if (checkResponseIsValid(response)) {
  //       Endpoints.apiUserJWT = response.data['result'].toString();

  //       debugPrint('Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');

  //       if (Endpoints.apiUserJWT.isNotEmpty) {
  //         Endpoints.apiUserJWTPayload = Jwt.parseJwt(Endpoints.apiUserJWT);
  //         log('Endpoints.apiUserJWTPayload = ${Endpoints.apiUserJWTPayload}');

  //         log('client.profile = ${Endpoints.apiUserJWTPayload['client']['profile']}');

  //         EHPMobile.loginName =
  //             Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
  //         EHPMobile.userName = Endpoints.apiUserJWTPayload['client']['profile']
  //                 ['full_name'] ??
  //             '';

  //         EHPMobile.hospitalAddressCode = Endpoints.apiUserJWTPayload['client']
  //                 ['profile']['hospital_address_code'] ??
  //             '';
  //         EHPMobile.hospitalProvinceName = Endpoints.apiUserJWTPayload['client']
  //                 ['profile']['hospital_province_name'] ??
  //             '';
  //         EHPMobile.hospitalDistrictName = Endpoints.apiUserJWTPayload['client']
  //                 ['profile']['hospital_district_name'] ??
  //             '';
  //         EHPMobile.hospitalTambolName = Endpoints.apiUserJWTPayload['client']
  //                 ['profile']['hospital_tambol_name'] ??
  //             '';
  //       }
  //     }

  //     return response;
  //   } catch (e) {
  //     return Response(
  //         data: {},
  //         requestOptions: RequestOptions(),
  //         statusCode: 500,
  //         statusMessage: 'Request Failed');
  //   }
  // }

  Future<dio.Response> getUserJWT(String cid, String password) async {
    Endpoints.apiUserJWT = '';
    Endpoints.apiUserJWTPayload.clear();
    log('getUserJWT with $cid and hash ${createHmacSha256Hash(password, 'bms+')}');
    try {
      final dio.Response response = await dioClient.post(
        '${Endpoints.tokenPath}?Action=USER',
        data: {
          'cid': cid,
          'password_hash': createHmacSha256Hash(password, 'bms+'),
        },
        authHeader: Endpoints.apiSessionToken,
      );

      debugPrint('getUserJWT response.data = $response.data');

      if (await checkResponseIsValid(response)) {
        Endpoints.apiUserJWT = response.data['result'].toString();

        debugPrint('Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');

        if (Endpoints.apiUserJWT.isNotEmpty) {
          Endpoints.apiUserJWTPayload = Jwt.parseJwt(Endpoints.apiUserJWT);
          log('Endpoints.apiUserJWTPayload = ${Endpoints.apiUserJWTPayload}');

          log('client.profile = ${Endpoints.apiUserJWTPayload['client']['profile']}');

          EHPMobile.loginName = Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
          EHPMobile.userName = Endpoints.apiUserJWTPayload['client']['profile']['full_name'] ?? '';
          log('EHPMobile.loginName : ${EHPMobile.loginName}');
          log('EHPMobile.userName : ${EHPMobile.userName}');
          EHPMobile.hospitalAddressCode = Endpoints.apiUserJWTPayload['client']['profile']['hospital_address_code'] ?? '';
          EHPMobile.hospitalProvinceName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_province_name'] ?? '';
          EHPMobile.hospitalDistrictName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_district_name'] ?? '';
          EHPMobile.hospitalTambolName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_tambol_name'] ?? '';
          log('dex:: Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');
        }
      } else {
        await showAPIErrorDialog(response);
      }

      return response;
    } catch (e) {
      debugPrint('getUserJWT ERROR:$e');
      // await showErrorDialog(e.toString());
      return dio.Response(data: {}, requestOptions: dio.RequestOptions(), statusCode: 500, statusMessage: 'Request Failed');
    }
  }

  // Future<List<Organization>> getOrganizedFromJWT(String cid, String password) async {
  //   Endpoints.apiUserJWT = '';
  //   Endpoints.apiUserJWTPayload.clear();
  //   log('getUserJWT with $cid and hash ${createHmacSha256Hash(password, 'bms+')}');
  //   try {
  //     final dio.Response response = await dioClient.post(
  //       '${Endpoints.tokenPath}?Action=USER',
  //       data: {
  //         'cid': cid,
  //         'password_hash': createHmacSha256Hash(password, 'bms+'),
  //       },
  //       authHeader: Endpoints.apiSessionToken,
  //     );

  //     debugPrint('getUserJWT response.data = $response.data');

  //     if (await checkResponseIsValid(response)) {
  //       Endpoints.apiUserJWT = response.data['result'].toString();

  //       debugPrint('Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');

  //       if (Endpoints.apiUserJWT.isNotEmpty) {
  //         Endpoints.apiUserJWTPayload = Jwt.parseJwt(Endpoints.apiUserJWT);
  //         log('Endpoints.apiUserJWTPayload = ${Endpoints.apiUserJWTPayload}');

  //         log('client.profile = ${Endpoints.apiUserJWTPayload['client']['profile']}');

  //         EHPMobile.loginName = Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
  //         EHPMobile.userName = Endpoints.apiUserJWTPayload['client']['profile']['full_name'] ?? '';
  //         log('EHPMobile.loginName : ${EHPMobile.loginName}');
  //         log('EHPMobile.userName : ${EHPMobile.userName}');
  //         EHPMobile.hospitalAddressCode = Endpoints.apiUserJWTPayload['client']['profile']['hospital_address_code'] ?? '';
  //         EHPMobile.hospitalProvinceName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_province_name'] ?? '';
  //         EHPMobile.hospitalDistrictName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_district_name'] ?? '';
  //         EHPMobile.hospitalTambolName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_tambol_name'] ?? '';
  //         log('dex:: Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');
  //       }
  //       if (Endpoints.apiUserJWTPayload['client']?['profile']?['organization'] != null) {
  //         List<dynamic> organizationData = Endpoints.apiUserJWTPayload['client']['profile']['organization'];
  //         // แปลงเป็น List<Organizations>
  //         List<Organization> organizations = organizationData.map((data) {
  //           return Organization.fromJson(data);
  //         }).toList();

  //         debugPrint('Organization data: $organizations');
  //         return organizations; // คืนค่า organization
  //       } else {
  //         debugPrint('No organization data found in payload.');
  //         return []; // ไม่มีข้อมูล organization
  //       }
  //     } else {
  //       await showAPIErrorDialog(response);
  //       return [];
  //     }
  //   } catch (e) {
  //     debugPrint('getUserJWT ERROR:$e');
  //     await showErrorDialog(e.toString());
  //     return [];
  //   }
  // }

  Future<dio.Response> getUserJWTFromMOPHIDP(String sjwt) async {
    Endpoints.apiUserJWT = '';
    Endpoints.apiUserJWTPayload.clear();

    try {
      final dio.Response response = await dioClient.post(
        '${Endpoints.tokenPath}?Action=USER-MOPH-IDP',
        data: {'idp_jwt': sjwt},
        authHeader: Endpoints.apiSessionToken,
      );

      //debugPrint('getUserJWT response.data = $response.data');

      if (await checkResponseIsValid(response)) {
        Endpoints.apiIDPJWT = sjwt;
        Endpoints.apiIDPJWTPayload = Jwt.parseJwt(Endpoints.apiIDPJWT);

        Endpoints.apiUserJWT = response.data['result'].toString();

        debugPrint('Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');

        if (Endpoints.apiUserJWT.isNotEmpty) {
          Endpoints.apiUserJWTPayload = Jwt.parseJwt(Endpoints.apiUserJWT);
          // debugPrint('Endpoints.apiUserJWTPayload = ${Endpoints.apiUserJWTPayload}');

          debugPrint('client.profile = ${Endpoints.apiUserJWTPayload['client']['profile']}');

          EHPMobile.loginName = Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
          EHPMobile.userName = Endpoints.apiUserJWTPayload['client']['profile']['full_name'] ?? '';

          EHPMobile.hospitalAddressCode = Endpoints.apiUserJWTPayload['client']['profile']['hospital_address_code'] ?? '';
          EHPMobile.hospitalProvinceName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_province_name'] ?? '';
          EHPMobile.hospitalDistrictName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_district_name'] ?? '';
          EHPMobile.hospitalTambolName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_tambol_name'] ?? '';
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<DateTime> getDateTimeServer(String formate) async {
    final dio.Response statusResponse = await dioClient.get(
      '/Status',
      authHeader: '',
    );
    var tempDate = DateTime.now();

    debugPrint('Status : $statusResponse');
    if (await checkResponseIsValid(statusResponse)) {
      DateTime resDT = DateTime.parse(statusResponse.data['RequestTime']);
      var dtChange = DateFormat(formate).format(resDT);
      tempDate = DateTime.parse(dtChange);
    }
    return tempDate;
  }

  Future<DateTime?> getDateTimeServerIgnoreError() async {
    log('getDateTimeServerIgnoreError....');

    try {
      final dio.Response statusResponse = await dioClient.get(
        '/Status',
        authHeader: '',
      );
      debugPrint('Status : $statusResponse');
      if (await checkResponseIsValidIgnoreError(statusResponse)) {
        return DateTime.parse(statusResponse.data['RequestTime']);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<bool> checkResponseIsValidIgnoreError(dio.Response response) async {
    log('checkResponseIsValidIgnoreError');

    if (response.statusCode == 200) {
      final rdata = (response.data as Map);

      if (response.data == null) return false;

      if (rdata.containsKey('RequestTime')) return true;

      return false;
    }

    return false;
  }

  Future<int> getSerialNumber(String serialName, String tableName, String pkName) async {
    final hcode = EHPMobile.hospitalCode.isNotEmpty
        ? EHPMobile.hospitalCode
        : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

    // final hcode = '00000';

    do {
      final dio.Response response = await dioClient.post('${Endpoints.dataPath}?Action=GetSerialNumberCheckExists',
          data: {'hospital_code': hcode, 'serial_number_name': serialName, 'table_name': tableName, 'field_name': pkName},
          authHeader: Endpoints.apiUserJWT);

      debugPrint('getSerialNumber response.data = $response.data');

      if (await checkResponseIsValid(response)) {
        return response.data['result'];
      } else {
        await showAPIErrorDialog(response);
      }
    } while (true);
  }

  Future<int> getSerialNumberChkExts(String field, String table, String field2) async {
    log('Getting SerialNumber $field Chk Exts...');
    // return await serviceLocator<EHPApi>().getSerialNumber(field, table, field);

    String presetName;
    if (Endpoints.dbType == 'mysql') {
      presetName = '00RxGetSerialnumberCheckExist-MySQL';
    } else {
      presetName = '00RxGetSerialnumberCheckExist-PostgreSQL';
    }

    final value = await serviceLocator<EHPApi>().getRestAPIWithPath('[preset]/$presetName/?xname=$field:S&xtable=$table:S&xpk=$field2:S');
    log('00RxGetSerialnumberCheckExist $field ${value[0]['result']}');
    return value[0]['result'] ?? 0;
    // return 0;
  }

  Future<int> getSerialNumberDontChkExts(String name) async {
    log('Getting SerialNumber $name ...');

    String presetName = '00RxGetSerialnumber';
    final value = await serviceLocator<EHPApi>().getRestAPIWithPath('[preset]/$presetName/?xname=$name:S');
    log('00RxGetSerialnumber $name ${value[0]['result']}');
    return value[0]['result'] ?? 0;
  }

  Future<String> getNewHN() async {
    final hcode = EHPMobile.hospitalCode.isNotEmpty
        ? EHPMobile.hospitalCode
        : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];
    final deviceModel = EHPMobile.deviceModel;
    // final hcode = '00000';
    log(Endpoints.apiUserJWT);
    log('${Endpoints.dataPath}?Action=GetNewHN&hospital_code=$hcode&computer_name=$deviceModel');
    do {
      final dio.Response response = await dioClient.post('${Endpoints.dataPath}?Action=GetNewHN',
          data: {
            'hospital_code': hcode,
            'computer_name': deviceModel,
          },
          authHeader: Endpoints.apiUserJWT);

      //debugPrint('getSerialNumber response.data = $response.data');

      if (await checkResponseIsValid(response)) {
        return response.data['result'];
      } else {
        await showAPIErrorDialog(response);
      }
    } while (true);
  }

  Future<String> getNewAN(hn) async {
    // final hcode = '00000';
    log(Endpoints.apiUserJWT);
    do {
      final dio.Response response = await dioClient.post('${Endpoints.dataPath}?Action=GetNewAN',
          data: {
            'HN': hn,
          },
          authHeader: Endpoints.apiUserJWT);

      //debugPrint('getSerialNumber response.data = $response.data');

      if (await checkResponseIsValid(response)) {
        return response.data['result'];
      } else {
        await showAPIErrorDialog(response);
      }
    } while (true);
  }

  Future<dynamic> getReport({
    required String reportName,
    required String param,
  }) async {
    bool hasError = false;

    do {
      try {
        final dio.Response response = await dioClient.get(
          '/GenerateHOSxPReport?Action=GetReportPDF&ReportName=$reportName&Param=$param',
          authHeader: Endpoints.apiUserJWT,
          options: dio.Options(responseType: dio.ResponseType.bytes),
        );

        log('response.data.runtimeType = ${response.data.runtimeType}');

        // ตรวจสอบ HTTP status code แทนการเช็ค response.data
        if (response.statusCode == 200 && response.data != null) {
          return response.data;
        } else {
          await showAPIErrorDialog(response);
        }
      } on DioExceptions catch (e) {
        log('DioExceptions: ${e.message}');
        hasError = true;
      } catch (e) {
        log('Unexpected error: $e');
        hasError = true;
        await showErrorDialog('getReport Error: $e');
      }
    } while (hasError);

    return null;
  }

  static Future<bool> initializeEHPToken() async {
    debugPrint('initializeEHPToken() start ...');

    await GetStorage.init();
    EHPMobile.prefs = GetStorage();

    /*  var initError = false;
     try {
       EHPMobile.prefs = await SharedPreferences.getInstance();
     } catch(e) {
       debugPrint('Error await SharedPreferences ${e}');
       SharedPreferences.setMockInitialValues({});
       initError = true;
     }

     if (initError) {
       debugPrint('reinit SharedPreferences');
       EHPMobile.prefs = await SharedPreferences.getInstance();
       debugPrint('EHPMobile.prefs = ${EHPMobile.prefs}');
     } */

    Endpoints.apiTokenInitOK = false;
    await serviceLocator<EHPApi>().getAPIJWT();

    debugPrint('getAPIJWT() ok');

    if (Endpoints.apiJWT.isNotEmpty) {
      await serviceLocator<EHPApi>().getAPIAccessToken();

      debugPrint('getAPIAccessToken() ok');
    } else {
      debugPrint('================= Endpoints.apiJWT isEmpty !!! ==================');
    }

    if (Endpoints.apiJWT.isNotEmpty && Endpoints.apiSessionToken.isNotEmpty) {
      Endpoints.apiTokenInitOK = true;
      return true;
    }

    debugPrint('Error initializeEHPToken() return false !!!');
    return false;
  }

  // static Future<String> getHNListFromCIDForInCondition({required String cid}) async {
  //   final data = await serviceLocator<EHPApi>().getRestAPIResponse('patient/?cid=$cid&\$field=hn&\$limit=100');

  //   if (data.data['result'] == null) {
  //     return '%27xxyyzz%27';
  //   }

  //   Iterable<dynamic> list = data.data['result'];

  //   List<String> ls = [];

  //   list.forEach((element) {
  //     ls.add('%27${element['hn']}%27');
  //   });

  //   return ls.join(',');
  // }

  // static Future<void> initEHPEndpointVariable() async {
  //   final data = await serviceLocator<EHPApi>().getRestAPIResponse('village/?village_moo=0&\$field=village_id');

  //   Endpoints.dbVillageMooZeroID = data.data['result'] == null ? 0 : data.data['result'][0]['village_id'];

  //   /* final hrcount = await serviceLocator<EHPApi>().getRestAPIDataCount(
  //       HouseRegistType.newInstance(), 'export_code[in]"1","3"');

  //   if ((hrcount ?? 0) > 0) {
  //     final hrdata = await serviceLocator<EHPApi>().getRestAPI(
  //         HouseRegistType.newInstance(),
  //         '?export_code[in]"1","3"&\$field=house_regist_type_id');

  //     List<String> rows = [];
  //     hrdata.forEach((element) {
  //       rows.add((element as HouseRegistType).house_regist_type_id.toString());
  //     });

  //     Endpoints.houseInRegionRegistTypeIDlist = rows.join(',');
  //   } */
  // }

  Future<List<EHPData>> getRestAPI(EHPData data, String idOrFilter) async {
    bool hasError = false;
    do {
      try {
        final tableName = data.getTableName();
        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        // do {
        log('API = ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');
        final dio.Response response = await dioClient.get(
          '${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter',
          //'https://bms1.blogdns.net:443/bmsapiv2uat/RestAPI/00000/$tableName/$idOrFilter',
          authHeader: Endpoints.apiUserJWT,
        );

        // debugPrint('getRestAPI response.data = $response.data');
        if (await checkResponseIsValid(response)) {
          //final List<EHPData> res = data.fromJson(response.data['result']);
          // if (!idOrFilter.contains('?')) {
          if (response.data['field'].toString().isNotEmpty) {
            EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] = response.data['field'];
          }

          Iterable l = response.data['result'];

          if (l.isNotEmpty) {
            log_dev.log('${l.first ?? ''}', name: 'first result');
          }

          final List<EHPData> res = List<EHPData>.from(l.map((model) => data.fromJson(model)));

          if (res.isNotEmpty) {
            log_dev.log('${res[0].toJson()}', name: 'first object');
          }
          return res;
        } else {
          debugPrint('showAPIErrorDialog from getRestAPI');
          await showAPIErrorDialog(response);
        }
        // } while (true);

        // return null;
      } on DioExceptions catch (e) {
        log('e.message DioExceptions >>> ${e.message}');
        log('e.message DioExceptions >>> $e');
        hasError = true;
      } catch (e) {
        debugPrint('error $e');
        if (e.toString().contains('DioError')) {
          log('e.message DioError >>> ${e.toString()}');
        } else {
          hasError = true;
          await showErrorDialog(
              'getRestAPI : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/${data.getTableName()}/$idOrFilter\n$e');
        }
      }
    } while (hasError);

    throw Exception('Failed to retrieve data from getRestAPI');
  }

  Future<dynamic> getRestAPIWithPath(String requestPath) async {
    bool hasError = false;

    do {
      try {
        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        debugPrint('start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$requestPath');

        do {
          final dio.Response response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$requestPath',
            authHeader: Endpoints.apiUserJWT,
          );

          debugPrint('getRestAPIWithPath response.data = ${response.data['result']}');

          if (await checkResponseIsValid(response)) {
            return response.data['result'];
          } else {
            debugPrint('showAPIErrorDialog from getRestAPIWithPath');
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        await showErrorDialog(
            'getRestAPIWithPath : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/$requestPath\n$e');
        hasError = true;
      }
    } while (hasError);
  }

  Future<dynamic> getRestAPIWithPathIgnoreError(String requestPath) async {
    try {
      final hcode = EHPMobile.hospitalCode.isNotEmpty
          ? EHPMobile.hospitalCode
          : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

      debugPrint('start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$requestPath');

      // do {
      final dio.Response response = await dioClient.get(
        '${Endpoints.restAPIPath}/$hcode/$requestPath',
        authHeader: Endpoints.apiUserJWT,
      );

      debugPrint('getRestAPI response.data = $response.data');

      if (await checkResponseIsValid(response)) {
        return response.data['result'];
      } else {
        // await showAPIErrorDialog(response);
      }
      //  } while (true);

      return null;
    } catch (e) {
      // rethrow;
    }
  }

  Future<bool> deleteRestAPI(EHPData data) async {
    bool hasError = false;

    do {
      try {
        final tableName = data.getTableName();

        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        debugPrint('start deleteRestAPI : ${Endpoints.restAPIPath}/$hcode/$tableName/${data.getKeyFieldValue()}');

        do {
          final dio.Response response = await dioClient.delete(
            '${Endpoints.restAPIPath}/$hcode/$tableName/${data.getKeyFieldValue()}',
            authHeader: Endpoints.apiUserJWT,
          );

          debugPrint('deleteRestAPI response.data = $response.data');

          if (await checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);

            return true;
          } else {
            debugPrint('showAPIErrorDialog from deleteRestAPI');
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'deleteRestAPI : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/${data.getTableName()}/${data.getKeyFieldValue()}\n$e');
      }
    } while (hasError);
  }

  Future<bool> deleteWithParamRestAPI(EHPData data, String filter) async {
    bool hasError = false;

    do {
      try {
        final tableName = data.getTableName();

        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        debugPrint('start deleteRestAPI : ${Endpoints.restAPIPath}/$hcode/$tableName/$filter');

        do {
          final dio.Response response = await dioClient.delete(
            '${Endpoints.restAPIPath}/$hcode/$tableName/$filter',
            authHeader: Endpoints.apiUserJWT,
          );

          debugPrint('deleteRestAPI response.data = $response.data');

          if (await checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);

            return true;
          } else {
            debugPrint('showAPIErrorDialog from deleteWithParamRestAPI');
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'deleteWithParamRestAPI : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/${data.getTableName()}/$filter\n$e');
      }
    } while (hasError);
  }

  Future<EHPData?> getRestAPISingleFirstObject(EHPData data, String idOrFilter) async {
    bool hasError = false;

    do {
      try {
        if (idOrFilter.isEmpty) {
          throw Exception('No id or filter specify');
        }

        final tableName = data.getTableName();

        // final hcode = '00000';

        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        // debugPrint(
        //     'start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');

        do {
          final dio.Response response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter',
            //'https://bms1.blogdns.net:443/bmsapiv2uat/RestAPI/00000/$tableName/$idOrFilter',
            authHeader: Endpoints.apiUserJWT,
          );

          log('getRestAPISingleFirstObject: ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');
          debugPrint('getRestAPISingleFirstObject response.data = $response.data');

          if (await checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);

            // if (!idOrFilter.contains('?')) {
            if (response.data['field'].toString().isNotEmpty) {
              EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] = response.data['field'];

              // debugPrint('ehpFieldTypeMap = ${EHPApi.ehpFieldTypeMap}');
            }
            //  }

            Iterable l = response.data['result'];
            final List<EHPData> res = List<EHPData>.from(l.map((model) => data.fromJson(model)));

            if (res.isNotEmpty) {
              // debugPrint('getRestAPI res 0 = ${res[0].toJson()}');
              return res[0];
            } else {
              return data;
            }
          } else {
            debugPrint('showAPIErrorDialog from getRestAPISingleFirstObject');
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'getRestAPISingleFirstObject : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/${data.getTableName()}/$idOrFilter\n$e');
      }
    } while (hasError);
  }

  Future<int?> getRestAPIDataCount(EHPData data, String filter) async {
    bool hasError = false;

    do {
      try {
        // if (filter.isEmpty) {
        //   throw Exception('No filter specify');
        // }

        final tableName = data.getTableName();

        // final hcode = '00000';
        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        // debugPrint(
        //     'start getRestAPIDataCount : ${Endpoints.restAPIPath}/$hcode/$tableName/?$filter');

        do {
          final dio.Response response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$tableName/?$filter&\$getcount=1',
            authHeader: Endpoints.apiUserJWT,
          );

          //  debugPrint('getRestAPIDataCount response.data = $response.data');

          if (await checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);
            debugPrint('data_count = ${response.data['result'][0]['data_count']}');
            return response.data['result'] == null ? 0 : response.data['result'][0]['data_count'];
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'getRestAPIDataCount : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/${data.getTableName()}/$filter\n$e');
      }
    } while (hasError);
  }

  Future<int?> getRestAPIDataCountWithTableName(String tableName, String filter) async {
    bool hasError = false;

    do {
      try {
        // if (filter.isEmpty) {
        //   throw Exception('No filter specify');
        // }

        // final hcode = '00000';
        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        // debugPrint(
        //     'start getRestAPIDataCount : ${Endpoints.restAPIPath}/$hcode/$tableName/?$filter');

        do {
          final dio.Response response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$tableName/?$filter&\$getcount=1',
            authHeader: Endpoints.apiUserJWT,
          );

          //  debugPrint('getRestAPIDataCount response.data = $response.data');

          log('getRestAPIDataCount:${Endpoints.restAPIPath}/$hcode/$tableName/?$filter&\$getcount=1');

          if (await checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);
            debugPrint('data_count = ${response.data['result'][0]['data_count']}');
            return response.data['result'] == null ? 0 : response.data['result'][0]['data_count'];
          } else {
            debugPrint('showAPIErrorDialog from getRestAPIDataCount');
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'getRestAPIDataCount : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/$tableName}/$filter\n$e');
      }
    } while (hasError);
  }

  Future<int?> getRestAPIDataCountWithPath(String tableName) async {
    bool hasError = false;

    do {
      try {
        // if (filter.isEmpty) {
        //   throw Exception('No filter specify');
        // }

        // final hcode = '00000';
        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        // debugPrint(
        //     'start getRestAPIDataCount : ${Endpoints.restAPIPath}/$hcode/$tableName/?$filter');

        do {
          final dio.Response response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$tableName',
            authHeader: Endpoints.apiUserJWT,
          );

          //  debugPrint('getRestAPIDataCount response.data = $response.data');

          log('getRestAPIDataCountWithPath:${Endpoints.restAPIPath}/$hcode/$tableName');

          log('getRestAPIDataCountWithPath$response');

          if (await checkResponseIsValid(response)) {
            //final List<EHPData> res = data.fromJson(response.data['result']);
            log('getRestAPIDataCountWithPath data_count = ${response.data['result'][0]['data_count']}');
            return response.data['result'] == null ? 0 : response.data['result'][0]['data_count'] ?? 0;
          } else {
            debugPrint('showAPIErrorDialog from getRestAPIDataCountWithPath');
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'getRestAPIDataCountWithPath : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/$tableName}');
      }
    } while (hasError);
  }

  Future<bool> postRestAPIData(EHPData data, String idOrFilter) async {
    bool hasError = false;
    log("postRestAPIData >>>>>>>>>>>>>>>>>>>>>");

    do {
      try {
        if (idOrFilter.isEmpty) {
          throw Exception('No id or filter specify');
        }

        final tableName = data.getTableName();

        //final hcode = '00000';
        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        log('start postRestAPIData : ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');
        log('post payload for data ${data.runtimeType.toString()} : ${data.toJson()}');

        //  log_dev.log('EHPApi.ehpFieldTypeMap ${data.runtimeType.toString()} = ${EHPApi.ehpFieldTypeMap[data.runtimeType.toString()]} count = ${((EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] as List?) ?? []).length}', name: 'post_field');
        //  log_dev.log('${data.toJson()} count = ${data.toJson().length}', name: 'post_data');

        final dio.Response response = await dioClient.post(
          '${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter',
          data: {
            'data': [data.toJson()],
            'update_field': data.getFieldNameForUpdate(),
            'field': data
                .getFieldTypeForUpdate() /* data.getFieldTypeForUpdate().isNotEmpty
                ? data.getFieldTypeForUpdate()
                : EHPApi.ehpFieldTypeMap[data.runtimeType.toString()]*/
          },
          authHeader: Endpoints.apiUserJWT,
        );

        // debugPrint('postRestAPIData response.data = $response.data');
        log_dev.log('statusCode.');
        log_dev.log(response.statusCode.toString());

        if (await checkResponseIsValid(response)) {
          if (response.data['field'].toString().isNotEmpty) {
            EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] = response.data['field'];

            // debugPrint('ehpFieldTypeMap = ${EHPApi.ehpFieldTypeMap}');
          }

          return true;
        } else {
          debugPrint('showAPIErrorDialog from postRestAPIData');
          await showAPIErrorDialog(response);
        }

        return false;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'postRestAPIData : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/${data.getTableName()}/$idOrFilter\n$e');
      }
    } while (hasError);
  }

  Future<bool> postRestAPIListData(List<EHPData> data, String idList, String idOrFilter) async {
    bool hasError = false;
    log("postRestAPIListData >>>>>>>>>>>>>>>>>>>>>");

    do {
      try {
        if (idOrFilter.isEmpty) {
          throw Exception('No id or filter specify');
        }

        final tableName = data[0].getTableName();

        // final hcode = '00000';
        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        // log('start postRestAPIData : ${Endpoints.restAPIPath}/$hcode/$tableName/$idOrFilter');
        // log('post payload for data ${data.runtimeType.toString()} : ${data.toJson()}');

        log_dev.log(
            'EHPApi.ehpFieldTypeMap ${data.runtimeType.toString()} = ${EHPApi.ehpFieldTypeMap[data.runtimeType.toString()]} count = ${((EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] as List?) ?? []).length}',
            name: 'post_field');
        log_dev.log('${data[0].toJson()} count = ${data[0].toJson().length}', name: 'post_data');

        final dataList = [];

        for (var element in data) {
          dataList.add(element.toJson());
        }

        do {
          final dio.Response response = await dioClient.post(
            '${Endpoints.restAPIPath}/$hcode/$tableName/$idList',
            data: {
              'data': dataList,
              'update_field': data[0].getFieldNameForUpdate(),
              'field': data[0]
                  .getFieldTypeForUpdate() /* data.getFieldTypeForUpdate().isNotEmpty
                ? data.getFieldTypeForUpdate()
                : EHPApi.ehpFieldTypeMap[data.runtimeType.toString()]*/
            },
            authHeader: Endpoints.apiUserJWT,
          );

          // debugPrint('postRestAPIData response.data = $response.data');
          log_dev.log('statusCode.');
          log_dev.log(response.statusCode.toString());

          if (await checkResponseIsValid(response)) {
            if (response.data['field'].toString().isNotEmpty) {
              EHPApi.ehpFieldTypeMap[data.runtimeType.toString()] = response.data['field'];

              // debugPrint('ehpFieldTypeMap = ${EHPApi.ehpFieldTypeMap}');
            }

            return true;
          } else {
            if (response.data['MessageCode'] == 401) {
              //await MyFunc().initializeEHPToken();
              await showAPIErrorDialog(response);
            } else {
              await showAPIErrorDialog(response);
            }
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'postRestAPIListData : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/${data[0].getTableName()}/$idOrFilter\n$e');
      }
    } while (hasError);
  }

  Future<bool> deleteRestAPIData(EHPData data, String id) async {
    bool hasError = false;

    do {
      try {
        if (id.isEmpty) {
          throw Exception('No id');
        }

        final tableName = data.getTableName();

        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        debugPrint('start deleteRestAPIData : ${Endpoints.restAPIPath}/$hcode/$tableName/$id');

        //  do {
        final dio.Response response = await dioClient.delete(
          '${Endpoints.restAPIPath}/$hcode/$tableName/$id',
          authHeader: Endpoints.apiUserJWT,
        );

        // debugPrint('postRestAPIData response.data = $response.data');

        if (await checkResponseIsValid(response)) {
          return true;
        } else {
          debugPrint('showAPIErrorDialog from deleteRestAPIData');
          await showAPIErrorDialog(response);
        }
        // } while (true);

        return true;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'deleteRestAPIData : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/${data.getTableName()}/$id\n$e');
      }
    } while (hasError);
  }

  Future<dio.Response> getRestAPIResponse(String requestPath) async {
    bool hasError = false;

    do {
      try {
        final hcode = EHPMobile.hospitalCode.isNotEmpty
            ? EHPMobile.hospitalCode
            : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code'];

        do {
          logFull('start getRestAPI : ${Endpoints.restAPIPath}/$hcode/$requestPath');

          final dio.Response response = await dioClient.get(
            '${Endpoints.restAPIPath}/$hcode/$requestPath',
            authHeader: Endpoints.apiUserJWT,
          );

          logFull('getRestAPI response.data = $response.data');

          if (await checkResponseIsValid(response)) {
            return response;
          } else {
            debugPrint('showAPIErrorDialog from getRestAPIResponse');
            await showAPIErrorDialog(response);
          }
        } while (true);

        // return null;
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
        await showErrorDialog(
            'getRestAPIResponse : ${Endpoints.restAPIPath}/${EHPMobile.hospitalCode.isNotEmpty ? EHPMobile.hospitalCode : Endpoints.apiUserJWTPayload['client']['profile']['organization'][0]['organization_code']}/$requestPath\n$e');
      }
    } while (hasError);
  }

  static Future<void> showAPIErrorDialog(dio.Response response) async {
    debugPrint('Log showAPIErrorDialog $response');

    while (Endpoints.errorDialogVisible) {
      await Future.delayed(const Duration(seconds: 1));
    }

    Endpoints.errorDialogVisible = true;

    try {
      await showDialog(
        context: Get.overlayContext!,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(
              useMaterial3: true,
            ),
            child: AlertDialog(
              scrollable: true,
              title: const Text("API Error", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
              content: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 500,
                  minHeight: 100,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(getAPIResponseMessage(response)),
                    const Divider(height: 10),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(
                          'Call Stack : ${getAPIResponseCallStack(response)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: GoogleFonts.inconsolata().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label: const Text("Retry"),
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('showAPIErrorDialog error: $e');
      debugPrint('showAPIErrorDialog stackTrace $stackTrace');
    } finally {
      Endpoints.errorDialogVisible = false;
    }
  }

  static Future<void> showJWTErrorDialog() async {
    debugPrint('Log showJWTErrorDialog');

    while (Endpoints.errorDialogVisible) {
      await Future.delayed(const Duration(seconds: 1));
    }

    Endpoints.errorDialogVisible = true;

    try {
      await showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(
              useMaterial3: true,
            ),
            child: AlertDialog(
              title: const Text("Your session has expired", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              content: const SizedBox(
                height: 60,
                child: Column(
                  children: [
                    Text('Please sign in again to continue using the app.'),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    //overlayColor: MyWidget().clPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label: const Text(
                    "Sign in",
                    //style: TextStyle(color: MyWidget().clPrimary),
                  ),
                  onPressed: () async {
                    //await MyWidget().clearLookup();
                    //Get.offAllNamed(Routes.SIGNIN_PROVIDER);
                    return;
                  },
                ),
              ],
            ),
          );
        },
      );
    } finally {
      Endpoints.errorDialogVisible = false;
    }
  }

  static Future<void> showJWTErrorDialogNoSignin() async {
    debugPrint('Log showJWTErrorDialog');

    while (Endpoints.errorDialogVisible) {
      await Future.delayed(const Duration(seconds: 1));
    }

    Endpoints.errorDialogVisible = true;

    try {
      await showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(
              useMaterial3: true,
            ),
            child: AlertDialog(
              title: const Text("Your session has expired", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              content: const SizedBox(
                height: 60,
                child: Column(
                  children: [
                    Text('Please sign in again to continue using the app.'),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    //overlayColor: MyWidget().clPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label: const Text(
                    "Sign in",
                    //style: TextStyle(color: MyWidget().clPrimary),
                  ),
                  onPressed: () async {
                    //await MyWidget().clearLookup();
                    Get.back();
                  },
                ),
              ],
            ),
          );
        },
      );
    } finally {
      Endpoints.errorDialogVisible = false;
    }
  }

  static Future<void> showErrorDialog(String errorMessage) async {
    debugPrint('showAPIErrorDialog $errorMessage');

    while (Endpoints.errorDialogVisible) {
      await Future.delayed(const Duration(seconds: 1));
    }

    Endpoints.errorDialogVisible = true;

    try {
      await showDialog(
        context: Get.overlayContext!,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(
              useMaterial3: true,
            ),
            child: AlertDialog(
              title: const Text("Error", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
              content: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 500,
                  minHeight: 100,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(errorMessage),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    // overlayColor: MyWidget().clPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label: const Text(
                    "Retry",
                    // style: TextStyle(color: MyWidget().clPrimary),
                  ),
                  icon: const Icon(
                    Icons.refresh,
                    // color: MyWidget().clPrimary,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          );
        },
      );
    } finally {
      Endpoints.errorDialogVisible = false;
    }
  }

  static Future<void> showErrorDialogWithClose(String errorMessage) async {
    debugPrint('showAPIErrorDialog $errorMessage');

    while (Endpoints.errorDialogVisible) {
      await Future.delayed(const Duration(seconds: 1));
    }

    Endpoints.errorDialogVisible = true;

    try {
      await showDialog(
        context: Get.overlayContext!,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(
              useMaterial3: true,
            ),
            child: AlertDialog(
              title: const Text("Error", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
              content: SizedBox(
                height: 500,
                child: Column(
                  children: [
                    Text(errorMessage),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    // overlayColor: MyWidget().clPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label: const Text(
                    "Close",
                    // style: TextStyle(color: MyWidget().clPrimary),
                  ),
                  icon: const Icon(
                    Icons.close,
                    // color: MyWidget().clPrimary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    } finally {
      Endpoints.errorDialogVisible = false;
    }
  }

  static Future<bool> checkMOPHAccountJWT() async {
    DateTime? expiryDate;

    if (Endpoints.mophAccountUser.isEmpty) {
      Get.snackbar(
        'Configuration Error',
        'Endpoints.mophAccountUser is not set',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return false;
    }

    if (Endpoints.mophAccountPassword.isEmpty) {
      Get.snackbar(
        'Configuration Error',
        'Endpoints.mophAccountPassword is not set',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return false;
    }

    try {
      expiryDate = Endpoints.mophAPIJWT.isEmpty ? null : Jwt.getExpiryDate(Endpoints.mophAPIJWT);

      if ((expiryDate ?? DateTime.fromMillisecondsSinceEpoch(0)).microsecondsSinceEpoch <
          DateTime.now().add(const Duration(minutes: -15)).microsecondsSinceEpoch) {
        final dio = serviceLocator<MOPHDioClient>();

        final response = await dio.post('?Action=get_moph_access_token', authHeader: '', data: {
          'user': Endpoints.mophAccountUser,
          'password_hash': createHmacSha256Hash(Endpoints.mophAccountPassword, '\$jwt@moph#').toUpperCase(),
          'hospital_code': Endpoints.mophAccountHospitalCode
        });

        debugPrint('get_moph_access_token rcv > ${response.data}');

        if (response.data.toString().substring(0, 3) != 'eyJ') {
          Get.snackbar(
            'Invalid MOPH-AC Response',
            response.data.toString(),
            backgroundColor: Colors.white,
            colorText: Colors.red,
          );
        }

        expiryDate = Jwt.getExpiryDate(response.data);
        debugPrint('moph jwt expire = $expiryDate');

        if ((expiryDate ?? DateTime.fromMillisecondsSinceEpoch(0)).microsecondsSinceEpoch >
            DateTime.now().add(const Duration(minutes: -15)).microsecondsSinceEpoch) {
          debugPrint('moph jwt = ${response.data}');
          Endpoints.mophAPIJWT = response.data;
          return true;
        }
      }

      return Endpoints.mophAPIJWT.isNotEmpty;
    } catch (e) {
      debugPrint('error : ${e.toString()}');
    }

    return false;
  }

  static void updateBMSVideoOnline() async {
    try {
// ss := PostCurlWithContentType('hosxp.net', '443', '/phapi/Video?Action=UpdateOnline', v, '', 'application/json', true);
      /*
    v := _obj(['hospital_code', fhospitalcode,
     'hospital_user_id', flgn,
     'hospital_name', fhospitalname,
     'location_name', UniMainModule.fcomputerdepname,
        'computer_name', MainModule.fcomputername,
        'hospital_user_name', UniMainModule.FBMSOfficerName,
         'online_datetime', Variant(d),
          'application_name', extractfilename(paramstr(0)),
          'province_name', FPingHospitalProvinceName,
          'district_name', FPingHospitalDistrictName,
           'online_id', FOnlineID,
           'idle_time', SecondsIdle,
           'video_ready',boolean2char(UniMainModule.FVideoDeviceReady),
            'client_platform', 'EHP'

        ]);


     */

      final postData = {
        'hospital_code': EHPMobile.hospitalCode,
        'hospital_user_id': EHPMobile.loginName,
        'hospital_name': EHPMobile.hospitalName,
        'location_name': EHPMobile.currentLocationName,
        'computer_name': EHPMobile.deviceModel,
        'hospital_user_name': EHPMobile.userName,
        'online_datetime': DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()),
        'application_name': 'Flutter-mobile',
        'province_name': EHPMobile.hospitalProvinceName,
        'district_name': EHPMobile.hospitalDistrictName,
        'online_id': EHPMobile.onlineID,
        'idle_time': EHPMobile.idleSecond,
        'video_ready': 'Y',
        'client_platform': EHPMobile.clientPlatformName,
        'video_version': 1,
        'fcm_token': EHPMobile.fcmToken
      };

      debugPrint('start updateBMSVideoOnline : $postData');

      final dio.Response response = await serviceLocator<EHPApi>().dioClient.post('/Video?Action=UpdateOnline', authHeader: '', data: postData);

      debugPrint('updateBMSVideoOnline response = $response.data');

      if (await checkResponseIsValid(response)) {
      } else {}

      // return null;
    } catch (e) {
      // rethrow;
    }
  }

  static Future<String> postPasteJSON(Map<String, dynamic> data) async {
    bool hasError = false;

    do {
      try {
        do {
          final dio.Response response =
              await serviceLocator<EHPApi>().dioClient.post('/PasteJSON?Action=POST', authHeader: Endpoints.apiUserJWT, data: data);

          if (await checkResponseIsValid(response)) {
            return response.data['result'].toString();
          } else {
            await showAPIErrorDialog(response);
          }
        } while (true);
      } catch (e) {
        //rethrow;
        debugPrint('error $e');
        hasError = true;
      }
    } while (hasError);
  }
}

String stripMargin(String s) {
  return s.splitMapJoin(
    RegExp(r'^', multiLine: true),
    onMatch: (_) => '\n',
    onNonMatch: (n) => n.trim(),
  );
}

void _showSnackBarWithTitle(String title, String message) {
  Get.snackbar(title, message,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent.shade700,
      icon: const Icon(
        Icons.error_sharp,
        color: Colors.yellow,
      ));
}

DateTime? tryParseBuddistDateDDMMYYYY(String inDate) {
  final dateComponent = inDate.split('/');

  if (dateComponent.length < 3) return null;

  final d = int.tryParse(dateComponent[0]) ?? 0;

  if (d > 31) return null;
  if (d < 1) return null;

  final m = int.tryParse(dateComponent[1]) ?? 0;

  if (m < 1) return null;
  if (m > 12) return null;

  final y = int.tryParse(dateComponent[2]) ?? 0;

  if (y < 2200) return null;
  if (y > 2900) return null;

  return DateFormat('d/M/yyyy').parse('$d/$m/${y - 543}');
}

void logFull(String logData) {
  log_dev.log(logData);
}
