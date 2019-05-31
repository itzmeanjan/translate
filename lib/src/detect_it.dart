import 'dart:io' show HttpClient, HttpClientRequest, HttpClientResponse;
import 'dart:async' show Completer;
import 'dart:convert' show utf8, json;

/// This class simply detects language of text, using Yandex.Translate API
///
/// API key, compulsory parameter
///

class DetectIt {
  String domain;
  String path;
  String apiKey;
  DetectIt(
    this.apiKey, {
    this.domain: 'translate.yandex.net',
    this.path: '/api/v1.5/tr.json/detect',
  });

  /// Detects which language provided text belongs to
  ///
  /// In case of success, returns
  ///
  /// {
  ///   'lang': 'en'
  /// }
  ///
  /// In case of error, returns
  ///
  /// {
  ///    'error': ' ... '
  /// }
  ///
  /// You may also pass a list of language codes, as `hint`, which will be prioritized while detecting language
  ///

  Future<Map<String, String>> detect(
    String text, {
    List<String> hint,
  }) {
    var completer = Completer<Map<String, String>>();
    if (text == null || text.isEmpty)
      completer.complete({
        'error': 'Text no okay',
      });
    else
      HttpClient()
          .getUrl(Uri.https(
              domain,
              path,
              hint != null && hint.isNotEmpty
                  ? {
                      'key': apiKey,
                      'text': text,
                      'hint': hint.join(','),
                    }
                  : {
                      'key': apiKey,
                      'text': text,
                    }))
          .then(
            (HttpClientRequest request) => request.close(),
            onError: (e) => completer.complete({
                  'error': e.toString(),
                }),
          )
          .then(
            (HttpClientResponse response) =>
                response.transform(utf8.decoder).transform(json.decoder).listen(
                      (data) => completer.complete(
                            response.statusCode == 200
                                ? {
                                    'lang': Map<String, dynamic>.from(data)
                                        .remove('lang') as String
                                  }
                                : {
                                    'error': Map<String, dynamic>.from(data)
                                        .remove('message') as String
                                  },
                          ),
                      onError: (e) => completer.complete({
                            'error': e.toString(),
                          }),
                      cancelOnError: true,
                    ),
            onError: (e) => completer.complete({
                  'error': e.toString(),
                }),
          );
    return completer.future;
  }
}
