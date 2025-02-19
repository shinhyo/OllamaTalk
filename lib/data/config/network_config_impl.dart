import 'package:dio/dio.dart';

import '../../domain/config/network_config.dart';

class NetworkConfigImpl implements NetworkConfig {
  final Dio _dio;

  NetworkConfigImpl(this._dio);

  @override
  void updateBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }
}
