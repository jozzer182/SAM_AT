// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../resources/constants/apis.dart';

class Perfiles {
  List<PerfilesSingle> perfilesList = [];
  obtener() async {
    perfilesList.clear();
    var dataSend = {
      'info': {'libro': 'USUARIOS', 'hoja': 'perfiles'},
      'fname': 'getHoja'
    };
    final response = await http.post(
      Uri.parse(Api.samat),
      body: jsonEncode(dataSend),
    );
    // print('response ${response.body}');
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 =
          await http.get(Uri.parse(response.headers["location"] ?? ''));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }
    for (var item in dataAsListMap) {
      perfilesList.add(PerfilesSingle.fromMap(item));
    }
    return perfilesList;
  }
}

class PerfilesSingle {
  String perfil;
  String permiso;
  PerfilesSingle({
    required this.perfil,
    required this.permiso,
  });

  PerfilesSingle copyWith({
    String? perfil,
    String? permiso,
  }) {
    return PerfilesSingle(
      perfil: perfil ?? this.perfil,
      permiso: permiso ?? this.permiso,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'perfil': perfil,
      'permiso': permiso,
    };
  }

  factory PerfilesSingle.fromMap(Map<String, dynamic> map) {
    return PerfilesSingle(
      perfil: map['perfil'].toString(),
      permiso: map['permiso'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PerfilesSingle.fromJson(String source) =>
      PerfilesSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PerfilesSingle(perfil: $perfil, permiso: $permiso)';

  @override
  bool operator ==(covariant PerfilesSingle other) {
    if (identical(this, other)) return true;

    return other.perfil == perfil && other.permiso == permiso;
  }

  @override
  int get hashCode => perfil.hashCode ^ permiso.hashCode;
}
