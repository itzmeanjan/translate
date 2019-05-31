import 'dart:io';

import 'package:translate/translate.dart';

main() {
  /*
  Languages(
          'trnsl.1.1.20171124T201412Z.292a89b138e81645.b1960fd9b9898e23c4febba217577bb5d0ea06d9')
      .fetch()
      .then(
        (data) => print(data),
        onError: (e) => print(e),
      ).then((val) => exit(0));
  */
  /*
  DetectIt(
          'trnsl.1.1.20171124T201412Z.292a89b138e81645.b1960fd9b9898e23c4febba217577bb5d0ea06d9')
      .detect('Hello World', hint: [
        'en',
        'de',
        'ru',
        'hi',
      ]) // hints are to prioritized by platform while detecting language, if provided
      .then(
        (data) => print(data),
        onError: (e) => print(e),
      )
      .then((val) => exit(0));
  */
  TranslateIt(
          'trnsl.1.1.20171124T201412Z.292a89b138e81645.b1960fd9b9898e23c4febba217577bb5d0ea06d9')
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
