import 'dart:developer';

import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';

import '../repositories/login_repository.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pill_line_a_i/utils/helper/shared_preference/shared_preference_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pill_line_a_i/features/login/presentation/bloc/provider_bloc.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_endpoint.dart';
import 'package:flutter/material.dart';

class LoginUseCase {
  final LoginRepository repository;
  LoginUseCase({required this.repository});

  // Future<Map<String, dynamic>> call(String username, String password) async {
  //   final userData = await repository.login(username, password);
  //   // await _handleLoginSideEffects(userData);
  //   return userData;
  // }

  Future<Map<String, dynamic>> callWithMophProvider(String sjwt) async {
    log('callWithMophProvider... $sjwt', name: 'callWithMophProvider');
    final response = await serviceLocator<EHPApi>().getUserJWTFromMOPHIDP(sjwt);
    log('response form callWithMophProvider: $response', name: 'callWithMophProvider');

    if (response.data['MessageCode'] != 200) {
      return response.data;
    }

    final token = response.data['result']?.toString() ?? '';
    await _handleLoginSideEffects(token);
    return response.data;
  }

  Future<void> _handleLoginSideEffects(String sjwt) async {
    final token = sjwt;
    if (token.isNotEmpty) {
      final jwt = Jwt.parseJwt(token);
      log('jwt: $jwt');
      final profile = jwt['client']?['profile'] ?? {};
      await SharedPrefHelper.prefs.setString('providerAccessToken', token);
      await SharedPrefHelper.prefs.setString('provider_id', profile['cid'] ?? '');
      await SharedPrefHelper.prefs.setString('provider_special_title_th', profile['special_title_th'] ?? '');
      await SharedPrefHelper.prefs.setString('provider_firstname_th', profile['first_name'] ?? '');
      await SharedPrefHelper.prefs.setString('provider_name_th', profile['full_name'] ?? '');
      await SharedPrefHelper.prefs.setString('provider_hname_th', profile['hospital_name'] ?? '');
      await SharedPrefHelper.prefs.setString('provider_hcode9', profile['hospital_address_code'] ?? '');
      await SharedPrefHelper.prefs.setString('provider_position_std_id', profile['position_std_id']?.toString() ?? '');
      await SharedPrefHelper.prefs.setString('provider_position_std_type_id', profile['position_std_type_id']?.toString() ?? '');
      await SharedPrefHelper.prefs.setString('profile_full_name', profile['full_name'] ?? '');
      await SharedPrefHelper.prefs.setString('profile_cid', profile['cid'] ?? '');
      await SharedPrefHelper.prefs.setString('profile_hname', profile['hospital_name'] ?? '');
      await SharedPrefHelper.prefs.setString('apiUserJWT', token);
    }
  }
}

class ProviderState extends Equatable {
  final Map<String, dynamic>? profile;
  final String? token;

  const ProviderState({this.profile, this.token});

  @override
  List<Object?> get props => [profile, token];
}

class ProviderInitial extends ProviderState {}

class ProviderLoaded extends ProviderState {
  const ProviderLoaded({required Map<String, dynamic> profile, required String token}) : super(profile: profile, token: token);
}
