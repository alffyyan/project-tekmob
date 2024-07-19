import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'scany_client.g.dart';

@RestApi(baseUrl: 'https')
abstract class ScanyClient {
  factory ScanyClient(Dio dio, {String baseUrl}) = _ScanyClient;


}