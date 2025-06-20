import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_endpoint.dart';
import 'package:pill_line_a_i/utils/helper/shared_preference/shared_preference_helper.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../presentation/widgets/login_widget.dart';
import './provider_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginWithMophOAuthPressed>((event, emit) async {
      log('LoginWithMophOAuthPressed...');
      emit(LoginLoading());
      try {
        final idpJwt = await _loginWithMoph(event.context);
        Endpoints.apiUserJWT = idpJwt ?? '';
        log('idpJwt: $idpJwt');
        if (idpJwt == null) {
          emit(LoginFailure('คุณยกเลิกการเข้าสู่ระบบ'));
          return;
        }
        final userData = await loginUseCase.callWithMophProvider(idpJwt);
        if (userData['MessageCode'] != null && userData['MessageCode'] != 200) {
          final msg = userData['Message']?.toString() ?? 'เกิดข้อผิดพลาด';
          emit(LoginFailure('เข้าสู่ระบบล้มเหลว: $msg'));
          return;
        }
        if (event.context.mounted) {
          final jwt = Jwt.parseJwt(userData['result']);
          final profileRaw = jwt['client']?['profile'] ?? {};
          final profile = Map<String, dynamic>.from(profileRaw);
          event.context.read<ProviderBloc>().setProvider(profile: profile, token: userData['result']);
        }
        emit(LoginSuccess(userData));
      } catch (e) {
        emit(LoginFailure('เกิดข้อผิดพลาด: ${e.toString()}'));
      }
    });
  }

  Future<String?> _loginWithMoph(BuildContext context) async {
    const callbackUrlScheme = 'medconvenyorproviderid';
    final state = DateTime.now().millisecondsSinceEpoch.toString();
    final providerIDstateID = "&scope=ProviderID&state=$state";
    final url =
        'https://moph.id.th/oauth/redirect?response_type=code&client_id=9adaeaec-f199-44b2-8219-53346114fc7a&redirect_uri=$callbackUrlScheme:/$providerIDstateID';
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
        options: const FlutterWebAuth2Options(timeout: 120),
      );
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];
      if (code == null) throw Exception('No code in callback');

      // 1. แลก code เป็น access_token
      final tokenRes = await http.post(
        Uri.parse('https://moph.id.th/api/v1/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "grant_type": "authorization_code",
          "code": code,
          "redirect_uri": "$callbackUrlScheme:/",
          "client_id": '9adaeaec-f199-44b2-8219-53346114fc7a',
          "client_secret": 'KFjr0kc2fdw7p3MTIvHAjmfHqwm0tXmEouvnTGL5'
        }),
      );
      final tokenJson = jsonDecode(tokenRes.body);
      final accessToken = tokenJson['data']?['access_token'];
      if (accessToken == null) throw Exception('No access_token');

      // 2. ดึงข้อมูลบัญชี (optional)
      await http.get(
        Uri.parse('https://moph.id.th/api/v1/accounts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      // 3. แลก provider token
      final providerTokenRes = await http.post(
        Uri.parse('https://provider.id.th/api/v1/services/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "client_id": '4f85415d-b356-4eb4-aacd-5695a6b9d2bc',
          "secret_key": 'jDWetPKKH4aPmCRFhb91GKTyBUDuRwES',
          "token_by": "Health ID",
          "token": accessToken,
        }),
      );
      final providerTokenJson = jsonDecode(providerTokenRes.body);
      final providerAccessToken = providerTokenJson['data']?['access_token'];
      if (providerAccessToken == null) throw Exception('No provider access_token');

      // 4. ดึง profile staff เพื่อเอา org list
      final profileRes = await http.post(
        Uri.parse('https://provider.id.th/api/v1/services/moph-idp/profile-staff'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $providerAccessToken',
        },
        body: jsonEncode({
          "client_id": '4f85415d-b356-4eb4-aacd-5695a6b9d2bc',
          "secret_key": 'jDWetPKKH4aPmCRFhb91GKTyBUDuRwES',
        }),
      );
      final profileJson = jsonDecode(profileRes.body);
      final orgList = profileJson['data']?['organization'] as List<dynamic>?;
      if (orgList == null || orgList.isEmpty) throw Exception('ไม่พบโรงพยาบาลในบัญชีนี้');

      // 5. ถ้ามีหลาย org ให้เลือก
      dynamic selectedOrg = orgList.length == 1
          ? orgList[0]
          : await showDialog(
              context: context,
              builder: (context) => OrganizationSelectDialog(orgList: orgList),
            );
      if (selectedOrg == null) throw Exception('กรุณาเลือกโรงพยาบาล');
      final idpJwt = selectedOrg['moph_access_token_idp'];
      if (idpJwt == null) throw Exception('ไม่พบ idpJwt ใน org ที่เลือก');
      return idpJwt;
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
