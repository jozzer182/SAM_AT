import 'dart:convert';

import 'package:samat2co/inventario/inventario_model.dart';
import 'package:samat2co/mb52/mb52_model.dart';

import '../mm60/mm60_model.dart';

class DeudaBruta {
  List<DeudaBrutaSingle> deudaBrutaList = [];
  List<DeudaBrutaSingle> deudaBrutaListSearch = [];
  int totalValor = 0;
  Map itemsAndFlex = {
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'mb52': 2,
    'inv': 2,
    'faltanteUnidades': 2,
    'faltanteValor': 2,
  };
  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  buscar(String busqueda) {
    deudaBrutaListSearch = [...deudaBrutaList];
    deudaBrutaListSearch = deudaBrutaList
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }

  crear({
    required Mb52 mb52,
    required Inventario inventario,
    required Mm60 mm60,
  }) {
    List<Mb52Single> unaLista = [];
    // print(
    //     ' 1.2 state.mb52List: ${mb52.mb52List.where((e) => e.material == "520012")}');

    //make uniques
    List<Mb52Single> noState = [...List.from(mb52.mb52List)];
    List<String> e4eUniques = noState.map((e) => e.material).toSet().toList();
    for (String e4e in e4eUniques) {
      // print('e4e: $e4e');
      for (Mb52Single mb52Row in [...noState]) {
        if (mb52Row.material == e4e) {
          if (unaLista.indexWhere((e) => e.material == e4e) == -1) {
            unaLista.add(mb52Row);
          } else {
            double ctd = double.parse(mb52Row.ctd) +
                double.parse(unaLista.firstWhere((e) => e.material == e4e).ctd);
            double valor = ctd *
                double.parse(
                    mm60.mm60List.firstWhere((e) => e.material == e4e).precio);
            unaLista[unaLista.indexWhere((e) => e.material == e4e)] =
                unaLista.firstWhere((e) => e.material == e4e).copyWith(
                      ctd: '$ctd',
                      valor: '$valor',
                    );
          }
        }
      }
    }

    // print('mb52List: $mb52List');
    // print(
    //     ' 1.5 state.mb52List: ${mb52.mb52List.where((e) => e.material == "520012")}');

    for (var i = 0; i < unaLista.length; i++) {
      for (var j = 0; j < inventario.inventarioList.length; j++) {
        if (unaLista[i].material == inventario.inventarioList[j].e4e) {
          double valorUnitario =double.parse(mm60.mm60List.firstWhere((e) => e.material == unaLista[i].material).precio);
          int faltanteUnidades = int.parse(unaLista[i].ctd) -
              int.parse(inventario.inventarioList[j].ctd);
          double faltanteValor = faltanteUnidades * valorUnitario;
          deudaBrutaList.add(DeudaBrutaSingle(
            e4e: unaLista[i].material,
            descripcion: unaLista[i].descripcion,
            um: unaLista[i].umb,
            mb52: unaLista[i].ctd,
            inv: inventario.inventarioList[j].ctd,
            faltanteValor: faltanteValor.round().toString(),
            faltanteUnidades: faltanteUnidades.toString(),
          ));
        }
      }
      if (!(deudaBrutaList.any((e) => e.e4e == unaLista[i].material))) {
        deudaBrutaList.add(DeudaBrutaSingle(
          e4e: unaLista[i].material,
          descripcion: unaLista[i].descripcion,
          um: unaLista[i].umb,
          mb52: unaLista[i].ctd,
          inv: "0",
          faltanteValor: unaLista[i].valor,
          faltanteUnidades: unaLista[i].ctd,
        ));
      }
    }
    deudaBrutaList.sort((a, b) =>
        int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)));
    deudaBrutaListSearch = [...deudaBrutaList];
    total();
    return deudaBrutaList;
  }

  void total() {
    for (var deuda in deudaBrutaList) {
      totalValor += int.parse(deuda.faltanteValor);
    }
  }

  @override
  String toString() =>
      'DeudaBruta(deudaBrutaList: $deudaBrutaList, totalValor: $totalValor)';
}

class DeudaBrutaSingle {
  String e4e;
  String descripcion;
  String um;
  String mb52;
  String inv;
  String faltanteUnidades;
  String faltanteValor;
  DeudaBrutaSingle({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.mb52,
    required this.inv,
    required this.faltanteUnidades,
    required this.faltanteValor,
  });

  DeudaBrutaSingle copyWith({
    String? e4e,
    String? descripcion,
    String? um,
    String? mb52,
    String? inv,
    String? faltanteUnidades,
    String? faltanteValor,
  }) {
    return DeudaBrutaSingle(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      mb52: mb52 ?? this.mb52,
      inv: inv ?? this.inv,
      faltanteUnidades: faltanteUnidades ?? this.faltanteUnidades,
      faltanteValor: faltanteValor ?? this.faltanteValor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'mb52': mb52,
      'inv': inv,
      'faltanteUnidades': faltanteUnidades,
      'faltanteValor': faltanteValor,
    };
  }

  factory DeudaBrutaSingle.fromMap(Map<String, dynamic> map) {
    return DeudaBrutaSingle(
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      mb52: map['mb52'].toString(),
      inv: map['inv'].toString(),
      faltanteUnidades: map['faltanteUnidades'].toString(),
      faltanteValor: map['faltanteValor'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeudaBrutaSingle.fromJson(String source) =>
      DeudaBrutaSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeudaBrutaSingle(e4e: $e4e, descripcion: $descripcion, um: $um, mb52: $mb52, inv: $inv, faltanteUnidades: $faltanteUnidades, faltanteValor: $faltanteValor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeudaBrutaSingle &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.mb52 == mb52 &&
        other.inv == inv &&
        other.faltanteUnidades == faltanteUnidades &&
        other.faltanteValor == faltanteValor;
  }

  @override
  int get hashCode {
    return e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        mb52.hashCode ^
        inv.hashCode ^
        faltanteUnidades.hashCode ^
        faltanteValor.hashCode;
  }

  List<String> toList() {
    return [e4e, descripcion, um, mb52, inv, faltanteUnidades, faltanteValor];
  }
}
