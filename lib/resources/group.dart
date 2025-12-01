import 'dart:convert';
import 'package:collection/collection.dart';

//Agrupar y summar los registros ingresados
List<Map<String, dynamic>> groupByList(
  List<Map<String, dynamic>> data,
  List<String> keysToSelect,
  List<String> keysToSum,
) {
  List<Map<String, dynamic>> dataKeyAsJson = data.map((e) {
    e['asJson'] = {};
    for (var key in keysToSelect) {
      e['asJson'].addAll({key: e[key]});
      e.remove(key);
    }
    e['asJson'] = jsonEncode(e['asJson']);
    return e;
  }).toList();
  // print('dataKeyAsJson = $dataKeyAsJson');

  Map<dynamic, Map<String, int>> groupAsMap =
      groupBy(dataKeyAsJson, (Map e) => e['asJson'])
          .map((key, value) => MapEntry(key, {
                for (var keySum in keysToSum)
                  keySum: value.fold<int>(0, (p, a) => p + (a[keySum] as int))
              }));

  List<Map<String, dynamic>> result = groupAsMap.entries.map((e) {
    Map<String, dynamic> newMap = jsonDecode(e.key);
    return {...newMap, ...e.value};
  }).toList();
  // print('result = $result');

  return result;
}
