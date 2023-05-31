import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stepbit/utils/token_manager.dart';

class AppInterceptor {
  var dio = Dio();
  static const _baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static const _refreshEndpoint = 'gate/v1/refresh/';

  AppInterceptor() {
    dio.options = BaseOptions(baseUrl: _baseUrl);
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final accessToken = await TokenManager.getAccessToken();
      if (accessToken != null) {
        options.headers
            .putIfAbsent('Authorization', () => 'Bearer $accessToken');
      }
      handler.next(options);
    }, onError: (err, handler) async {
      if (err.response?.statusCode == HttpStatus.unauthorized) {
        try {
          final refreshToken = await TokenManager.getRefreshToken();
          if (refreshToken == null) {
            return;
          }
          await dio.post(_refreshEndpoint,
              data: {'refresh': refreshToken}).then((value) async {
            if (value.statusCode == HttpStatus.ok) {
              await TokenManager.saveTokens(value.data);
              final accessToken = await TokenManager.getAccessToken();
              err.requestOptions.headers['Authorization'] =
                  'Bearer $accessToken';

              final opts = Options(
                  method: err.requestOptions.method,
                  headers: err.requestOptions.headers);
              final reqOpts = err.requestOptions;
              final cloneReq = await dio.request(err.requestOptions.path,
                  options: opts,
                  data: reqOpts.data,
                  queryParameters: reqOpts.queryParameters,
                  cancelToken: reqOpts.cancelToken,
                  onReceiveProgress: reqOpts.onReceiveProgress,
                  onSendProgress: reqOpts.onSendProgress);
              return handler.resolve(cloneReq);
            }
          });
        } catch (e) {
          print(e);
        }
      }
    }));
  }
}
