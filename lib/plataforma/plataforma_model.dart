import 'dart:convert';

import 'package:http/http.dart' as http;

import '../resources/constants/apis.dart';

class Plataforma {
  List<PlataformaSingle> plataformaList = [];
  List<PlataformaSingle> plataformaListSearch = [];
  int view = 100;
  bool loading = false;
  Map itemsAndFlex = {
    'material': 2,
    'descripcion': 6,
    'umb': 2,
    'ctd': 2,
    'proyecto': 6,
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
    'material': [2,'e4e'],
    'descripcion': [6,'descripcion'],
    'umb': [2,'um'],
    'ctd': [2,'ctd'],
    'proyecto': [6,'proyecto'],
  };
  get keys2 => itemsAndFlex2.keys.toList();

  get listaTitulo2 {
    return [
      for (var key in keys) {'texto': itemsAndFlex2[key][1], 'flex': itemsAndFlex2[key][0]},
    ];
  }

  buscar(String busqueda) {
    plataformaListSearch = [...plataformaList];
    plataformaListSearch = plataformaList
        .where((element) =>
            element.toList().any((item) => item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }

  Future<List<PlataformaSingle>> obtener() async {
    var dataSend = {
      'dataReq': {'pdi': 'GENERAL', 'tx': 'PLATAFORMA_MB52'},
      'fname': "getSAP"
    };
    final response = await http.post(
      Uri.parse(
          Api.sam),
      body: jsonEncode(dataSend),
    );
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 =
          await http.get(Uri.parse(response.headers["location"] ?? ''));
      dataAsListMap = jsonDecode(response2.body)['dataObject'];
    } else {
      dataAsListMap = jsonDecode(response.body)['dataObject'];
    }
    // print(dataAsListMap[0]);
    for (var item in dataAsListMap) {
      plataformaList.add(PlataformaSingle.fromMap(item));
    }
    plataformaList.sort((a, b) => a.material.compareTo(b.material));
    plataformaListSearch = [...plataformaList];
    return plataformaList;
  }

  @override
  String toString() => 'Plataforma(plataforma: $plataformaList)';



  // Plataforma copyWith({
  //   List<PlataformaSingle>? plataformaList,
  //   List<PlataformaSingle>? plataformaListSearch,
  //   int? view,
  //   bool? loading,
  // }) {
  //   return Plataforma(
  //     plataformaList: plataformaList ?? this.plataformaList,
  //     plataformaListSearch: plataformaListSearch ?? this.plataformaListSearch,
  //     view: view ?? this.view,
  //     loading: loading ?? this.loading,
  //   );
  // }

  // Plataforma copyWith({
  //   List<PlataformaSingle>? plataformaList,
  //   List<PlataformaSingle>? plataformaListSearch,
  //   int? view,
  //   bool? loading,
  // }) {
  //   return Plataforma(
  //     plataformaList: plataformaList ?? this.plataformaList,
  //     plataformaListSearch: plataformaListSearch ?? this.plataformaListSearch,
  //     view: view ?? this.view,
  //     loading: loading ?? this.loading,
  //   );
  // }
}

class PlataformaSingle {
  String material;
  String descripcion;
  String umb;
  String ctd;
  String valor;
  String proyecto;
  String parte_proyecto;
  String wbe;
  String status;
  String actualizado;
  PlataformaSingle({
    required this.material,
    required this.descripcion,
    required this.umb,
    required this.ctd,
    required this.valor,
    required this.proyecto,
    required this.parte_proyecto,
    required this.wbe,
    required this.status,
    required this.actualizado,
  });

  PlataformaSingle copyWith({
    String? material,
    String? descripcion,
    String? umb,
    String? ctd,
    String? valor,
    String? proyecto,
    String? parte_proyecto,
    String? wbe,
    String? status,
    String? actualizado,
  }) {
    return PlataformaSingle(
      material: material ?? this.material,
      descripcion: descripcion ?? this.descripcion,
      umb: umb ?? this.umb,
      ctd: ctd ?? this.ctd,
      valor: valor ?? this.valor,
      proyecto: proyecto ?? this.proyecto,
      parte_proyecto: parte_proyecto ?? this.parte_proyecto,
      wbe: wbe ?? this.wbe,
      status: status ?? this.status,
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
      'proyecto': proyecto,
      'parte_proyecto': parte_proyecto,
      'wbe': wbe,
      'status': status,
      'actualizado': actualizado,
    };
  }

  factory PlataformaSingle.fromMap(Map<String, dynamic> map) {
    return PlataformaSingle(
      material: map['material'].toString(),
      descripcion: map['descripcion'].toString(),
      umb: map['umb'].toString(),
      ctd: map['ctd'].toString(),
      valor: map['valor'].toString(),
      proyecto: map['proyecto'].toString(),
      parte_proyecto: map['parte_proyecto'].toString(),
      wbe: map['wbe'].toString(),
      status: map['status'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlataformaSingle.fromJson(String source) =>
      PlataformaSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlataformaSingle(material: $material, descripcion: $descripcion, umb: $umb, ctd: $ctd, valor: $valor, proyecto: $proyecto, parte_proyecto: $parte_proyecto, wbe: $wbe, status: $status, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlataformaSingle &&
        other.material == material &&
        other.descripcion == descripcion &&
        other.umb == umb &&
        other.ctd == ctd &&
        other.valor == valor &&
        other.proyecto == proyecto &&
        other.parte_proyecto == parte_proyecto &&
        other.wbe == wbe &&
        other.status == status &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return material.hashCode ^
        descripcion.hashCode ^
        umb.hashCode ^
        ctd.hashCode ^
        valor.hashCode ^
        proyecto.hashCode ^
        parte_proyecto.hashCode ^
        wbe.hashCode ^
        status.hashCode ^
        actualizado.hashCode;
  }

  toList(){
    return [
      material,
      descripcion,
      umb,
      ctd,
      valor,
      proyecto,
      parte_proyecto,
      wbe,
      status,
      actualizado,
    ];
  }
}
