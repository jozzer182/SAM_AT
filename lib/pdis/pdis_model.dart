// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart';

import '../resources/constants/apis.dart';

class Pdis {
  List<PdisSingle> pdisList = [];
  Future obtener() async {
    pdisList.clear();
    Map<String, Object> dataSend = {
      'info': {'libro': 'PDIS', 'hoja': 'pdis'},
      'fname': 'getHoja'
    };
    final response = await post(
      Uri.parse(Api.samat),
      body: jsonEncode(dataSend),
    );
    // print('Response body: ${response.body}');
    for (var item in jsonDecode(response.body)) {
      pdisList.add(PdisSingle.fromMap(item));
    }
  }
}

class PdisSingle {
  String pdi;
  String nombrepdi;
  String numesp;
  String contrato;
  String direccion;
  PdisSingle({
    required this.pdi,
    required this.nombrepdi,
    required this.numesp,
    required this.contrato,
    required this.direccion,
  });

  PdisSingle copyWith({
    String? pdi,
    String? nombrepdi,
    String? numesp,
    String? contrato,
    String? direccion,
  }) {
    return PdisSingle(
      pdi: pdi ?? this.pdi,
      nombrepdi: nombrepdi ?? this.nombrepdi,
      numesp: numesp ?? this.numesp,
      contrato: contrato ?? this.contrato,
      direccion: direccion ?? this.direccion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pdi': pdi,
      'nombrepdi': nombrepdi,
      'numesp': numesp,
      'contrato': contrato,
      'direccion': direccion,
    };
  }

  factory PdisSingle.fromMap(Map<String, dynamic> map) {
    return PdisSingle(
      pdi: map['pdi'].toString(),
      nombrepdi: map['nombrepdi'].toString(),
      numesp: map['numesp'].toString(),
      contrato: map['contrato'].toString(),
      direccion: map['direccion'].toString(),
    );
  }

  factory PdisSingle.zero() {
    return PdisSingle(
      pdi: '',
      nombrepdi: '',
      numesp: '',
      contrato: '',
      direccion: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PdisSingle.fromJson(String source) =>
      PdisSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PdisSingle(pdi: $pdi, nombrepdi: $nombrepdi, numesp: $numesp, contrato: $contrato, direccion: $direccion)';
  }

  @override
  bool operator ==(covariant PdisSingle other) {
    if (identical(this, other)) return true;

    return other.pdi == pdi &&
        other.nombrepdi == nombrepdi &&
        other.numesp == numesp &&
        other.contrato == contrato &&
        other.direccion == direccion;
  }

  @override
  int get hashCode {
    return pdi.hashCode ^
        nombrepdi.hashCode ^
        numesp.hashCode ^
        contrato.hashCode ^
        direccion.hashCode;
  }
}
