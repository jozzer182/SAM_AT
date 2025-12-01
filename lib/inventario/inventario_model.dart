import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/planillas/planillas_model.dart';
import 'package:samat2co/remisiones/remisiones/model/remisiones_model.dart';

class Inventario {
  List<InventarioSingle> inventarioList = [];
  List<InventarioSingle> inventarioListSearch = [];
  int view = 50;
  Map itemsAndFlex = {
    'e4e': 2,
    'descripcion': 8,
    'um': 1,
    'ctd': 1,
  };
  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  buscar(String busqueda) {
    inventarioListSearch = [...inventarioList];
    inventarioListSearch = inventarioList
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }

  List<InventarioSingle> crear({
    required Remisiones remisiones,
    required Planillas planillas,
    required Mm60 mm60,
  }) {
    //filtrar estado correcto
    var dataAsListMap = remisiones.registrosList
        .where((e) => e.estado != 'anulado')
        .map((e) => {
              ...e.toMap(),
              ...{'ctd': int.parse(e.ctd)}
            })
        .toList();

    //agrupar y sumar
    var keysToSelect = ['e4e', 'descripcion', 'um'];
    var keysToSum = ['ctd'];
    var ingresosCalc = groupByList(dataAsListMap, keysToSelect, keysToSum);

    // print('ingresosCalc 274515 -> ${ingresosCalc.where((e) => e["e4e"] == "274515")}');

    

    //filtrar estado diferente a anulado
    var dataAsListMap2 = planillas.registrosList
        .where((e) => e.est_oficial != 'anulado' && e.estadoreg_r != 'anulado')
        .map((e) => {
              ...e.toMap(),
              ...{'ctd_total': int.parse(e.ctd_total)}
            })
        .toList();

    //agrupar y sumar
    keysToSelect = ['e4e', 'descripcion', 'um'];
    keysToSum = ['ctd_total'];
    var registrosCalc = groupByList(dataAsListMap2, keysToSelect, keysToSum);
    // change key ctd_total to ctd
    registrosCalc.asMap().forEach((key, value) {
      value['ctd'] = -value['ctd_total'];
      value.remove('ctd_total');
    });
    // print('registrosCalc 274515 -> ${registrosCalc.where((e) => e["e4e"] == "274515")}');

    //Unir ambas tablas
    var union = [...registrosCalc, ...ingresosCalc];

    // Calcular inventario
    keysToSelect = ['e4e', 'um'];
    keysToSum = ['ctd'];
    var inventario = groupByList(union, keysToSelect, keysToSum);
    // print('inventario -> $inventario');

    //filtrar inventario con ctd > 0
    inventario = inventario.where((e) => e['ctd'] > 0).toList();

    // List<InventarioSingle> resultado = [];
    for (var element in inventario) {
      inventarioList.add(InventarioSingle(
        e4e: element['e4e'].toString(),
        descripcion: mm60.mm60List
            .firstWhere((e) => e.material == element['e4e'].toString())
            .descripcion,
        um: element['um'].toString(),
        ctd: element['ctd'].toString(),
      ));
    }
    inventarioList.sort((a, b) => a.e4e.compareTo(b.e4e));
    inventarioListSearch = [...inventarioList];
    return inventarioList;
  }

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
    // print('groupAsMap = $groupAsMap');

    // try {
    //   List<Map<String, dynamic>> result = groupAsMap.entries.map((e) {
    //     Map<String, dynamic> newMap = jsonDecode(e.key);
    //     return {...newMap, ...e.value};
    //   }).toList();
    // } catch (e) {
    //   print(e);
    // }

    List<Map<String, dynamic>> result = groupAsMap.entries.map((e) {
      Map<String, dynamic> newMap = jsonDecode(e.key);
      return {...newMap, ...e.value};
    }).toList();
    // print('result = $result');

    return result;
  }

  @override
  String toString() => 'Inventario(inventarioList: $inventarioList)';
}

class InventarioSingle {
  String e4e;
  String descripcion;
  String um;
  String ctd;

  InventarioSingle({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd,
  });

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd': ctd,
    };
  }

  factory InventarioSingle.fromInit() {
    return InventarioSingle(
      e4e: 'e4e',
      descripcion: 'No hay unidades en inventario',
      um: 'um',
      ctd: '0',
    );
  }

  factory InventarioSingle.fromMap(Map<String, dynamic> map) {
    return InventarioSingle(
      e4e: map['e4e'] ?? '',
      descripcion: map['descripcion'] ?? '',
      um: map['um'] ?? '',
      ctd: map['ctd'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InventarioSingle.fromJson(String source) =>
      InventarioSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InventarioSingle(e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd)';
  }

  List<String> toList() {
    return [e4e, descripcion, um, ctd];
  }
}
