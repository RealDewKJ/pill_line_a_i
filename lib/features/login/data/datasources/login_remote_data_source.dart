import 'package:dio/dio.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';

class LoginRemoteDataSource {
  final EHPApi ehpApi;
  LoginRemoteDataSource({required this.ehpApi});
}
