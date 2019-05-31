import 'dart:io' show HttpClient, HttpClientRequest, HttpClientResponse;
import 'dart:async' show Completer;
import 'dart:convert' show utf8, json;

/// Helps in fetching list of languages supported by Platform
///
/// Requires to pass an API Key, which can be obtained from https://translate.yandex.com/developers/keys
class Languages {
  String domain;
  String path;
  String apiKey;
  String langCode;
  Languages(
    this.apiKey, {
    this.domain: 'translate.yandex.net',
    this.path: '/api/v1.5/tr.json/getLangs',
    this.langCode: 'en',
  });

  /// This method fetches list of languages supported by platform
  ///
  /// To which you can translate or these languages can be detected
  ///
  /// In case of success, returns
  /// {
  ///   .
  ///   .
  ///   .
  ///   'ru': 'Russian'
  ///   'en': 'English',
  ///   .
  ///   .
  ///   .
  /// }
  ///
  /// In case of error, returns
  /// {
  ///   'error': ' ... '
  /// }
  ///

  Future<Map<String, String>> fetch() {
    var completer = Completer<Map<String, String>>();
    HttpClient()
        .getUrl(Uri.https(domain, path, {
          'key': apiKey,
          'ui': langCode,
        }))
        .then(
          (HttpClientRequest request) => request.close(),
          onError: (e) => completer.complete({}),
        )
        .then(
          (HttpClientResponse response) => response
              .transform(utf8.decoder)
              .transform(json.decoder)
              .listen(
                (data) => completer.complete(
                      response.statusCode == 200
                          ? Map<String, String>.from(
                              Map<String, dynamic>.from(data).remove('langs'))
                          : {
                              'error': Map<String, dynamic>.from(data)
                                  .remove('message') as String
                            },
                    ),
                onError: (e) => completer.complete({}),
                cancelOnError: true,
              ),
          onError: (e) => completer.complete({}),
        );
    return completer.future;
  }
}
