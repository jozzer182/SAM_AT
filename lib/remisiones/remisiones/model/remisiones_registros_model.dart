// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RemisionesRegistros {
  String id;
  String pedido;
  String codigo_massy;
  String fecha_i;
  String almacenista_i;
  String tel_i;
  String soporte_i;
  String item;
  String e4e;
  String descripcion;
  String um;
  String ctd;
  String proyecto;
  String ingeniero_enel;
  String almacenista_r;
  String tel_r;
  String fecha_r;
  String unidad_r;
  String soporte_r;
  String reportado;
  String comentario_i;
  String estado;
  String tipo;
  RemisionesRegistros({
    required this.id,
    required this.pedido,
    required this.codigo_massy,
    required this.fecha_i,
    required this.almacenista_i,
    required this.tel_i,
    required this.soporte_i,
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd,
    required this.proyecto,
    required this.ingeniero_enel,
    required this.almacenista_r,
    required this.tel_r,
    required this.fecha_r,
    required this.unidad_r,
    required this.soporte_r,
    required this.reportado,
    required this.comentario_i,
    required this.estado,
    required this.tipo,
  });
  toList(){
    return [
      id,
      pedido,
      codigo_massy,
      fecha_i,
      almacenista_i,
      tel_i,
      soporte_i,
      item,
      e4e,
      descripcion,
      um,
      ctd,
      proyecto,
      ingeniero_enel,
      almacenista_r,
      tel_r,
      fecha_r,
      unidad_r,
      soporte_r,
      reportado,
      comentario_i,
      estado,
      tipo,
    ];
  }

  RemisionesRegistros copyWith({
    String? id,
    String? pedido,
    String? codigo_massy,
    String? fecha_i,
    String? almacenista_i,
    String? tel_i,
    String? soporte_i,
    String? item,
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd,
    String? proyecto,
    String? ingeniero_enel,
    String? almacenista_r,
    String? tel_r,
    String? fecha_r,
    String? unidad_r,
    String? soporte_r,
    String? reportado,
    String? comentario_i,
    String? estado,
    String? tipo,
  }) {
    return RemisionesRegistros(
      id: id ?? this.id,
      pedido: pedido ?? this.pedido,
      codigo_massy: codigo_massy ?? this.codigo_massy,
      fecha_i: fecha_i ?? this.fecha_i,
      almacenista_i: almacenista_i ?? this.almacenista_i,
      tel_i: tel_i ?? this.tel_i,
      soporte_i: soporte_i ?? this.soporte_i,
      item: item ?? this.item,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd: ctd ?? this.ctd,
      proyecto: proyecto ?? this.proyecto,
      ingeniero_enel: ingeniero_enel ?? this.ingeniero_enel,
      almacenista_r: almacenista_r ?? this.almacenista_r,
      tel_r: tel_r ?? this.tel_r,
      fecha_r: fecha_r ?? this.fecha_r,
      unidad_r: unidad_r ?? this.unidad_r,
      soporte_r: soporte_r ?? this.soporte_r,
      reportado: reportado ?? this.reportado,
      comentario_i: comentario_i ?? this.comentario_i,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pedido': pedido,
      'codigo_massy': codigo_massy,
      'fecha_i': fecha_i,
      'almacenista_i': almacenista_i,
      'tel_i': tel_i,
      'soporte_i': soporte_i,
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd': ctd,
      'proyecto': proyecto,
      'ingeniero_enel': ingeniero_enel,
      'almacenista_r': almacenista_r,
      'tel_r': tel_r,
      'fecha_r': fecha_r,
      'unidad_r': unidad_r,
      'soporte_r': soporte_r,
      'reportado': reportado,
      'comentario_i': comentario_i,
      'estado': estado,
      'tipo': tipo,
    };
  }

  factory RemisionesRegistros.fromMap(Map<String, dynamic> map) {
    return RemisionesRegistros(
      id: map['id'].toString(),
      pedido: map['pedido'].toString(),
      codigo_massy: map['codigo_massy'].toString(),
      fecha_i: map['fecha_i'].toString() == '' ? '' : map['fecha_i'].toString().substring(0, 10),
      almacenista_i: map['almacenista_i'].toString(),
      tel_i: map['tel_i'].toString(),
      soporte_i: map['soporte_i'].toString(),
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd: map['ctd'].toString(),
      proyecto: map['proyecto'].toString(),
      ingeniero_enel: map['ingeniero_enel'].toString(),
      almacenista_r: map['almacenista_r'].toString(),
      tel_r: map['tel_r'].toString(),
      fecha_r: map['fecha_r'].toString(),
      unidad_r: map['unidad_r'].toString(),
      soporte_r: map['soporte_r'].toString(),
      reportado: map['reportado'].toString(),
      comentario_i: map['comentario_i'].toString(),
      estado: map['estado'].toString(),
      tipo: map['tipo'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory RemisionesRegistros.fromJson(String source) => RemisionesRegistros.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RemisionesRegistros(id: $id, pedido: $pedido, codigo_massy: $codigo_massy, fecha_i: $fecha_i, almacenista_i: $almacenista_i, tel_i: $tel_i, soporte_i: $soporte_i, item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd, proyecto: $proyecto, ingeniero_enel: $ingeniero_enel, almacenista_r: $almacenista_r, tel_r: $tel_r, fecha_r: $fecha_r, unidad_r: $unidad_r, soporte_r: $soporte_r, reportado: $reportado, comentario_i: $comentario_i, estado: $estado, tipo: $tipo)';
  }

  @override
  bool operator ==(covariant RemisionesRegistros other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.pedido == pedido &&
      other.codigo_massy == codigo_massy &&
      other.fecha_i == fecha_i &&
      other.almacenista_i == almacenista_i &&
      other.tel_i == tel_i &&
      other.soporte_i == soporte_i &&
      other.item == item &&
      other.e4e == e4e &&
      other.descripcion == descripcion &&
      other.um == um &&
      other.ctd == ctd &&
      other.proyecto == proyecto &&
      other.ingeniero_enel == ingeniero_enel &&
      other.almacenista_r == almacenista_r &&
      other.tel_r == tel_r &&
      other.fecha_r == fecha_r &&
      other.unidad_r == unidad_r &&
      other.soporte_r == soporte_r &&
      other.reportado == reportado &&
      other.comentario_i == comentario_i &&
      other.estado == estado &&
      other.tipo == tipo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      pedido.hashCode ^
      codigo_massy.hashCode ^
      fecha_i.hashCode ^
      almacenista_i.hashCode ^
      tel_i.hashCode ^
      soporte_i.hashCode ^
      item.hashCode ^
      e4e.hashCode ^
      descripcion.hashCode ^
      um.hashCode ^
      ctd.hashCode ^
      proyecto.hashCode ^
      ingeniero_enel.hashCode ^
      almacenista_r.hashCode ^
      tel_r.hashCode ^
      fecha_r.hashCode ^
      unidad_r.hashCode ^
      soporte_r.hashCode ^
      reportado.hashCode ^
      comentario_i.hashCode ^
      estado.hashCode ^
      tipo.hashCode;
  }
}
