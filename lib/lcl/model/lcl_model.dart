import 'dart:convert';

import '../../resources/titulo.dart';

class Lcl {
  List<LclSingle> lclList = [];
  List<LclSingle> lclListSearch = [];
  List<LclScmSingle> lclScmList = [];
  List<LclSapSingle> lclSapList = [];
  int totalValor = 0;
  int view = 100;
  Map itemsAndFlex = {
    'grupo': [1, 'grupo'],
    'usuario': [4, 'usuario'],
    'lcl': [2, 'lcl'],
    // 'descripcion': [4, 'descripción'],
    // 'estadodms': [2, 'dms'],
    'estadoscm': [1, 'scm'],
    'inicio': [2, 'inicio'],
    'fin': [2, 'fin'],
    // 'actualizado':[2,'actualizado'],
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

  List<ToCelda> titles = [
    ToCelda(valor: 'Grupo', flex: 1),
    ToCelda(valor: 'Usuario', flex: 4),
    ToCelda(valor: 'LCL', flex: 2),
    ToCelda(valor: 'Descripción', flex: 4),
    ToCelda(valor: 'Entrega Final', flex: 1),
    ToCelda(valor: 'Proyecto', flex: 4),
    ToCelda(valor: 'Inicio', flex: 2),
    ToCelda(valor: 'Fin', flex: 2),
  ];
}

class LclSingle {
  String grupo;
  String usuario;
  String lcl;
  String descripcion;
  String estadodms;
  String estadoscm;
  String inicio;
  String fin;
  String actualizado;
  LclSingle({
    required this.grupo,
    required this.usuario,
    required this.lcl,
    required this.descripcion,
    required this.estadodms,
    required this.estadoscm,
    required this.inicio,
    required this.fin,
    required this.actualizado,
  });

   List<String> toList() {
    return [
      grupo,
      usuario,
      lcl,
      descripcion,
      estadodms,
      estadoscm,
      inicio,
      fin,
      actualizado,
    ];
  }

  LclSingle copyWith({
    String? grupo,
    String? usuario,
    String? lcl,
    String? descripcion,
    String? estadodms,
    String? estadoscm,
    String? inicio,
    String? fin,
    String? actualizado,
  }) {
    return LclSingle(
      grupo: grupo ?? this.grupo,
      usuario: usuario ?? this.usuario,
      lcl: lcl ?? this.lcl,
      descripcion: descripcion ?? this.descripcion,
      estadodms: estadodms ?? this.estadodms,
      estadoscm: estadoscm ?? this.estadoscm,
      inicio: inicio ?? this.inicio,
      fin: fin ?? this.fin,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'grupo': grupo,
      'usuario': usuario,
      'lcl': lcl,
      'descripcion': descripcion,
      'estadodms': estadodms,
      'estadoscm': estadoscm,
      'inicio': inicio,
      'fin': fin,
      'actualizado': actualizado,
    };
  }

  factory LclSingle.fromInit() {
    return LclSingle(
      grupo: '',
      usuario: '',
      lcl: '',
      descripcion: '',
      estadodms: '',
      estadoscm: '',
      inicio: '',
      fin: '',
      actualizado: '',
    );
  }

  factory LclSingle.fromUser(String user) {
    return LclSingle(
      grupo: '',
      usuario: user,
      lcl: '',
      descripcion: '',
      estadodms: '',
      estadoscm: '',
      inicio: '',
      fin: '',
      actualizado: '',
    );
  }
  factory LclSingle.fromMap(Map<String, dynamic> map) {
    return LclSingle(
      grupo: map['grupo'].toString(),
      usuario: map['correo'].toString(),
      lcl: map['lcl'].toString(),
      descripcion: map['descripcion'].toString(),
      estadodms: map['entregafinal'].toString(),
      estadoscm: map['proyecto'].toString(),
      inicio:
          map['inicio'].toString().length > 10
              ? map['inicio'].toString().substring(0, 10)
              : map['inicio'].toString(),
      fin:
          map['fin'].toString().length > 10
              ? map['fin'].toString().substring(0, 10)
              : map['fin'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LclSingle.fromJson(String source) =>
      LclSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LclSingle(grupo: $grupo, usuario: $usuario, lcl: $lcl, descripcion: $descripcion, estadodms: $estadodms, estadoscm: $estadoscm, inicio: $inicio, fin: $fin, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LclSingle &&
        other.grupo == grupo &&
        other.usuario == usuario &&
        other.lcl == lcl &&
        other.descripcion == descripcion &&
        other.estadodms == estadodms &&
        other.estadoscm == estadoscm &&
        other.inicio == inicio &&
        other.fin == fin &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return grupo.hashCode ^
        usuario.hashCode ^
        lcl.hashCode ^
        descripcion.hashCode ^
        estadodms.hashCode ^
        estadoscm.hashCode ^
        inicio.hashCode ^
        fin.hashCode ^
        actualizado.hashCode;
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: grupo.toString(), flex: 1),
    ToCelda(valor: usuario.toString(), flex: 4),
    ToCelda(valor: lcl.toString(), flex: 2),
    ToCelda(valor: descripcion.toString(), flex: 4),
    ToCelda(valor: estadodms.toString(), flex: 1),
    ToCelda(valor: estadoscm.toString(), flex: 4),
    ToCelda(valor: inicio.toString(), flex: 2),
    ToCelda(valor: fin.toString(), flex: 2),
  ];
}

class LclScmSingle {
  String lcl;
  String contrato;
  String inicio;
  String fin;
  String grupo;
  String usuario;
  String estadodms;
  String estadoscm;
  String actualizado;
  LclScmSingle({
    required this.lcl,
    required this.contrato,
    required this.inicio,
    required this.fin,
    required this.grupo,
    required this.usuario,
    required this.estadodms,
    required this.estadoscm,
    required this.actualizado,
  });

  List<String> toList() {
    return [
      lcl,
      contrato,
      inicio,
      fin,
      grupo,
      usuario,
      estadodms,
      estadoscm,
      actualizado,
    ];
  }

  LclScmSingle copyWith({
    String? lcl,
    String? contrato,
    String? inicio,
    String? fin,
    String? grupo,
    String? usuario,
    String? estadodms,
    String? estadoscm,
    String? actualizado,
  }) {
    return LclScmSingle(
      lcl: lcl ?? this.lcl,
      contrato: contrato ?? this.contrato,
      inicio: inicio ?? this.inicio,
      fin: fin ?? this.fin,
      grupo: grupo ?? this.grupo,
      usuario: usuario ?? this.usuario,
      estadodms: estadodms ?? this.estadodms,
      estadoscm: estadoscm ?? this.estadoscm,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lcl': lcl,
      'contrato': contrato,
      'inicio': inicio,
      'fin': fin,
      'grupo': grupo,
      'usuario': usuario,
      'estadodms': estadodms,
      'estadoscm': estadoscm,
      'actualizado': actualizado,
    };
  }

  factory LclScmSingle.fromInit() {
    return LclScmSingle(
      lcl: '',
      contrato: '',
      inicio: '',
      fin: '',
      grupo: '',
      usuario: '',
      estadodms: '',
      estadoscm: '',
      actualizado: '',
    );
  }

  factory LclScmSingle.fromMap(Map<String, dynamic> map) {
    return LclScmSingle(
      lcl: map['lcl'].toString(),
      contrato: map['contrato'].toString(),
      inicio:
          map['inicio'].toString().length > 10
              ? map['inicio'].toString().substring(0, 10)
              : map['inicio'].toString(),
      fin:
          map['fin'].toString().length > 10
              ? map['fin'].toString().substring(0, 10)
              : map['fin'].toString(),
      grupo: map['grupo'].toString(),
      usuario: map['usuario'].toString(),
      estadodms: map['estadodms'].toString(),
      estadoscm: map['estadoscm'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LclScmSingle.fromJson(String source) =>
      LclScmSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LclScmSingle(lcl: $lcl, contrato: $contrato, inicio: $inicio, fin: $fin, grupo: $grupo, usuario: $usuario, estadodms: $estadodms, estadoscm: $estadoscm, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LclScmSingle &&
        other.lcl == lcl &&
        other.contrato == contrato &&
        other.inicio == inicio &&
        other.fin == fin &&
        other.grupo == grupo &&
        other.usuario == usuario &&
        other.estadodms == estadodms &&
        other.estadoscm == estadoscm &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return lcl.hashCode ^
        contrato.hashCode ^
        inicio.hashCode ^
        fin.hashCode ^
        grupo.hashCode ^
        usuario.hashCode ^
        estadodms.hashCode ^
        estadoscm.hashCode ^
        actualizado.hashCode;
  }
}

class LclSapSingle {
  String lcl;
  String usuario;
  String grupo;
  String creado;
  String fin;
  String scm;
  String actualizado;
  LclSapSingle({
    required this.lcl,
    required this.usuario,
    required this.grupo,
    required this.creado,
    required this.fin,
    required this.scm,
    required this.actualizado,
  });

  toList() {
    return [lcl, usuario, grupo, creado, fin, scm, actualizado];
  }

  LclSapSingle copyWith({
    String? lcl,
    String? usuario,
    String? grupo,
    String? creado,
    String? fin,
    String? scm,
    String? actualizado,
  }) {
    return LclSapSingle(
      lcl: lcl ?? this.lcl,
      usuario: usuario ?? this.usuario,
      grupo: grupo ?? this.grupo,
      creado: creado ?? this.creado,
      fin: fin ?? this.fin,
      scm: scm ?? this.scm,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lcl': lcl,
      'usuario': usuario,
      'grupo': grupo,
      'creado': creado,
      'fin': fin,
      'scm': scm,
      'actualizado': actualizado,
    };
  }

  factory LclSapSingle.fromMap(Map<String, dynamic> map) {
    return LclSapSingle(
      lcl: map['lcl'].toString(),
      usuario: map['usuario'].toString(),
      grupo: map['grupo'].toString(),
      creado:
          map['creado'].toString().length > 10
              ? map['creado'].toString().substring(0, 10)
              : map['creado'].toString(),
      fin:
          map['fin'].toString().length > 10
              ? map['fin'].toString().substring(0, 10)
              : map['fin'].toString(),
      scm: map['scm'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  factory LclSapSingle.zero() {
    return LclSapSingle(
      lcl: '',
      usuario: '',
      grupo: '',
      creado: '',
      fin: '',
      scm: '',
      actualizado: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LclSapSingle.fromJson(String source) =>
      LclSapSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LclSapSingle(lcl: $lcl, usuario: $usuario, grupo: $grupo, creado: $creado, fin: $fin, scm: $scm, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LclSapSingle &&
        other.lcl == lcl &&
        other.usuario == usuario &&
        other.grupo == grupo &&
        other.creado == creado &&
        other.fin == fin &&
        other.scm == scm &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return lcl.hashCode ^
        usuario.hashCode ^
        grupo.hashCode ^
        creado.hashCode ^
        fin.hashCode ^
        scm.hashCode ^
        actualizado.hashCode;
  }
}
