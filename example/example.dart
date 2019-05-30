import 'package:translate/translate.dart';

main() {
  Languages(
          'trnsl.1.1.20171124T201412Z.292a89b138e81645.b1960fd9b9898e23c4febba217577bb5d0ea06d9')
      .fetch()
      .then(
        (data) => print(data),
        onError: (e) => print(e),
      );
}
