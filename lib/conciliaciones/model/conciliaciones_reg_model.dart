import 'dart:convert';

import 'package:samat2co/resources/a_entero.dart';
import 'package:samat2co/resources/a_fecha.dart';

class ConciliacionesReg {
  int id;
  String planilla;
  String mensaje;
  DateTime fecha;
  String tipo;
  String adjunto;
  String persona;
  String estado;
  String para;
  String subestacion;
  ConciliacionesReg({
    required this.id,
    required this.planilla,
    required this.mensaje,
    required this.fecha,
    required this.tipo,
    required this.adjunto,
    required this.persona,
    required this.estado,
    required this.para,
    required this.subestacion,
  });

  ConciliacionesReg copyWith({
    int? id,
    String? planilla,
    String? mensaje,
    DateTime? fecha,
    String? tipo,
    String? adjunto,
    String? persona,
    String? estado,
    String? para,
    String? subestacion,
  }) {
    return ConciliacionesReg(
      id: id ?? this.id,
      planilla: planilla ?? this.planilla,
      mensaje: mensaje ?? this.mensaje,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      adjunto: adjunto ?? this.adjunto,
      persona: persona ?? this.persona,
      estado: estado ?? this.estado,
      para: para ?? this.para,
      subestacion: subestacion ?? this.subestacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'planilla': planilla,
      'mensaje': mensaje,
      'fecha': fecha.toIso8601String(),
      'tipo': tipo,
      'adjunto': adjunto,
      'persona': persona,
      'estado': estado,
      'para': para,
      'subestacion': subestacion,
    };
  }

  factory ConciliacionesReg.fromMap(Map<String, dynamic> map) {
    return ConciliacionesReg(
      id: aEntero(map['id'].toString()),
      planilla: map['planilla'].toString(),
      mensaje: map['mensaje'].toString(),
      fecha: aFecha(map['fecha'].toString()),
      tipo: map['tipo'].toString(),
      adjunto: map['adjunto'].toString(),
      persona: map['persona'].toString(),
      estado: map['estado'].toString(),
      para: map['para'].toString(),
      subestacion: map['subestacion'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConciliacionesReg.fromJson(String source) =>
      ConciliacionesReg.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Conciliaciones(id: $id, planilla: $planilla, mensaje: $mensaje, fecha: $fecha, tipo: $tipo, adjunto: $adjunto, persona: $persona, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConciliacionesReg &&
        other.id == id &&
        other.planilla == planilla &&
        other.mensaje == mensaje &&
        other.fecha == fecha &&
        other.tipo == tipo &&
        other.adjunto == adjunto &&
        other.persona == persona &&
        other.estado == estado;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        planilla.hashCode ^
        mensaje.hashCode ^
        fecha.hashCode ^
        tipo.hashCode ^
        adjunto.hashCode ^
        persona.hashCode ^
        estado.hashCode;
  }
}
