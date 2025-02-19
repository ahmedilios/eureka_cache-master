import 'package:flutter_test/flutter_test.dart';

import 'package:eureka_cache/eureka_cache.dart';

void main() {
  /*
   * Os testes caso executados com `flutter test` não funcionarão,
   * já que plugins dependem de código nativo que não está presente
   * no ambiente de teste.
   *
   * Porém é possível testar com `flutter run -t test/$file` caso
   * o projeto seja inicializado como um aplicativo.
   */

  test('test cache', () async {
    final cache = Cache();

    await cache.clean();

    await cache.set(key: 'hello', value: {
      'hello': 'world',
    });

    final hello = await cache.get(key: 'hello');

    expect(hello['hello'], 'world');

    await cache.setList(key: 'hello', list: [
      {
        'hello': 'world',
      },
      {
        'hello': 'flutter',
      }
    ]);

    final hello2 = await cache.getList(key: 'hello');

    expect(hello2[0]['hello'], 'world');
    expect(hello2[1]['hello'], 'flutter');

    await cache.delete(key: 'hello');

    final hello3 = await cache.get(key: 'hello');

    expect(hello3, null);
  });
}
