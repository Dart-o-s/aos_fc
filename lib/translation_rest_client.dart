/*
  Helper class to perform REST calls to a server, retrieving JSON
  https://github.com/LibreTranslate/LibreTranslate?tab=readme-ov-file
 */

import 'package:rest_api_client/rest_api_client.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //This must be called once per application lifetime
  await RestApiClient.initFlutter();

  RestApiClient restApiClient = RestApiClientImpl(
    options: RestApiClientOptions(
      //Defines your base API url eg. https://mybestrestapi.com
      baseUrl: 'https://libretranslate.com/',

      //Enable caching of response data
      cacheEnabled: true,
    ),
    loggingOptions: LoggingOptions(
      //Toggle logging of your requests and responses
      //to the console while debugging
      logNetworkTraffic: true,
    ),
    exceptionOptions: ExceptionOptions(
      resolveValidationErrorsMap: (response) {
        if (response != null &&
            response.data != null &&
            response.data['code'] != null) {
          return {
            'ERROR': [response.data['code']],
          };
        }

        return {};
      },
    ),
    cacheOptions: CacheOptions(
      useAuthorization: true,
      cacheLifetimeDuration: const Duration(days: 10),
      resetOnRestart: false,
    ),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Logging before request');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Logging on response');

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('Logging on error');

          return handler.next(e);
        },
      ),
    ],
  );

  //init must be called, preferably right after the instantiation
  await restApiClient.init();

  //Use restApiClient from this point on

  //If you are using authentication in you app
  //probably it would look like this

  Map<String, dynamic> headers =  <String, dynamic>{"Content-Type": "application/json"};
  RestApiClientRequestOptions options = RestApiClientRequestOptions(headers:headers, contentType: "application/json");

  final response = await restApiClient.post(
    'translate',
    data:
    """ 
{
    q: "Hello!",
    source: "en",
    target: "es",
}    
""",
  options: options,
  );

  //Extract the values from response
  var jwt = response.data['jwt'];
  var refreshToken = response.data['refreshToken'];

  //Let's asume that somehow we got jwt and refresh token
  //Probably pinged our api Authentication endpoint to get these two values
  jwt =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiZmx1dHRlciI6IkZsdXR0ZXIgaXMgYXdlc29tZSIsImNoYWxsZW5nZSI6IllvdSBtYWRlIGl0LCB5b3UgY3JhY2tlZCB0aGUgY29kZS4gWW91J3JlIGF3ZXNvbWUgdG9vLiIsImlhdCI6MTUxNjIzOTAyMn0.5QJz8hhxYsHxShS4hWKdHzcFH_IsQQZAnWSEcHJkspE';
  refreshToken = 'c91c03ea6c46a86cbc019be3d71d0a1a';

}