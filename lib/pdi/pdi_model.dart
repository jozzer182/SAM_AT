// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart';

import '../resources/constants/apis.dart';

class Pdi {
  List<PdiSingle> pdiList = [];
  Future<List<PdiSingle>> obtener() async {
    pdiList.clear();
    var dataSend = {
      'info': {'libro': 'PDI', 'hoja': 'hoja'},
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
      pdiList.add(PdiSingle.fromMap(item));
    }
    return pdiList;
  }
}

class PdiSingle {
  String id;
  String empresa;
  String pdi;
  String nombrecorto;
  String contrato;
  PdiSingle({
    required this.id,
    required this.empresa,
    required this.pdi,
    required this.nombrecorto,
    required this.contrato,
  });

  PdiSingle copyWith({
    String? id,
    String? empresa,
    String? pdi,
    String? nombrecorto,
    String? contrato,
  }) {
    return PdiSingle(
      id: id ?? this.id,
      empresa: empresa ?? this.empresa,
      pdi: pdi ?? this.pdi,
      nombrecorto: nombrecorto ?? this.nombrecorto,
      contrato: contrato ?? this.contrato,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'empresa': empresa,
      'pdi': pdi,
      'nombrecorto': nombrecorto,
      'contrato': contrato,
    };
  }

  factory PdiSingle.fromMap(Map<String, dynamic> map) {
    return PdiSingle(
      id: map['id'].toString(),
      empresa: map['empresa'].toString(),
      pdi: map['pdi'].toString(),
      nombrecorto: map['nombrecorto'].toString(),
      contrato: map['contrato'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PdiSingle.fromJson(String source) =>
      PdiSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PdiSingle(id: $id, empresa: $empresa, pdi: $pdi, nombrecorto: $nombrecorto)';
  }

  @override
  bool operator ==(covariant PdiSingle other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.empresa == empresa &&
        other.pdi == pdi &&
        other.nombrecorto == nombrecorto;
  }

  @override
  int get hashCode {
    return id.hashCode ^ empresa.hashCode ^ pdi.hashCode ^ nombrecorto.hashCode;
  }
}
