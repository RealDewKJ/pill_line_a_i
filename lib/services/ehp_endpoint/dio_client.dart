import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';

import 'ehp_endpoint.dart';

class DioClient {
// dio instance
  final Dio _dio;

  // Header secret key
  // static const _secretKeyName = "X-Secret-Key";
  // static const _secretKeyValue = "BMS";

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  changeBaseURL(String baseURL) {
    _dio.options.baseUrl = baseURL;
    logFull('dex: changeBaseURL ${_dio.options.baseUrl}');
  }

  getBaseURLDio() {
    return _dio.options.baseUrl;
  }

  Future<Response> get(
    String url, {
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('dex dio.get : $url');

    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
      } else {
        _dio.options.headers.remove('Authorization');
      }

      // _dio.options.headers[_secretKeyName] = _secretKeyValue;

      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      log("authHeader $authHeader");
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }
      _dio.options.baseUrl.trim();
      log("URL $url");

      // _dio.options.headers[_secretKeyName] = _secretKeyValue;

      debugPrint('dex: post data to ${_dio.options.baseUrl}$url with data');

      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      log("Response >>> response.data.toString");
      log(response.data.toString());

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }
      // _dio.options.headers[_secretKeyName] = _secretKeyValue;

      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

class MOPHDioClient {
// dio instance
  final Dio _dio;

  MOPHDioClient(this._dio) {
    _dio
      ..options.baseUrl = '${Endpoints.mophBaseUrl}/token'
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  changeBaseURL(String baseURL) {
    _dio.options.baseUrl = baseURL;
  }

  Future<Response> get(
    String url, {
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('moph dio.get : $url');

    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //  debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      //debugPrint('Set payload data to $data');

      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      //  debugPrint('receive moph post data : $response');

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

class IDPDioClient {
// dio instance
  final Dio _dio;

  IDPDioClient(this._dio) {
    _dio
      ..options.baseUrl = Endpoints.idpBaseUrl
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('idp dio.get : $url');

    try {
      final authHeader = Endpoints.mophapiUserJWT;

      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //  debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response<dynamic>? response;
    try {
      final authHeader = Endpoints.mophapiUserJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      // debugPrint('Set payload data to $data');

      response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('receive idpapi post data : $response');

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.mophapiUserJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.mophapiUserJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

class FCMDioClient {
// dio instance
  final Dio _dio;

  FCMDioClient(this._dio) {
    _dio
      ..options.baseUrl = 'https://fcm.googleapis.com'
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  changeBaseURL(String baseURL) {
    _dio.options.baseUrl = baseURL;
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('fcm dio.get : $url');

    try {
      final authHeader = Endpoints.FCMAPIKey;

      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //  debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response<dynamic>? response;
    try {
      final authHeader = Endpoints.FCMAPIKey;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "key=$authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      _dio.options.headers["content-type"] = "application/json";

      debugPrint('post data to ${_dio.options.baseUrl} payload : $data');

      response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('receive FCM post data : $response');

      return response;
    } catch (e) {
      return response as Response;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.FCMAPIKey;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.FCMAPIKey;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

class PHRDioClient {
// dio instance
  final Dio _dio;

  PHRDioClient(this._dio) {
    _dio
      ..options.baseUrl = Endpoints.phrBaseUrl
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('phr dio.get : $url');

    try {
      final authHeader = Endpoints.mophapiUserJWT;

      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //  debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response<dynamic>? response;
    try {
      final authHeader = Endpoints.mophapiUserJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      // debugPrint('Set payload data to $data');

      response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('receive phr post data : $response');

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.mophapiUserJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.mophapiUserJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

bool validPassAllStatusCode(int? value) {
  return true;
}


// class LineClient extends DioClient {
//   LineClient(super.dio) {
//     _dio
//     ..options.baseUrl = Endpoints.lineAPIUrl
//     ..options.contentType = 'application/x-www-form-urlencoded';
//   }


// }