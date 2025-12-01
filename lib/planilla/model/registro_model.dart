import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samat2co/inventario/inventario_model.dart';
import 'package:samat2co/mb52/mb52_model.dart';
import 'package:samat2co/mm60/mm60_model.dart';
import 'package:samat2co/registros/registro_fila_model.dart';
import 'package:samat2co/user/user_model.dart';

class Registro {
  String id;
  int item;
  String e4e;
  String descripcion;
  String um;
  int ctd_e;
  int ctd_r;
  int ctd_total = 0;
  bool esMb52 = true;
  int ctdMb52 = 0;
  bool esInv = true;
  int ctdInv = 0;
  bool errorValue = false;
  Registro({
    required this.id,
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd_e,
    required this.ctd_r,
  }) {
    ctd_total = ctd_e - ctd_r;
  }

  List<String> toListPdf() => [
        e4e,
        descripcion,
        um,
        ctd_total.toString(),
      ];

  Color get e4eColor =>
      !esInv || descripcion == 'No existe en BD' || e4e.length != 6
          ? Colors.red
          : Colors.green;

  Color get ctdEColor => errorValue || ctd_e == 0 ? Colors.red : Colors.grey;

  //Metodos para el cambio de las variables dentro de la clase
  void cambioE4e(
    String e4eN,
    Mm60 mm60,
    Mb52 mb52,
    Inventario inventario,
    User user,
  ) {
    Mb52Single inMb52 = mb52.mb52List.firstWhere(
      (e) => e.material.contains(e4eN),
      orElse: () => Mb52Single.fromInit(),
    );
    InventarioSingle inInventario = inventario.inventarioList.firstWhere(
      (e) => e.e4e.contains(e4eN),
      orElse: () => InventarioSingle.fromInit(),
    );
    Mm60Single inMm60 = mm60.mm60List.firstWhere(
      (e) => e.material.contains(e4eN),
      orElse: () => Mm60Single.fromInit(),
    );
    e4e = e4eN;
    descripcion = inMm60.descripcion;
    um = inMm60.um;
    esMb52 = inMb52.ctd != '0';
    ctdMb52 = e4e.length == 6
        ? int.parse(inMb52.ctd)
        : 0; //solo muestra la cantidad de MB52 cuando tiene 6
    esInv = inInventario.ctd != '0';
    ctdInv = e4e.length == 6
        ? int.parse(inInventario.ctd)
        : 0; //solo muestra la cantidad de inventario cuando tiene 6
  }

  void cambioCtdE(
    String ctd_eN,
    Mb52 mb52,
    Inventario inventario,
  ) {
    InventarioSingle inInventario = inventario.inventarioList.firstWhere(
      (e) => e.e4e.contains(e4e),
      orElse: () => InventarioSingle.fromInit(),
    );
    ctd_e = ctd_eN == '' ? 0 : int.parse(ctd_eN);
    // ctd_r = ctd_r == '' ? '0' : ctd_r;
    ctd_total = ctd_e - ctd_r;
    bool esMayorLoReintegrado = ctd_e < ctd_r;
    bool esMayorLoInstaladoQueInv = ctd_total > int.parse(inInventario.ctd);
    errorValue = esMayorLoReintegrado || esMayorLoInstaladoQueInv;
  }

  void cambioCtdR(
    String ctd_rN,
    Mb52 mb52,
    Inventario inventario,
  ) {
    InventarioSingle inInventario = inventario.inventarioList.firstWhere(
      (e) => e.e4e.contains(e4e),
      orElse: () => InventarioSingle.fromInit(),
    );
    ctd_r = ctd_rN == '' ? 0 : int.parse(ctd_rN);
    ctd_total = ctd_e - ctd_r;
    bool esMayorLoReintegrado = ctd_e < ctd_r;
    bool esMayorLoInstaladoQueInv = ctd_total > int.parse(inInventario.ctd);
    errorValue = esMayorLoReintegrado || esMayorLoInstaladoQueInv;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd_e': ctd_e,
      'ctd_r': ctd_r,
      'ctd_total': ctd_total,
    };
  }

  factory Registro.nuevo(int item) {
    return Registro(
      id: '',
      item: item,
      e4e: '',
      descripcion: '',
      um: '',
      ctd_e: 0,
      ctd_r: 0,
    );
  }

  factory Registro.fromResgistroFila(ResgistroFila registro) {
    return Registro(
      id: registro.id,
      item: int.parse(registro.item),
      e4e: registro.e4e,
      descripcion: registro.descripcion,
      um: registro.um,
      ctd_e: int.parse(registro.ctd_e),
      ctd_r: int.parse(registro.ctd_r),
    );
  }

  String toJson() => json.encode(toMap());

  // factory Registro.fromJson(String source) =>
  // Registro.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Registro(id: $id, item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd_e: $ctd_e, ctd_r: $ctd_r, ctd_total: $ctd_total)';
  }
}
