import 'dart:convert';

import 'package:http/http.dart' as http;

import '../resources/constants/apis.dart';

class Wbe {
  List<WbeSingle> wbeList = [];
  List<WbeSingle> wbeListSearch = [];
  int view = 70;
  Map itemsAndFlex = {
    'wbe': [2, 'wbe'],
    'descripcion': [2, 'descripcion'],
    'wbe1': [2, 'wbe1'],
    'status': [2, 'status'],
    'proyecto': [2, 'proyecto'],
  };

  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys)
        {'texto': itemsAndFlex[key][1], 'flex': itemsAndFlex[key][0]},
    ];
  }

  Future<List<WbeSingle>> obtener() async {
    var dataSend = {
      'dataReq': {'libro': 'sap', 'hoja': 'CN43N'},
      'fname': "getHojaList"
    };
    final response = await http.post(
      Uri.parse(
          Api.fem),
      body: jsonEncode(dataSend),
    );
    // print(response.body);
    List dataAsListMap;
    if (response.statusCode == 302) {
      var response2 = await http.get(Uri.parse(
          response.headers["location"].toString().replaceAll(',', '')));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }
    for (var item in dataAsListMap) {
      wbeList.add(WbeSingle.fromList(item));
    }
    wbeListSearch = [...wbeList];
    return wbeList;
  }

  buscar(String query) {
    wbeListSearch = wbeList
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(query.toLowerCase())))
        .toList();
  }
}

class WbeSingle {
  String wbe;
  String descripcion;
  String wbe1;
  String status;
  String proyecto;
  String actualizado;
  WbeSingle({
    required this.wbe,
    required this.descripcion,
    required this.wbe1,
    required this.status,
    required this.proyecto,
    required this.actualizado,
  });

  toList() {
    return [wbe, descripcion, wbe1, status, proyecto, actualizado];
  }

  WbeSingle copyWith({
    String? wbe,
    String? descripcion,
    String? wbe1,
    String? status,
    String? proyecto,
    String? actualizado,
  }) {
    return WbeSingle(
      wbe: wbe ?? this.wbe,
      descripcion: descripcion ?? this.descripcion,
      wbe1: wbe1 ?? this.wbe1,
      status: status ?? this.status,
      proyecto: proyecto ?? this.proyecto,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wbe': wbe,
      'descripcion': descripcion,
      'wbe1': wbe1,
      'status': status,
      'proyecto': proyecto,
      'actualizado': actualizado,
    };
  }

  factory WbeSingle.fromList(List l) {
    return WbeSingle(
      wbe: l[0].toString(),
      descripcion: l[1].toString(),
      wbe1: l[2].toString(),
      status: l[3].toString(),
      proyecto: l[4].toString(),
      actualizado: l[5].toString(),
    );
  }

  factory WbeSingle.fromMap(Map<String, dynamic> map) {
    return WbeSingle(
      wbe: map['wbe'].toString(),
      descripcion: map['descripcion'].toString(),
      wbe1: map['wbe1'].toString(),
      status: map['status'].toString(),
      proyecto: map['proyecto'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  factory WbeSingle.fromZero() {
    return WbeSingle(
      wbe: '',
      descripcion: 'sin dato',
      wbe1: 'sin dato',
      status: 'sin dato',
      proyecto: 'sin dato',
      actualizado: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WbeSingle.fromJson(String source) =>
      WbeSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WbeSingle(wbe: $wbe, descripcion: $descripcion, wbe1: $wbe1, status: $status, proyecto: $proyecto, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WbeSingle &&
        other.wbe == wbe &&
        other.descripcion == descripcion &&
        other.wbe1 == wbe1 &&
        other.status == status &&
        other.proyecto == proyecto &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return wbe.hashCode ^
        descripcion.hashCode ^
        wbe1.hashCode ^
        status.hashCode ^
        proyecto.hashCode ^
        actualizado.hashCode;
  }
}
