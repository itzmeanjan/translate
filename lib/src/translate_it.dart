import 'dart:io' show HttpClient, HttpClientRequest, HttpClientResponse;
import 'dart:async' show Completer;
import 'dart:convert' show utf8, json;

/// This class simply translates text to desired language, using Yandex.Translate API
///
/// API key, compulsory parameter
///

class TranslateIt {
  String domain;
  String path;
  String apiKey;
  TranslateIt(
    this.apiKey, {
    this.domain: 'translate.yandex.net',
    this.path: '/api/v1.5/tr.json/translate',
  });

  /// Translates text to target language
  ///
  /// lang parameter can take either target `language code` or `source_language_code-destination_language_code`
  ///
  /// Example:
  ///   either
  ///     'ru'
  ///   or
  ///     'en-ru'
  ///
  /// Text parameter shouldn't increase length of 10000 characters, otherwise error message will be returned
  ///
  /// Optional named parameter type, is by default -- plain
  ///
  /// If you're interested in translating a webpage, make sure you pass html as its value
  ///
  /// And it'll take care of rest :)
  ///
  /// In case of success, returns
  ///
  /// {
  ///   'text': ' ... '
  /// }
  ///
  /// In case of error, returns
  ///
  /// {
  ///    'error': ' ... '
  /// }
  ///

  Future<Map<String, String>> translate(
    String text,
    String lang, {
    String type: 'plain',
  }) {
    var completer = Completer<Map<String, String>>();
    if (text == null || text.isEmpty || text.length > 10000)
      completer.complete({
        'error': 'Text no okay',
      });
    else
      HttpClient()
          .postUrl(
            Uri.https(domain, path, {
              'key': apiKey,
              'text': text,
              'lang': lang,
              'format': type,
            }),
          )
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
                                    'text': List<String>.from(
                                            Map<String, dynamic>.from(data)
                                                .remove('text'))
                                        .join(' ')
                                  }
                                : {
                                    'error': Map<String, dynamic>.from(data)
                                        .remove('message')
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
