// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:http/http.dart';

import '../resources/constants/apis.dart';

class Usuarios {
  List<UsuariosSingle> usuariosList = [];
  obtener() async {
    usuariosList.clear();
    var dataSend = {
      'info': {'libro': 'USUARIOS', 'hoja': 'hoja'},
      'fname': 'getHoja',
    };
    final response = await post(
      Uri.parse(Api.samat),
      body: jsonEncode(dataSend),
    );
    // print('response ${response.body}');
    var dataAsListMap;

    dataAsListMap = jsonDecode(response.body);

    for (var item in dataAsListMap) {
      usuariosList.add(UsuariosSingle.fromMap(item));
    }
    return usuariosList;
  }
}

class UsuariosSingle {
  String id;
  String correo;
  String perfil;
  String pdi;
  String telefono;
  String empresa;
  String nombrecorto;
  UsuariosSingle({
    required this.id,
    required this.correo,
    required this.perfil,
    required this.pdi,
    required this.telefono,
    required this.empresa,
    required this.nombrecorto,
  });

  UsuariosSingle copyWith({
    String? id,
    String? correo,
    String? perfil,
    String? pdi,
    String? telefono,
    String? empresa,
    String? nombrecorto,
  }) {
    return UsuariosSingle(
      id: id ?? this.id,
      correo: correo ?? this.correo,
      perfil: perfil ?? this.perfil,
      pdi: pdi ?? this.pdi,
      telefono: telefono ?? this.telefono,
      empresa: empresa ?? this.empresa,
      nombrecorto: nombrecorto ?? this.nombrecorto,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'correo': correo,
      'perfil': perfil,
      'pdi': pdi,
      'telefono': telefono,
      'empresa': empresa,
      'nombrecorto': nombrecorto,
    };
  }

  factory UsuariosSingle.fromMap(Map<String, dynamic> map) {
    return UsuariosSingle(
      id: map['id'].toString(),
      correo: map['correo'].toString(),
      perfil: map['perfil'].toString(),
      pdi: map['pdi'].toString(),
      telefono: map['telefono'].toString(),
      empresa: map['empresa'].toString(),
      nombrecorto: map['nombrecorto'].toString(),
    );
  }

  factory UsuariosSingle.fromZero() {
    return UsuariosSingle(
      id: '',
      correo: '',
      perfil: '',
      pdi: 'XXXXXXXXXX',
      telefono: '',
      empresa: '',
      nombrecorto: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuariosSingle.fromJson(String source) =>
      UsuariosSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UsusariosSingle(id: $id, correo: $correo, perfil: $perfil, pdi: $pdi, telefono: $telefono, empresa: $empresa, nombrecorto: $nombrecorto)';
  }

  @override
  bool operator ==(covariant UsuariosSingle other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.correo == correo &&
        other.perfil == perfil &&
        other.pdi == pdi &&
        other.telefono == telefono &&
        other.empresa == empresa &&
        other.nombrecorto == nombrecorto;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        correo.hashCode ^
        perfil.hashCode ^
        pdi.hashCode ^
        telefono.hashCode ^
        empresa.hashCode ^
        nombrecorto.hashCode;
  }
}
