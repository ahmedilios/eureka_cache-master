import 'dart:core';
import 'dart:async';

import 'package:mutex/mutex.dart';
import 'package:sqflite/sqflite.dart';

/// Modelo de dados utilizado para gerenciar os valores da cache.
class CacheModel {
  /// Chave identificadora
  final String key;

  /// Valor em string
  final String value;

  /// Indica o nome da tabela no banco sqlite
  static const String tableName = 'local_cache';

  /// Indica o nome do membro [key] na tabela do banco de dados
  static const String columnKey = 'item_key';

  /// Indica o nome do membro [value] na tabela do banco de dados
  static const String columnValue = 'item_value';

  /// Constrói um [CacheModel] a partir do [map]
  CacheModel.fromMap(Map<String, dynamic> map)
      : key = map[CacheModel.columnKey],
        value = map[CacheModel.columnValue];

  /// Converte um [CacheModel] num `Map<String, dynamic>`
  Map<String, dynamic> toMap() => <String, dynamic>{
        CacheModel.columnKey: this.key,
        CacheModel.columnValue: this.value,
      };

  @override
  String toString() => 'CacheModel { ${this.key}: ${this.value} }';
}

class CacheProvider {
  static const String _path = 'cache.db';
  static Mutex _mutex = Mutex();

  static Future<Database> _open() async => await openDatabase(
        _path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
              create table ${CacheModel.tableName} (
                  ${CacheModel.columnKey} text primary key,
                  ${CacheModel.columnValue} text not null
              )
              ''');
        },
      );

  static Future<void> write(String key, String value) async {
    try {
      await CacheProvider._mutex.acquire();
      final db = await CacheProvider._open();
      await db.execute(
        '''
        insert or replace into ${CacheModel.tableName}
          (${CacheModel.columnKey}, ${CacheModel.columnValue})
          values(?, ?)
        ''',
        [key, value],
      );
      await db.close();
    } catch (err) {
      print(err);
    } finally {
      CacheProvider._mutex.release();
    }
  }

  static Future<CacheModel> read(String key) async {
    try {
      await CacheProvider._mutex.acquire();
      final db = await CacheProvider._open();

      List<Map> items = await db.query(CacheModel.tableName,
          columns: [CacheModel.columnKey, CacheModel.columnValue],
          where: '${CacheModel.columnKey} = ?',
          whereArgs: [key]);

      final item = items.isNotEmpty ? CacheModel.fromMap(items.first) : null;

      await db.close();
      return item;
    } catch (err) {
      print(err);
    } finally {
      CacheProvider._mutex.release();
    }
    return null;
  }

  static Future<void> delete(String key) async {
    try {
      await CacheProvider._mutex.acquire();
      final db = await CacheProvider._open();
      await db.delete(
        CacheModel.tableName,
        where: '${CacheModel.columnKey} = ?',
        whereArgs: [key],
      );
      await db.close();
    } catch (err) {
      print(err);
    } finally {
      CacheProvider._mutex.release();
    }
  }

  static Future<void> clean() async {
    try {
      await CacheProvider._mutex.acquire();
      final db = await CacheProvider._open();
      await db.delete(CacheModel.tableName);
      await db.close();
    } catch (err) {
      print(err);
    } finally {
      CacheProvider._mutex.release();
    }
  }

  static Future<List<CacheModel>> readAll() async {
    try {
      await CacheProvider._mutex.acquire();
      final db = await CacheProvider._open();
      final items = (await db.query(
        CacheModel.tableName,
        columns: [
          CacheModel.columnKey,
          CacheModel.columnValue,
        ],
      ))
          .map((v) => CacheModel.fromMap(v))
          .toList();
      await db.close();
      return items;
    } catch (err) {
      print(err);
    } finally {
      CacheProvider._mutex.release();
    }

    return [];
  }
}
