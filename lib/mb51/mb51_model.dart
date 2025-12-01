import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import '../resources/constants/apis.dart';

class Mb51 {
  List<Mb51Single> mb51List = [];
  List<Mb51Single> mb51ListSearch = [];
  int totalValor = 0;
  int view = 70;
  int view2 = 20;
  Map itemsAndFlex = {
    'documento': 2,
    'cmv': 1,
    'material': 1,
    'descripcion': 6,
    'ctd': 1,
    'umb': 1,
    'fecha': 2,
    'texto_cab': 3,
    'usuario': 4,
    'wbe': 2,
  };
  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  Map itemsAndFlex2 = {
    'documento': [2, 'doc'],
    'cmv': [1, 'cm'],
    'material': [2, 'e4e'],
    'descripcion': [6, 'descripción'],
    'ctd': [1, 'ctd'],
    'umb': [1, 'u'],
    'fecha': [2, 'fecha'],
    'texto_cab': [3, 'texto'],
    'usuario': [4, 'usuario'],
    'wbe': [2, 'Lcl'],
  };
  get keys2 {
    return itemsAndFlex2.keys.toList();
  }

  get listaTitulo2 {
    return [
      for (var key in keys2)
        {'texto': itemsAndFlex2[key][1], 'flex': itemsAndFlex2[key][0]},
    ];
  }

  buscar(String busqueda) {
    mb51ListSearch = [...mb51List];
    mb51ListSearch = mb51List
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }

  Future<List<Mb51Single>> obtener(String pdi) async {
    var dataSend = {
      'info': {'libro': pdi, 'hoja': 'MB51'},
      'fname': "getSAP"
    };
    // print(jsonEncode(dataSend));
    final response = await http.post(
      Uri.parse(
          Api.samat),
      body: jsonEncode(dataSend),
    );
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 =
          await http.get(Uri.parse(response.headers["location"] ?? ''));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }
    for (var item in dataAsListMap) {
      mb51List.add(Mb51Single.fromMap(item));
    }
    // mb51List.sort((a, b) => int.parse(a.documento).compareTo(
    //     int.parse(b.documento) +
    //         int.parse(a.material).compareTo(int.parse(b.material))));
    mb51List.sort((a, b) => DateTime.parse(a.fecha).compareTo(
        DateTime.parse(b.fecha) 
            ));
    mb51List = mb51List.reversed.toList();
    mb51ListSearch = [...mb51List];
    return mb51List;
  }

  List<Map<String, dynamic>> get porLCL {
    var dataAsListMap2 = mb51List
        .where((e) => e.wbe.isNotEmpty)
        .map((e) => {
              ...e.toMap(),
              ...{
                'ctd': int.parse(e.ctd),
                'lcl': e.wbe,
                'e4e': e.material,
                'um': e.umb,
              }
            })
        .toList();
    //agrupar y sumar por e4e
    var keysToSelect = ['lcl', 'e4e', 'descripcion', 'um'];
    var keysToSum = ['ctd'];
    var registros = groupByList(dataAsListMap2, keysToSelect, keysToSum);
    registros.sort((a, b) => int.parse('${a['lcl']}${a['e4e']}')
        .compareTo(int.parse('${b['lcl']}${b['e4e']}')));
    return registros;
  }

  List<Map<String, dynamic>> get porFuncional {
    var dataAsListMap2 = mb51List
        .where((e) => e.wbe.isNotEmpty)
        .map((e) => {
              ...e.toMap(),
              ...{
                'ctd': int.parse(e.ctd),
                'lcl': e.wbe,
                'e4e': e.material,
                'um': e.umb,
                'ingeniero_enel': e.usuario,
              }
            })
        .toList();
    //agrupar y sumar por e4e
    var keysToSelect = ['ingeniero_enel', 'e4e', 'descripcion', 'um'];
    var keysToSum = ['ctd'];
    var registros = groupByList(dataAsListMap2, keysToSelect, keysToSum);
    registros.sort((a, b) =>
        '${a['usuario']}${a['e4e']}'.compareTo('${b['usuario']}${b['e4e']}'));
    return registros;
  }

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
}

class Mb51Single {
  String documento;
  String cmv;
  String material;
  String descripcion;
  String lote;
  String lote_r;
  String ctd;
  String umb;
  String valor;
  String fecha;
  String texto_cab;
  String texto;
  String texto_vale;
  String usuario;
  String grupo;
  String referencia;
  String wbe;
  String proyecto;
  String orden;
  String actualizado;
  Mb51Single({
    required this.documento,
    required this.cmv,
    required this.material,
    required this.descripcion,
    required this.lote,
    required this.lote_r,
    required this.ctd,
    required this.umb,
    required this.valor,
    required this.fecha,
    required this.texto_cab,
    required this.texto,
    required this.texto_vale,
    required this.usuario,
    required this.grupo,
    required this.referencia,
    required this.wbe,
    required this.proyecto,
    required this.orden,
    required this.actualizado,
  });

  Map<String, dynamic> toMap() {
    return {
      'documento': documento,
      'cmv': cmv,
      'material': material,
      'descripcion': descripcion,
      'lote': lote,
      'lote_r': lote_r,
      'ctd': ctd,
      'umb': umb,
      'valor': valor,
      'fecha': fecha,
      'texto_cab': texto_cab,
      'texto': texto,
      'texto_vale': texto_vale,
      'usuario': usuario,
      'grupo': grupo,
      'referencia': referencia,
      'wbe': wbe,
      'proyecto': proyecto,
      'orden': orden,
      'actualizado': actualizado,
    };
  }

  factory Mb51Single.fromMap(Map<String, dynamic> map) {
    Mb51Single data = Mb51Single(
      documento: map['documento'].toString().replaceAll(',', '.'),
      cmv: map['cmv'].toString().replaceAll(',', '.'),
      material: map['material'].toString().replaceAll(',', '.'),
      descripcion: map['descripcion'].toString().replaceAll(',', '.'),
      lote: map['lote'].toString().replaceAll(',', '.'),
      lote_r: map['lote_r'].toString().replaceAll(',', '.'),
      ctd: map['ctd'].toString().replaceAll(',', '.'),
      umb: map['umb'].toString().replaceAll(',', '.'),
      valor: map['valor'].toString(),
      fecha: map['fecha'].toString().length > 10
          ? map['fecha'].toString().substring(0, 10)
          : map['fecha'].toString(),
      texto_cab: map['texto_cab'].toString().replaceAll(',', '.'),
      texto: map['texto'].toString().replaceAll(',', '.'),
      texto_vale: map['texto_vale'].toString().replaceAll(',', '.'),
      usuario: map['usuario'].toString().replaceAll(',', '.'),
      grupo: map['grupo'].toString().replaceAll(',', '.'),
      referencia: map['referencia'].toString().replaceAll(',', '.'),
      wbe: map['wbe'].toString(),
      proyecto: map['proyecto'].toString(),
      orden: map['orden'].toString().replaceAll(',', '.'),
      actualizado: map['actualizado'].toString().replaceAll(',', '.'),
    );
    if (!data.wbe.startsWith('63')) {
      data.orden = data.wbe;
      data.wbe = "";
    }

    if (!data.wbe.startsWith('63') &&
        data.texto_cab.startsWith('63') &&
        RegExp(r'^[+-]?\d+(\.\d+)?$')
            .hasMatch(data.texto_cab.substring(0, 10))) {
      data.wbe = data.texto_cab.substring(0, 10);
    } else if (!data.wbe.startsWith('63') &&
        data.texto.startsWith('63') &&
        RegExp(r'^[+-]?\d+(\.\d+)?$').hasMatch(data.texto.substring(0, 10))) {
      data.wbe = data.texto.substring(0, 10);
    }
    return data;
  }

  String toJson() => json.encode(toMap());

  factory Mb51Single.fromJson(String source) =>
      Mb51Single.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mb51Single(documento: $documento, cmv: $cmv, material: $material, descripcion: $descripcion, lote: $lote, lote_r: $lote_r, ctd: $ctd, umb: $umb, valor: $valor, fecha: $fecha, texto_cab: $texto_cab, texto: $texto, texto_vale: $texto_vale, usuario: $usuario, grupo: $grupo, referencia: $referencia, wbe: $wbe, proyecto: $proyecto, orden: $orden)';
  }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is Mb51Single &&
  //     other.documento == documento &&
  //     other.cmv == cmv &&
  //     other.material == material &&
  //     other.descripcion == descripcion &&
  //     other.lote == lote &&
  //     other.lote_r == lote_r &&
  //     other.ctd == ctd &&
  //     other.umb == umb &&
  //     other.valor == valor &&
  //     other.fecha == fecha &&
  //     other.texto_cab == texto_cab &&
  //     other.texto == texto &&
  //     other.texto_vale == texto_vale &&
  //     other.usuario == usuario &&
  //     other.grupo == grupo &&
  //     other.referencia == referencia &&
  //     other.wbe == wbe &&
  //     other.proyecto == proyecto &&
  //     other.orden == orden;
  // }

  @override
  int get hashCode {
    return documento.hashCode ^
        cmv.hashCode ^
        material.hashCode ^
        descripcion.hashCode ^
        lote.hashCode ^
        lote_r.hashCode ^
        ctd.hashCode ^
        umb.hashCode ^
        valor.hashCode ^
        fecha.hashCode ^
        texto_cab.hashCode ^
        texto.hashCode ^
        texto_vale.hashCode ^
        usuario.hashCode ^
        grupo.hashCode ^
        referencia.hashCode ^
        wbe.hashCode ^
        proyecto.hashCode ^
        orden.hashCode;
  }

  List<String> toList() {
    return [
      documento,
      cmv,
      material,
      descripcion,
      lote,
      lote_r,
      ctd,
      umb,
      valor,
      fecha.length > 10 ? fecha.substring(0, 10) : fecha,
      texto_cab,
      texto,
      texto_vale,
      usuario,
      grupo,
      referencia,
      wbe,
      proyecto,
      orden,
      actualizado
    ];
  }
}
