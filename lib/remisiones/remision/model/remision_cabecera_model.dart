// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samat2co/remisiones/remisiones/model/remisiones_registros_model.dart';
import 'package:samat2co/user/user_model.dart';

class RemisionCabecera {
  String codigo_massy;
  String fecha_i =
      '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}';
  String almacenista_i;
  String soporte_i;
  String tel_i;
  String proyecto;
  String reportado;
  String comentario_i;
  String estado;
  String tipo;
  String pedido;
  RemisionCabecera({
    required this.codigo_massy,
    required this.fecha_i,
    required this.almacenista_i,
    required this.soporte_i,
    required this.tel_i,
    required this.proyecto,
    required this.reportado,
    required this.comentario_i,
    required this.estado,
    required this.tipo,
    required this.pedido,
  });

  get codigo_massyColor => codigo_massy.isEmpty? Colors.red: Colors.green;
  get fecha_iColor => fecha_i.isEmpty? Colors.red: Colors.green;
  get almacenista_iColor => almacenista_i.isEmpty? Colors.red: Colors.green;
  get soporte_iColor => soporte_i.isEmpty? Colors.red: Colors.green;
  get tel_iColor => tel_i.isEmpty? Colors.red: Colors.green;
  get proyectoColor => proyecto.isEmpty? Colors.red: Colors.green;
  get reportadoColor => reportado.isEmpty? Colors.red: Colors.green;
  get comentario_iColor => comentario_i.isEmpty? Colors.red: Colors.green;
  get estadoColor => estado.isEmpty? Colors.red: Colors.green;
  get tipoColor => tipo.isEmpty? Colors.red: Colors.green;
  get pedidoColor => pedido.isEmpty? Colors.red: Colors.green;

  RemisionCabecera copyWith({
    String? codigo_massy,
    String? fecha_i,
    String? almacenista_i,
    String? soporte_i,
    String? tel_i,
    String? proyecto,
    String? reportado,
    String? comentario_i,
    String? estado,
    String? tipo,
    String? pedido,
  }) {
    return RemisionCabecera(
      codigo_massy: codigo_massy ?? this.codigo_massy,
      fecha_i: fecha_i ?? this.fecha_i,
      almacenista_i: almacenista_i ?? this.almacenista_i,
      soporte_i: soporte_i ?? this.soporte_i,
      tel_i: tel_i ?? this.tel_i,
      proyecto: proyecto ?? this.proyecto,
      reportado: reportado ?? this.reportado,
      comentario_i: comentario_i ?? this.comentario_i,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
      pedido: pedido ?? this.pedido,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo_massy': codigo_massy,
      'fecha_i': fecha_i,
      'almacenista_i': almacenista_i,
      'soporte_i': soporte_i,
      'tel_i': tel_i,
      'proyecto': proyecto,
      'reportado': reportado,
      'comentario_i': comentario_i,
      'estado': estado,
      'tipo': tipo,
      'pedido': pedido,
    };
  }

  factory RemisionCabecera.fromMap(Map<String, dynamic> map) {
    return RemisionCabecera(
      codigo_massy: map['codigo_massy'] as String,
      fecha_i: map['fecha_i'] as String,
      almacenista_i: map['almacenista_i'] as String,
      soporte_i: map['soporte_i'] as String,
      tel_i: map['tel_i'] as String,
      proyecto: map['proyecto'] as String,
      reportado: map['reportado'] as String,
      comentario_i: map['comentario_i'] as String,
      estado: map['estado'] as String,
      tipo: map['tipo'] as String,
      pedido: map['pedido'] as String,
    );
  }

  factory RemisionCabecera.zero() {
    return RemisionCabecera(
      codigo_massy: '',
      fecha_i: '',
      almacenista_i: '',
      soporte_i: '',
      tel_i: '',
      proyecto: '',
      reportado: '',
      comentario_i: '',
      estado: '',
      tipo: '',
      pedido: '',
    );
  }

  factory RemisionCabecera.fromInit(User user) {
    return RemisionCabecera(
      codigo_massy: '',
      fecha_i: DateTime.now().toString(),
      almacenista_i: user.correo,
      soporte_i: '',
      tel_i: user.telefono,
      proyecto: '',
      reportado: '',
      comentario_i: '',
      estado: 'correcto',
      tipo: 'ingreso',
      pedido: '',
    );
  }

  factory RemisionCabecera.fromRemisionesRegistros(
    RemisionesRegistros remisionesRegistros,
  ) {
    return RemisionCabecera(
      codigo_massy: remisionesRegistros.codigo_massy,
      fecha_i: remisionesRegistros.fecha_i,
      almacenista_i: remisionesRegistros.almacenista_i,
      soporte_i: remisionesRegistros.soporte_i,
      tel_i: remisionesRegistros.tel_i,
      proyecto: remisionesRegistros.proyecto,
      reportado: remisionesRegistros.reportado,
      comentario_i: remisionesRegistros.comentario_i,
      estado: remisionesRegistros.estado,
      tipo: remisionesRegistros.tipo,
      pedido: remisionesRegistros.pedido,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemisionCabecera.fromJson(String source) =>
      RemisionCabecera.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RemisionCabecera(codigo_massy: $codigo_massy, fecha_i: $fecha_i, almacenista_i: $almacenista_i, soporte_i: $soporte_i, tel_i: $tel_i, proyecto: $proyecto, reportado: $reportado, comentario_i: $comentario_i, estado: $estado, tipo: $tipo)';
  }

  @override
  bool operator ==(covariant RemisionCabecera other) {
    if (identical(this, other)) return true;

    return other.codigo_massy == codigo_massy &&
        other.fecha_i == fecha_i &&
        other.almacenista_i == almacenista_i &&
        other.soporte_i == soporte_i &&
        other.tel_i == tel_i &&
        other.proyecto == proyecto &&
        other.reportado == reportado &&
        other.comentario_i == comentario_i &&
        other.estado == estado &&
        other.tipo == tipo;
  }

  @override
  int get hashCode {
    return codigo_massy.hashCode ^
        fecha_i.hashCode ^
        almacenista_i.hashCode ^
        soporte_i.hashCode ^
        tel_i.hashCode ^
        proyecto.hashCode ^
        reportado.hashCode ^
        comentario_i.hashCode ^
        estado.hashCode ^
        tipo.hashCode;
  }
}
