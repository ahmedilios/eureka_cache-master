import 'dart:async';
import 'dart:convert';

import './storage.dart';

/// Provê acesso à cache baseada na [CacheProvider]
class Cache {
  /// Retorna um valor da cache
  ///
  /// O parâmetro [key] especifica qual a chave para a leitura.
  Future<Map<String, dynamic>> get({String key}) async {
    final cached = await CacheProvider.read(key);

    if (cached != null) {
      return json.decode(cached.value);
    } else {
      return null;
    }
  }

  /// Retorna uma lista da cache
  ///
  /// O parâmetro  [key] especifica qual  a chave  para a leitura.  Essa leitura
  /// difere da  [get] em que ela  vai automaticamente decodificar a  lista JSON
  /// guardada dentro da cache.
  Future<List<Map<String, dynamic>>> getList({String key}) async {
    final cached = await CacheProvider.read(key);

    if (cached != null) {
      List<Map<String, dynamic>> decoded = (json.decode(cached.value) as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      return decoded;
    }

    return [];
  }

  /// Escreve um valor na cache
  ///
  /// O parâmetro  [value] será codificado em  JSON e escrito na  cache na chave
  /// [key].
  Future<void> set({
    String key,
    Map<String, dynamic> value,
  }) async =>
      await CacheProvider.write(key, JsonEncoder.withIndent('').convert(value));

  /// Escreve uma lista na cache
  ///
  /// O parâmetro  [value] será codificado em  JSON e escrito na  cache na chave
  /// [key].  Essa  escrita difere  da  [set]  em  que ela  vai  automaticamente
  /// codificar a lista num JSON para inserir na cache.
  Future<void> setList({
    String key,
    List<Map<String, dynamic>> list,
  }) async =>
      await CacheProvider.write(key, json.encode(list));

  /// Esvazia a cache
  Future<void> clean() async => await CacheProvider.clean();

  /// Deleta uma chave da cache
  ///
  /// A chave [key] e seu valor associado serão removidos da cache.
  Future<void> delete({
    String key,
  }) async =>
      await CacheProvider.delete(key);
}
