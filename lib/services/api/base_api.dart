import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pill_line_a_i/pages/widget/alert_dialog_warning/alert_dialog_warning_widget.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/dio_client.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_endpoint.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallApiController {
  // moph.id.th
  String urlHealthID = 'https://moph.id.th';
  String clientidHealthID = '9adaeaec-f199-44b2-8219-53346114fc7a';
  String secretkeyHealthID = 'KFjr0kc2fdw7p3MTIvHAjmfHqwm0tXmEouvnTGL5';
  // String clientid_HealthID = '9c42a882-3f47-4609-92c5-e4e00a8ea676';
  // String secretkey_HealthID = '0sk5z6Inwu4T52MiK4yfgYYXlBfCNiUofbTcPsb0';

  //  provider.id.th
  String urlProviderID = 'https://provider.id.th';
  String clientidProviderID = '4f85415d-b356-4eb4-aacd-5695a6b9d2bc';
  String secretkeyProviderID = 'jDWetPKKH4aPmCRFhb91GKTyBUDuRwES';
  // String clientid_ProviderID = '0c3e36fc-b911-43ce-9f92-b8edfae665de';
  // String secretkey_ProviderID = 'ErnZGAe18VRfbLHOJi9tIXo2zngKE6Rs';

  static String mophAccessTokenProvider = "";
  static String providerAccessToken = "";
  // final baseApi = Get.put(HomeGetxController());

  Future<bool> getMophTokenProvider(String code) async {
    // Path1
    String apiUrl = "https://moph.id.th/api/v1/token";

    final payload = {
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": 'baseconsentprovider:/',
      "client_id": clientidHealthID,
      "client_secret": secretkeyHealthID
    };
    log('Body $payload');
    final headers = {
      "Content-Type": "application/json",
    };

    try {
      final url = Uri.parse(apiUrl);
      final response = await http.Client().post(url, body: jsonEncode(payload), headers: headers);
      log("Provider : ${response.body}");
      Map<String, dynamic> decodedData = jsonDecode(response.body);

      if (decodedData['status_code'] == 200) {
        mophAccessTokenProvider = decodedData['data']['access_token'].toString();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      log("Error: $error");
      return false;
    }
  }

  Future<bool> getMophAccount() async {
    log('============================2===========================');
    // Path2
    String apiUrl = "https://moph.id.th/api/v1/accounts";
    final url = Uri.parse(apiUrl);

    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $mophAccessTokenProvider',
    };

    try {
      final response = await http.Client().get(url, headers: headers);
      Map<String, dynamic> decodedData = await jsonDecode(response.body);

      log('res.body Path2 : $decodedData');
      log('CID ${Jwt.parseJwt(decodedData['data']['id_card_encrypt'])}');

      if (decodedData['status_code'] == 200) {
        Map<String, dynamic> cidData = Jwt.parseJwt(decodedData['data']['id_card_encrypt']);

        EHPMobile.loginName = cidData['cid'] ?? '';
        EHPMobile.doctorCid = cidData['cid'] ?? '';

        log('EHPMobile.loginName : ${EHPMobile.loginName}');

        return true;
      } else {
        return false;
      }
    } catch (error) {
      log("Error: $error");
      return false;
    }
  }

  Future<bool> getProviderToken() async {
    log('=========================3==============================');
    // Path3
    String apiUrl = "https://provider.id.th/api/v1/services/token";
    final payload = {
      "client_id": clientidProviderID,
      "secret_key": secretkeyProviderID,
      "token_by": "Health ID",
      "token": mophAccessTokenProvider,
    };
    final headers = {
      "Content-Type": "application/json",
    };

    try {
      final url = Uri.parse(apiUrl);
      final response = await http.Client().post(url, body: jsonEncode(payload), headers: headers);
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      log('res.body Path 3 : $decodedData');
      // print("Provider GetProviderToken=" + decodedData.toString());
      if (decodedData['status'] == 200) {
        // print("MessageCode 200");

        log("ProviderID GetProviderToken Success");
        providerAccessToken = decodedData['data']['access_token'].toString();
        return true;
      } else {
        providerAccessToken = "";
        // message_th
        return false;
      }
    } catch (error) {
      log("Error: $error");
      return false;
    }
  }

  Future<bool> getProviderProfileStaff(BuildContext context) async {
    log('==========================4=============================');
    String jwt = '';
    // Path4
    String apiUrl = "https://provider.id.th/api/v1/services/moph-idp/profile-staff";
    final payload = {
      "client_id": clientidProviderID,
      "secret_key": secretkeyProviderID,
    };

    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $providerAccessToken',
    };

    try {
      final url = Uri.parse(apiUrl);
      final response = await http.Client().post(url, body: jsonEncode(payload), headers: headers);
      Map<String, dynamic> decodedData = jsonDecode(response.body);
      log('res.body Path4 $decodedData');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('providerAccessToken', providerAccessToken);
      CallApiController.providerAccessToken = providerAccessToken;
      if (decodedData['status'] == 200) {
        log("ProviderID GetProviderProfileStaff Success");
        log('---------------------------------------------');
        List<dynamic> organizationList = decodedData['data']['organization'];

        // String hash_cid = decodedData['data']['hash_cid'];
        // await prefs.setString('hash_cid', hash_cid);
        // print('dex: hash_cid $hash_cid');

        if (organizationList.isNotEmpty) {
          log('Organization List : $organizationList');

          dynamic itemHospital;

          if (organizationList.length != 1) {
            // itemHospital = await Get.to(() => SelectHospitalWidget(hList: organizationList));
            if (!context.mounted) return false;
            // final hresult = await showModalBottomSheet(
            //   isScrollControlled: true,
            //   backgroundColor: Colors.transparent,
            //   isDismissible: false,
            //   enableDrag: false,
            //   context: context,
            //   builder: (context) {
            //     return Padding(
            //       padding: MediaQuery.viewInsetsOf(context),
            //       child: SelectHospitalWidget(organizationList: organizationList),
            //     );
            //   },
            // );
            // if (hresult != null) {
            //   itemHospital = hresult['itemHospital'];
            //   await prefs.setString('hopital_index', '${hresult['index']}');
            // }

            log('itemHospital: $itemHospital');
            log('prefs hopital_index: ${prefs.getString('hopital_index')}');

            return false;
          } else {
            itemHospital = organizationList[0];
          }

          log('StaffName : ${decodedData['data']['name_th'].toString()}');
          log('StaffPosition : ${itemHospital['position'].toString()}');
          log('hospital_code : ${itemHospital['hcode'].toString()}');
          log('hospital_name : ${itemHospital['hname_th'].toString()}');

          jwt = itemHospital['moph_access_token_idp'].toString();
          Endpoints.apiIDPJWT = itemHospital['moph_access_token_idp'].toString();
          EHPMobile.userName = decodedData['data']['name_th'].toString();

          EHPMobile.hospitalCode = itemHospital['hcode'].toString();
          EHPMobile.hospitalName = itemHospital['hname_th'].toString();
        }
        log('dex:: EHPMobile.hospitalCode : ${EHPMobile.hospitalCode}');

        debugPrint('Setting EHPMobile.hospitalCode = ${EHPMobile.hospitalCode}...');
        debugPrint('Setting Old getBaseURLDio = ${serviceLocator<EHPApi>().dioClient.getBaseURLDio()}...');
        await serviceLocator<EHPApi>().dioClient.changeBaseURL('${Endpoints.baseDomain}/${EHPMobile.hospitalCode}/phapi');

        debugPrint('Setting New getBaseURLDio = ${serviceLocator<EHPApi>().dioClient.getBaseURLDio()}...');

        Endpoints.baseUrl = await serviceLocator<EHPApi>().dioClient.getBaseURLDio();

        try {
          final dio.Response statusResponse = await serviceLocator<EHPApi>().dioClient.get(
                '/Status',
                authHeader: '',
              );
          statusResponse.statusCode;
          inspect(statusResponse);

          if (statusResponse.statusCode == 404) {
            log('Check Status 404 >>>>>>>>>>>>>>>>>>>>>>>');
            if (!context.mounted) return false;
            Navigator.pop(context); // Close before loading
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.viewInsetsOf(context),
                  child: const AlertDialogWarningWidget(message: '404 Not Found'),
                );
              },
            );
          } else if (!await EHPApi.checkResponseIsValid(statusResponse) || statusResponse.statusCode == 501) {
            // ตรวจสอบถ้าค่าไม่ valid
            log('Check Status Invalid >>>>>>>>>>>>>>>>>>>>>>>');
            if (!context.mounted) return false;
            Navigator.pop(context); // Close before loading
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.viewInsetsOf(context),
                  child: const AlertDialogWarningWidget(message: 'ไม่สามารถเชื่อมต่อระบบ'),
                );
              },
            );
          } else {
            log('Check Status is OK >>>>>>>>>>>>>>>>>>>>>>');
            // DateTime resDT = DateTime.parse(statusResponse.data['RequestTime']);
          }
        } catch (e) {
          log('lonx catch $e');
        }

        log('Endpoints.apiSessionToken: ${Endpoints.apiSessionToken}');

        try {
          debugPrint('Action=USER...');
          DioClient dioClient = DioClient(dio.Dio());
          final dio.Response response = await dioClient.post(
            '${Endpoints.tokenPath}?Action=USER',
            data: {
              'moph_jwt': jwt,
            },
            authHeader: Endpoints.apiSessionToken,
          );
          if (await EHPApi.checkResponseIsValid(response)) {
            debugPrint('moph_jwt : $jwt');
            debugPrint('needOTP With Provider : $response');
            log('getUserJWTFromMOPHIDP...');
            debugPrint('result_jwt:${response.data['result']}');
            debugPrint('idp_jwt:${response.data['idp_jwt']}');

            // if (response.data['idp_jwt'] == '') {
            Endpoints.apiUserJWT = response.data['result'].toString();

            debugPrint('Endpoints.apiUserJWT = ${Endpoints.apiUserJWT}');

            if (Endpoints.apiUserJWT.isNotEmpty) {
              Endpoints.apiUserJWTPayload = Jwt.parseJwt(Endpoints.apiUserJWT);
              // debugPrint('Endpoints.apiUserJWTPayload = ${Endpoints.apiUserJWTPayload}');

              debugPrint('client.profile = ${Endpoints.apiUserJWTPayload['client']['profile']}');

              EHPMobile.doctorCid = Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
              await prefs.setString('doctor_cid', EHPMobile.doctorCid);

              EHPMobile.loginName = Endpoints.apiUserJWTPayload['client']['profile']['cid'] ?? '';
              EHPMobile.userName = Endpoints.apiUserJWTPayload['client']['profile']['full_name'] ?? '';

              EHPMobile.hospitalAddressCode = Endpoints.apiUserJWTPayload['client']['profile']['hospital_address_code'] ?? '';
              EHPMobile.hospitalProvinceName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_province_name'] ?? '';
              EHPMobile.hospitalDistrictName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_district_name'] ?? '';
              EHPMobile.hospitalTambolName = Endpoints.apiUserJWTPayload['client']['profile']['hospital_tambol_name'] ?? '';

              // final sessionManager = SessionManager();
              // await sessionManager.set("loginName", encryptMyData(EHPMobile.loginName));
              // await sessionManager.set("hospitalCode", encryptMyData(EHPMobile.hospitalCode));
              // await sessionManager.set("hospitalName", encryptMyData(EHPMobile.hospitalName));
              // await sessionManager.set("apiUserJWT", encryptMyData(Endpoints.apiUserJWT));
            }

            // } else {
            //   Response responses = await serviceLocator<EHPApi>().getUserJWTFromMOPHIDP(response.data['result'] ?? '');
            //   await EHPMobile.prefs.write('app:user:idp_jwt', EHPApi.encryptWithAES("This 32 char key have 256 bits..", response.data['idp_jwt'] ?? '').base64);
            //   debugPrint('receive responses $responses');
            // }

            log('[HospitalCode]:${EHPMobile.hospitalCode}');
            log('[ApiToken]:${Endpoints.apiJWT}');
            log('[ApiUserToken]:${Endpoints.apiUserJWT}');
          } else {
            await EHPApi.showAPIErrorDialog(response);
          }
        } catch (e) {
          debugPrint('getUserJWT ERROR:$e');
          await EHPApi.showErrorDialog(e.toString());

          //return Response(data: {}, requestOptions: RequestOptions(), statusCode: 500, statusMessage: 'Request Failed');
        }

        return true;
        // print("Provider moph_access_token_idp " + decodedData['data']['organization'][0]['moph_access_token_idp']);
      } else {
        // JWT = "";
        // await prefs.setString('ProviderAccessToken', "");
        return false;
      }
    } catch (error) {
      log("Error: $error");
      // JWT = "";
      return false;
    }
  }

  // Future<bool> GetProviderProfileStaff() async {
  //   log('==========================4=============================');
  //   String jwt = '', StaffName = '', StaffPosition = '', hospital_code = '', hospital_name = '';
  //   // Path4
  //   String apiUrl = "https://provider.id.th/api/v1/services/moph-idp/profile-staff";
  //   final payload = {
  //     "client_id": clientid_ProviderID,
  //     "secret_key": secretkey_ProviderID,
  //   };

  //   final headers = {
  //     "Content-Type": "application/json",
  //     'Authorization': 'Bearer $ProviderAccessToken',
  //   };

  //   try {
  //     final url = Uri.parse('${apiUrl}');
  //     final response = await http.Client().post(url, body: jsonEncode(payload), headers: headers);
  //     Map<String, dynamic> decodedData = jsonDecode(response.body);
  //     log('res.body Path4 ${decodedData}');
  //     // print("Provider GetProviderProfileStaff " + decodedData.toString());
  //     // print("Provider GetProviderProfileStaff " + decodedData.toString());
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('ProviderAccessToken', ProviderAccessToken);

  //     if (decodedData['status'] == 200) {
  //       log("ProviderID GetProviderProfileStaff Success");
  //       log('---------------------------------------------');
  //       List<dynamic> organizationList = decodedData['data']['organization'];
  //       print('dex: organizationList $organizationList');

  //       String hash_cid = decodedData['data']['hash_cid'];
  //       await prefs.setString('hash_cid', hash_cid);
  //       print('dex: hash_cid $hash_cid');

  //       if (organizationList.length > 0) {
  //         for (var e in organizationList) {
  //           log('JWT ${e['moph_access_token_idp'].toString()}');
  //           //     log('StaffName ${decodedData['data']['name_th'].toString()}');
  //           //     log('StaffPosition ${element['position'].toString()}');
  //           //     log('hospital_code ${element['hcode'].toString()}');
  //           //     log('hospital_name ${element['hname_th'].toString()}');
  //           jwt = e['moph_access_token_idp'].toString();
  //           Endpoints.apiIDPJWT = e['moph_access_token_idp'].toString();
  //           EHPMobile.userName = decodedData['data']['name_th'].toString();
  //           //     StaffName = decodedData['data']['name_th'].toString();
  //           //     StaffPosition = element['position'].toString();
  //           //     hospital_code = element['hcode'].toString();
  //           //     hospital_name = element['hname_th'].toString();

  //           //     // hospital_name = element['hname_th'].toString();
  //         }
  //       }
  //       DioClient dioClient = DioClient(Dio());

  //       log('Endpoints.apiSessionToken: ${Endpoints.apiSessionToken}');
  //       final Response response = await dioClient.post(
  //         '${Endpoints.tokenPath}?Action=USER',
  //         data: {
  //           'moph_jwt': jwt,
  //         },
  //         authHeader: Endpoints.apiSessionToken,
  //       );
  //       log('needOTP With Provider : ${response}');
  //       Response responses = await serviceLocator<EHPApi>().getUserJWTFromMOPHIDP(response.data['idp_jwt'] ?? '');
  //       await EHPMobile.prefs
  //           .write('app:user:idp_jwt', EHPApi.encryptWithAES("This 32 char key have 256 bits..", response.data['idp_jwt'] ?? '').base64);
  //       logFull('dex: responses $responses');

  //       // Response responses = await serviceLocator<EHPApi>().getUserJWTFromMOPHIDP(
  //       //     "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBUElATU9QSC1JRFAiLCJpYXQiOjE3MDMxNjk2MTYsImV4cCI6MTg2MTI4MTYxNiwiaXNzIjoiTU9QSC1JRFAgQ2VudGVyIiwiYXVkIjoiTU9QSC1JRFAgQVBJIiwiY2xpZW50Ijp7InN5c3RlbV9uYW1lIjoiTU9QSC1JRFAiLCJzY29wZSI6W3siY29kZSI6Ik1PUEgtSURQLVBST0ZJTEU6MSJ9LHsiY29kZSI6Ik1PUEgtSURQLUFVVEg6MSJ9XSwicm9sZSI6WyJtb3BoLWlkcC1hcGkiXSwic2NvcGVfbGlzdCI6IltNT1BILUlEUC1QUk9GSUxFOjFdW01PUEgtSURQLUFVVEg6MV0iLCJwcm9maWxlIjp7Il9pZCI6NTk4MTYwMSwiaWRwX3BlcnNvbl9pZCI6IntERkM0MThDQS1BNjI4LTQ5QTMtQTU1Ri1ERkFDNjRDMUQ0MUF9IiwiY2lkIjoiMTIwMDEwMTg0NDU3MCIsImlkcF9wZXJzb25faWRlbnRpdHlfaWQiOiJ7QzE5MTQ2MjItQkI4OS00OUI0LUI0MTgtOTlFMzg3QTBFOTkxfSIsInByZWZpeCI6IuC4mS7guKouIiwiZmlyc3RfbmFtZSI6IuC4oOC4seC4l-C4o-C4meC4seC4meC4l-C5jCIsImxhc3RfbmFtZSI6IuC4reC4uOC4m-C4iOC4seC4meC4l-C4o-C5jCIsImJpcnRoX2RhdGUiOiIxOTk5LTExLTIzIiwiZ2VuZGVyX2lkIjoyLCJnZW5kZXJfbmFtZSI6IuC4q-C4jeC4tOC4hyIsIm1vYmlsZV9waG9uZSI6IjA4MzA3OTg2NTAiLCJhZGRyZXNzX2xpbmUxIjoiOTkvMTgg4Lir4Lih4Li54LmI4LiX4Li14LmIIDMg4LiV4Liz4Lia4Lil4Lih4Liy4Lia4LmC4Lib4LmI4LiHIOC4reC4s-C5gOC4oOC4reC4nuC4suC4meC4l-C4reC4hyDguIjguLHguIfguKvguKfguLHguJTguIrguKXguJrguLjguKPguLUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIsImFkZHJlc3NfbGluZTIiOiIiLCJhZGRyZXNzX2xpbmUzIjoiIiwicHJvdmluY2VfY29kZSI6IjIwIiwiZGlzdHJpY3RfY29kZSI6IjIwMDUiLCJ0YW1ib2xfY29kZSI6IjIwMDUwMyIsIm9yZ2FuaXphdGlvbl9jb2RlIjoiOTk5OTkiLCJvcmdhbml6YXRpb25fbmFtZSI6ImJtcyDguJfguJTguKrguK3guJoiLCJwcmVmaXhfZW5nIjoiTWlzcyIsImZpcnN0X25hbWVfZW5nIjoiUGhhdGhhcmFudW4iLCJsYXN0X25hbWVfZW5nIjoiQXVwYWphbiIsImVtYWlsIjoiIiwiaXNfbW9waF9wZXJzb25uZWwiOmZhbHNlLCJla3ljX2NvbmZpcm1fdG9rZW5fY291bnQiOjAsImlkcF9kZXZpY2VfaWQiOiIiLCJjcmVhdGVfZGF0ZXRpbWUiOjEzNTgwODE5NTE0OSwidXBkYXRlX2RhdGV0aW1lIjoxMzU4MTAwMjE3MjcsIm1vcGhfcGVyc29ubmVsIjpbXX19fQ.WPsR71RMqUDSatjNrEt5cSSE-Lifs0Bbg0xzw5aU4_VnqrBOft3egv2FtvFYoYuaaoeeK8zN1dT-gJysha5IoBlB9KjHBq1NkITAn6K5YlvuQ23wZI54xKNrkXjaPnWzcoyzb7VHPz7LyNMfA_I1-eiQuub9mD8iqxFcoFIoU2AinI_Ys1o4LXFpSiRePEHi2VUXpjaScHU_bZ6cHEaj1k9McT7Q-b93qHpWcshvtpe_3cirDcofAV5tgII32mv4HIddgO7ZwjINNAYO1Og2jDJfm1dhB4R7GD823BYx01XMYgCJeNQKz-bq3J8_Z7upSh3xgQk2ApQg9ebaJnCcioaNnikBxZDXHViKn0NtgjgzwgyG7GjFqxLX-VOgL6UKvEH9QrBPRt9ldp6J80HTeowefM-zJO3njvf0cCajOpyHNOfYn2850X9hisRDLGa5BYhk-kJCypWPEKelBILuBa80hy18EZmjxGRHApUkqM_MZ8fgeRdiXqMlL3eohAyvEBXUDADx4C5b58Y_wuzyEKGtZVGeBv0mUDJZ_Gu2fb36UbZP8x3dzXFeDpi4e3mvnKGS7E19F1wzKNS0okomqdc1H0jv9I70f0ELiFzMXNtkRJhrNjW14tUDeKyeTXwwEptEvEIJtyz0SjE8mZ4FRiGhpAM1T4hjUPkfUtcoi44");
  //       // await EHPMobile.prefs.write(
  //       //     'app:user:idp_jwt',
  //       //     EHPApi.encryptWithAES("This 32 char key have 256 bits..",
  //       //             "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBUElATU9QSC1JRFAiLCJpYXQiOjE3MDMxNjk2MTYsImV4cCI6MTg2MTI4MTYxNiwiaXNzIjoiTU9QSC1JRFAgQ2VudGVyIiwiYXVkIjoiTU9QSC1JRFAgQVBJIiwiY2xpZW50Ijp7InN5c3RlbV9uYW1lIjoiTU9QSC1JRFAiLCJzY29wZSI6W3siY29kZSI6Ik1PUEgtSURQLVBST0ZJTEU6MSJ9LHsiY29kZSI6Ik1PUEgtSURQLUFVVEg6MSJ9XSwicm9sZSI6WyJtb3BoLWlkcC1hcGkiXSwic2NvcGVfbGlzdCI6IltNT1BILUlEUC1QUk9GSUxFOjFdW01PUEgtSURQLUFVVEg6MV0iLCJwcm9maWxlIjp7Il9pZCI6NTk4MTYwMSwiaWRwX3BlcnNvbl9pZCI6IntERkM0MThDQS1BNjI4LTQ5QTMtQTU1Ri1ERkFDNjRDMUQ0MUF9IiwiY2lkIjoiMTIwMDEwMTg0NDU3MCIsImlkcF9wZXJzb25faWRlbnRpdHlfaWQiOiJ7QzE5MTQ2MjItQkI4OS00OUI0LUI0MTgtOTlFMzg3QTBFOTkxfSIsInByZWZpeCI6IuC4mS7guKouIiwiZmlyc3RfbmFtZSI6IuC4oOC4seC4l-C4o-C4meC4seC4meC4l-C5jCIsImxhc3RfbmFtZSI6IuC4reC4uOC4m-C4iOC4seC4meC4l-C4o-C5jCIsImJpcnRoX2RhdGUiOiIxOTk5LTExLTIzIiwiZ2VuZGVyX2lkIjoyLCJnZW5kZXJfbmFtZSI6IuC4q-C4jeC4tOC4hyIsIm1vYmlsZV9waG9uZSI6IjA4MzA3OTg2NTAiLCJhZGRyZXNzX2xpbmUxIjoiOTkvMTgg4Lir4Lih4Li54LmI4LiX4Li14LmIIDMg4LiV4Liz4Lia4Lil4Lih4Liy4Lia4LmC4Lib4LmI4LiHIOC4reC4s-C5gOC4oOC4reC4nuC4suC4meC4l-C4reC4hyDguIjguLHguIfguKvguKfguLHguJTguIrguKXguJrguLjguKPguLUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIsImFkZHJlc3NfbGluZTIiOiIiLCJhZGRyZXNzX2xpbmUzIjoiIiwicHJvdmluY2VfY29kZSI6IjIwIiwiZGlzdHJpY3RfY29kZSI6IjIwMDUiLCJ0YW1ib2xfY29kZSI6IjIwMDUwMyIsIm9yZ2FuaXphdGlvbl9jb2RlIjoiOTk5OTkiLCJvcmdhbml6YXRpb25fbmFtZSI6ImJtcyDguJfguJTguKrguK3guJoiLCJwcmVmaXhfZW5nIjoiTWlzcyIsImZpcnN0X25hbWVfZW5nIjoiUGhhdGhhcmFudW4iLCJsYXN0X25hbWVfZW5nIjoiQXVwYWphbiIsImVtYWlsIjoiIiwiaXNfbW9waF9wZXJzb25uZWwiOmZhbHNlLCJla3ljX2NvbmZpcm1fdG9rZW5fY291bnQiOjAsImlkcF9kZXZpY2VfaWQiOiIiLCJjcmVhdGVfZGF0ZXRpbWUiOjEzNTgwODE5NTE0OSwidXBkYXRlX2RhdGV0aW1lIjoxMzU4MTAwMjE3MjcsIm1vcGhfcGVyc29ubmVsIjpbXX19fQ.WPsR71RMqUDSatjNrEt5cSSE-Lifs0Bbg0xzw5aU4_VnqrBOft3egv2FtvFYoYuaaoeeK8zN1dT-gJysha5IoBlB9KjHBq1NkITAn6K5YlvuQ23wZI54xKNrkXjaPnWzcoyzb7VHPz7LyNMfA_I1-eiQuub9mD8iqxFcoFIoU2AinI_Ys1o4LXFpSiRePEHi2VUXpjaScHU_bZ6cHEaj1k9McT7Q-b93qHpWcshvtpe_3cirDcofAV5tgII32mv4HIddgO7ZwjINNAYO1Og2jDJfm1dhB4R7GD823BYx01XMYgCJeNQKz-bq3J8_Z7upSh3xgQk2ApQg9ebaJnCcioaNnikBxZDXHViKn0NtgjgzwgyG7GjFqxLX-VOgL6UKvEH9QrBPRt9ldp6J80HTeowefM-zJO3njvf0cCajOpyHNOfYn2850X9hisRDLGa5BYhk-kJCypWPEKelBILuBa80hy18EZmjxGRHApUkqM_MZ8fgeRdiXqMlL3eohAyvEBXUDADx4C5b58Y_wuzyEKGtZVGeBv0mUDJZ_Gu2fb36UbZP8x3dzXFeDpi4e3mvnKGS7E19F1wzKNS0okomqdc1H0jv9I70f0ELiFzMXNtkRJhrNjW14tUDeKyeTXwwEptEvEIJtyz0SjE8mZ4FRiGhpAM1T4hjUPkfUtcoi44")
  //       //         .base64);
  //       // logFull('dex: responses $responses');

  //       return true;
  //       // print("Provider moph_access_token_idp " + decodedData['data']['organization'][0]['moph_access_token_idp']);
  //     } else {
  //       // JWT = "";
  //       await prefs.setString('ProviderAccessToken', "");
  //       return false;
  //     }
  //   } catch (error) {
  //     log("Error: $error");
  //     // JWT = "";
  //     return false;
  //   }
  // }
}
