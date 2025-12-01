// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/user/user_model.dart';

import '../../resources/constants/apis.dart';

class NuevoTraslado {
  List<NuevoTrasladoSingle> nuevoTrasladoList = [];
  NuevoTrasladoEncabezado encabezado = NuevoTrasladoEncabezado.zero();

  crear(User user) {
    nuevoTrasladoList.clear();
    nuevoTrasladoList =
        List.generate(3, (index) => NuevoTrasladoSingle.fromIndex(index + 1));
    encabezado = NuevoTrasladoEncabezado.fromInit(user);
  }

  get agregar {
    nuevoTrasladoList
        .add(NuevoTrasladoSingle.fromIndex(nuevoTrasladoList.length + 1));
  }

  get eliminar {
    nuevoTrasladoList.removeLast();
  }

  resize(String index) {
    index = index.isEmpty ? '1' : index;
    int size = int.parse(index);
    nuevoTrasladoList.clear();
    nuevoTrasladoList.length = 0;
    nuevoTrasladoList =
        List.generate(size, (i) => NuevoTrasladoSingle.fromIndex(i + 1));
  }

  modifyList(String index, String method) {
    switch (method) {
      case 'agregar':
        agregar;
        break;
      case 'eliminar':
        eliminar;
        break;
      case 'resize':
        resize(index);
        break;
      default:
        break;
    }
  }

  List? get validar {
    List faltantes = [];
    Color r = Colors.red;
    NuevoTrasladoEncabezado e = encabezado;
    if (e.codigo_massyError == r) faltantes.add('Código Massy');
    if (e.soporte_iError == r) faltantes.add('Soporte de Entrega');
    for (var reg in nuevoTrasladoList) {
      String f = 'Item: ${reg.item} =>';
      if (reg.e4eError == r) f += ' E4e,';
      if (reg.ctdError == r) f += ' Ctd,';
      if (f != 'Item: ${reg.item} =>') faltantes.add(f);
    }
    if (faltantes.isNotEmpty) {
      faltantes.insert(0,
          'Por favor revise los siguientes campos en la planilla, para poder realizar el guardado:');
      return faltantes;
    } else {
      return null;
    }
  }

  Future<String?> enviar(User user) async {
    List<Map> list = [];
    for (var material in nuevoTrasladoList) {
      list.add({...material.toMap(), ...encabezado.toMap()});
    }
    var dataSend = {
      'info': {'libro': user.pdi, 'listMap': list, 'hoja': 'ingresos'},
      'fname': "addListMapDB"
    };
    var response =
        await http.post(Uri.parse(Api.samat), body: jsonEncode(dataSend));
    var respuesta = jsonDecode(response.body) ?? ['error', 'error'];
    // print(respuesta);
    if (respuesta is List) {
      respuesta =
          'Se han agregado ${respuesta[0]} registros con el pedido ${respuesta[1]}';
    } else {
      print(respuesta);
    }
    return respuesta;
  }

  @override
  String toString() {
    return 'NuevoTraslado{encabezado: $encabezado, material: $nuevoTrasladoList}';
  }
}

class NuevoTrasladoEncabezado {
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
  NuevoTrasladoEncabezado({
    required this.fecha_i,
    required this.almacenista_i,
    required this.tel_i,
    required this.reportado,
    this.codigo_massy = '',
    this.soporte_i = '',
    this.proyecto = 'Libre',
    this.comentario_i = '',
    this.estado = 'correcto',
    this.tipo = 'traslado',
  });

  Color get codigo_massyError =>
      codigo_massy.isEmpty ? Colors.red : Colors.green;
  Color get soporte_iError => soporte_i.isEmpty ? Colors.red : Colors.green;

  @override
  String toString() {
    return 'NuevoTrasladoEncabezado(codigo_massy: $codigo_massy, fecha_i: $fecha_i, almacenista_i: $almacenista_i, soporte_i: $soporte_i, tel_i: $tel_i, proyecto: $proyecto, reportado: $reportado, comentario_i: $comentario_i, estado: $estado, tipo: $tipo)';
  }

  NuevoTrasladoEncabezado copyWith({
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
  }) {
    return NuevoTrasladoEncabezado(
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
    };
  }

  factory NuevoTrasladoEncabezado.fromMap(Map<String, dynamic> map) {
    return NuevoTrasladoEncabezado(
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
    );
  }

  factory NuevoTrasladoEncabezado.fromInit(User user) {
    return NuevoTrasladoEncabezado(
      codigo_massy: '',
      fecha_i:
          '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}',
      almacenista_i: user.correo,
      soporte_i: '',
      tel_i: user.telefono,
      proyecto: '',
      reportado:
          '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}',
      comentario_i: '',
      estado: '',
      tipo: '',
    );
  }

  factory NuevoTrasladoEncabezado.zero() {
    return NuevoTrasladoEncabezado(
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
    );
  }

  String toJson() => json.encode(toMap());

  factory NuevoTrasladoEncabezado.fromJson(String source) =>
      NuevoTrasladoEncabezado.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant NuevoTrasladoEncabezado other) {
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

class NuevoTrasladoSingle {
  String item;
  String e4e;
  String descripcion;
  String ctd;
  String um;
  // Color e4eError;
  NuevoTrasladoSingle({
    this.item = '',
    this.e4e = '',
    this.descripcion = '',
    this.ctd = '',
    this.um = '',
  });

  Color get e4eError =>
      e4e.isEmpty || e4e.length != 6 || descripcion == 'No encontrado'
          ? Colors.red
          : Colors.green;
  Color get ctdError =>
      ctd.isEmpty || int.parse(ctd) == 0 ? Colors.red : Colors.green;

  factory NuevoTrasladoSingle.fromIndex(int index) {
    return NuevoTrasladoSingle(
      item: '${index}',
      e4e: '',
      descripcion: 'Descripción',
      ctd: '0',
      um: 'um',
    );
  }

  void cambioE4e(String newE4e, Mm60 mm60) {
    Mm60Single mm60Encontrado = mm60.mm60List.firstWhere(
      (e) => e.material.contains(newE4e),
      orElse: () => Mm60Single(
        material: 'material',
        precio: 'precio',
        descripcion: 'No encontrado',
        ultima_m: 'modif',
        tpmt: 'tpmt',
        grupo: '',
        um: 'na',
        mon: 'mon',
        actualizado: '',
      ),
    );
    e4e = newE4e;
    descripcion = mm60Encontrado.descripcion;
    um = mm60Encontrado.um;
  }

  void cambioCtd(String newCtd) {
    ctd = newCtd.isEmpty ? '0' : newCtd;
  }

  NuevoTrasladoSingle copyWith({
    String? item,
    String? e4e,
    String? descripcion,
    String? ctd,
    String? um,
  }) {
    return NuevoTrasladoSingle(
      item: item ?? this.item,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      ctd: ctd ?? this.ctd,
      um: um ?? this.um,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'ctd': ctd,
      'um': um,
    };
  }

  factory NuevoTrasladoSingle.fromMap(Map<String, dynamic> map) {
    return NuevoTrasladoSingle(
      item: map['item'],
      e4e: map['e4e'],
      descripcion: map['descripcion'],
      ctd: map['ctd'],
      um: map['um'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NuevoTrasladoSingle.fromJson(String source) =>
      NuevoTrasladoSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NuevoTrasladoSingle(item: $item, e4e: $e4e, descripcion: $descripcion, ctd: $ctd, um: $um)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NuevoTrasladoSingle &&
        other.item == item &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.ctd == ctd &&
        other.um == um;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        ctd.hashCode ^
        um.hashCode;
  }
}
