import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../resources/constants/apis.dart';

class Mb52 {
  List<Mb52Single> mb52List = [];
  List<Mb52Single> mb52ListSearch = [];
  int view = 100;
  int totalValor = 0;
  Mb52();
  Map itemsAndFlex = {
    'material': 1,
    'descripcion': 6,
    'ctd': 2,
    'umb': 1,
    'valor': 2,
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
    'material': [1, 'e4e'],
    'descripcion': [6, 'descripcion'],
    'ctd': [2, 'ctd'],
    'umb': [1, 'um'],
    'valor': [2, 'valor'],
  };
  get keys2 => itemsAndFlex2.keys.toList();
  get listaTitulo2 {
    return [
      for (var key in keys)
        {'texto': itemsAndFlex2[key][1], 'flex': itemsAndFlex2[key][0]},
    ];
  }

  buscar(String busqueda) {
    mb52ListSearch = [...mb52List];
    mb52ListSearch = mb52List
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }

  Future<List<Mb52Single>> obtener(String pdi) async {
    var dataSend = {
      'info': {'libro': pdi, 'hoja': 'MB52'},
      'fname': "getSAP"
    };

    final response = await http.post(
      Uri.parse(Api.samat),
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
      mb52List.add(Mb52Single.fromMap(item));
      // print(item);
    }
    mb52ListSearch = [...mb52List];
    // print('from MB52 : $mb52ListSearch');
    total();
    return mb52List;
  }

  int total() {
    for (var item in mb52List) {
      totalValor += int.parse(item.valor);
    }
    return totalValor;
  }

  @override
  String toString() => 'Mb52(totalValor $totalValor ,mb52List: $mb52List)';

  Map<String, dynamic> toMap() {
    return {
      'mb52List': mb52List.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mb52 && listEquals(other.mb52List, mb52List);
  }

  @override
  int get hashCode => mb52List.hashCode;

  List<Object> get props => [mb52List];
}

class Mb52Single {
  final String material;
  final String descripcion;
  final String umb;
  final String ctd;
  final String valor;
  final String wbe;
  final String parte_proyecto;
  final String status;
  final String proyecto;
  final String actualizado;
  Mb52Single({
    required this.material,
    required this.descripcion,
    required this.umb,
    required this.ctd,
    required this.valor,
    required this.wbe,
    required this.parte_proyecto,
    required this.status,
    required this.proyecto,
    required this.actualizado,
  });

  Mb52Single copyWith({
    String? material,
    String? descripcion,
    String? umb,
    String? ctd,
    String? valor,
    String? wbe,
    String? parte_proyecto,
    String? status,
    String? proyecto,
    String? actualizado,
  }) {
    return Mb52Single(
      material: material ?? this.material,
      descripcion: descripcion ?? this.descripcion,
      umb: umb ?? this.umb,
      ctd: ctd ?? this.ctd,
      valor: valor ?? this.valor,
      wbe: wbe ?? this.wbe,
      parte_proyecto: parte_proyecto ?? this.parte_proyecto,
      status: status ?? this.status,
      proyecto: proyecto ?? this.proyecto,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'descripcion': descripcion,
      'umb': umb,
      'ctd': ctd,
      'valor': valor,
      'wbe': wbe,
      'parte_proyecto': parte_proyecto,
      'status': status,
      'proyecto': proyecto,
      'actualizado': actualizado,
    };
  }

  factory Mb52Single.fromMap(Map<String, dynamic> map) {
    num ctd = num.parse(map['ctd'].toString()).ceil();
    num valor = num.parse(map['valor'].toString()).ceil();
    if (map['wbe'].toString().startsWith('2')) {
      ctd = 0;
      valor = 0;
    }

    return Mb52Single(
      material: map['material'].toString(),
      descripcion: map['descripcion'].toString(),
      umb: map['umb'].toString(),
      ctd: '$ctd',
      valor: '$valor',
      wbe: map['wbe'].toString(),
      parte_proyecto: map['parte_proyecto'].toString(),
      status: map['status'].toString(),
      proyecto: map['proyecto'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  factory Mb52Single.fromInit() {
    return Mb52Single(
      material: '',
      descripcion: 'No está en MB52',
      umb: '',
      ctd: '0',
      valor: '',
      wbe: '',
      parte_proyecto: '',
      status: '',
      proyecto: '',
      actualizado: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Mb52Single.fromJson(String source) =>
      Mb52Single.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mb52Single(material: $material, descripcion: $descripcion, umb: $umb, ctd: $ctd, valor: $valor, wbe: $wbe, parte_proyecto: $parte_proyecto, status: $status, proyecto: $proyecto, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mb52Single &&
        other.material == material &&
        other.descripcion == descripcion &&
        other.umb == umb &&
        other.ctd == ctd &&
        other.valor == valor &&
        other.wbe == wbe &&
        other.parte_proyecto == parte_proyecto &&
        other.status == status &&
        other.proyecto == proyecto &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return material.hashCode ^
        descripcion.hashCode ^
        umb.hashCode ^
        ctd.hashCode ^
        valor.hashCode ^
        wbe.hashCode ^
        parte_proyecto.hashCode ^
        status.hashCode ^
        proyecto.hashCode ^
        actualizado.hashCode;
  }

  List<String> toList() {
    return [
      material,
      descripcion,
      umb,
      ctd,
      valor,
      wbe,
      parte_proyecto,
      status,
      proyecto,
      actualizado,
    ];
  }
}
