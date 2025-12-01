// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samat2co/remisiones/remisiones/model/remisiones_registros_model.dart';



class RemisionRegistro {
  String id;
  String item;
  String e4e;
  String descripcion;
  int ctd;
  String um;
  RemisionRegistro({
    required this.id,
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.ctd,
    required this.um,
  });

  get idColor => id.isEmpty? Colors.red: Colors.green;
  get itemColor => item.isEmpty? Colors.red: Colors.green;
  get e4eColor => e4e.isEmpty || e4e.length != 6 || descripcion == 'No encontrado'
          ? Colors.red
          : Colors.green;
  get descripcionColor => descripcion.isEmpty? Colors.red: Colors.green;
  get ctdColor => ctd==0? Colors.red: Colors.green;
  get umColor => um.isEmpty? Colors.red: Colors.green;

  RemisionRegistro copyWith({
    String? id,
    String? item,
    String? e4e,
    String? descripcion,
    int? ctd,
    String? um,
  }) {
    return RemisionRegistro(
      id: id ?? this.id,
      item: item ?? this.item,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      ctd: ctd ?? this.ctd,
      um: um ?? this.um,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'ctd': ctd,
      'um': um,
    };
  }

  factory RemisionRegistro.fromMap(Map<String, dynamic> map) {
    return RemisionRegistro(
      id: map['id'] as String,
      item: map['item'] as String,
      e4e: map['e4e'] as String,
      descripcion: map['descripcion'] as String,
      ctd: map['ctd'] as int,
      um: map['um'] as String,
    );
  }

  factory RemisionRegistro.fromInit(int item) {
    return RemisionRegistro(
      id: '',
      item: item.toString(),
      e4e: '',
      descripcion: '',
      ctd: 0,
      um: '',
    );
  }

  factory RemisionRegistro.fromRemisionesRegistros(
    RemisionesRegistros remisionesRegistros,
  ) {
    return RemisionRegistro(
      id: remisionesRegistros.id,
      item: remisionesRegistros.item,
      e4e: remisionesRegistros.e4e,
      descripcion: remisionesRegistros.descripcion,
      ctd: int.parse(remisionesRegistros.ctd),
      um: remisionesRegistros.um,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemisionRegistro.fromJson(String source) =>
      RemisionRegistro.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RemisionRegistro(id: $id, item: $item, e4e: $e4e, descripcion: $descripcion, ctd: $ctd, um: $um)';
  }

  @override
  bool operator ==(covariant RemisionRegistro other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.item == item &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.ctd == ctd &&
        other.um == um;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        item.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        ctd.hashCode ^
        um.hashCode;
  }
}
