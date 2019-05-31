import 'dart:io';

import 'package:translate/translate.dart';

main() {
  /*
  Languages('api_key')
      .fetch()
      .then(
        (data) => print(data),
        onError: (e) => print(e),
      ).then((val) => exit(0));
  */
  /*
  DetectIt('api_key')
      .detect('Hello World', hint: [
        'en',
        'de',
        'ru',
        'hi',
      ]) // hints are to be prioritized by platform while detecting language, if provided
      .then(
        (data) => print(data),
        onError: (e) => print(e),
      )
      .then((val) => exit(0));
  */
  TranslateIt('api_key')
      .translate(
          '<!DOCTYPE html><html><head><title>Hello World</title></head><body><p>Hello World</p></body></html>',
          'ru',
          type: 'html')
      .then(
        (data) => print(data),
        onError: (e) => print(e),
      )
      .then((val) => exit(0));
}
