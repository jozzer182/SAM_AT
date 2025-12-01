import 'dart:convert';

import 'package:samat2co/deuda_bruta/deudabruta_model.dart';
import 'package:samat2co/deuda_operativa/deudaoperativa_model.dart';


class DeudaAlmacen {
  List<DeudaAlmacenSingle> deudaAlmacen = [];
  List<DeudaAlmacenSingle> deudaAlmacenListSearch = [];
  List<DeudaAlmacenSingle> deudaAlmacenListSearch2 = [];
  
  int totalValor = 0;
  int totalSobrantes = 0;
  int totalFaltantes = 0;
  Map itemsAndFlex = {
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'mb52': 2,
    'inv': 2,
    'sal': 2,
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
    deudaAlmacenListSearch = [...deudaAlmacen];
    deudaAlmacenListSearch = deudaAlmacen
        .where((element) =>
            element.toList().any((item) => item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
    deudaAlmacenListSearch2 = [...deudaAlmacenListSearch];
    deudaAlmacenListSearch2.sort((b, a) => int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)));
  }

  crear({
    required DeudaBruta deudaBruta,
    required DeudaOperativa deudaOperativa,
  }) {
    List<DeudaActiva> registros = deudaOperativa.registrosOperativos;
    for (var i = 0; i < deudaBruta.deudaBrutaList.length; i++) {
      for (var j = 0; j < registros.length; j++) {
        if (deudaBruta.deudaBrutaList[i].e4e == registros[j].e4e) {
          double valorUnitario = 0.0;
          if (deudaBruta.deudaBrutaList[i].faltanteUnidades != '0') {
             valorUnitario =
                int.parse(deudaBruta.deudaBrutaList[i].faltanteValor) /
                    int.parse(deudaBruta.deudaBrutaList[i].faltanteUnidades);
          } else{
            // print('deudaBruta.deudaBrutaList[i] ${deudaBruta.deudaBrutaList[i]}');
            // print('registros[j] ${registros[j]}');
            // print('no hay unidades');
          }
          int faltanteUnidades = int.parse(deudaBruta.deudaBrutaList[i].mb52) -
              (int.parse(deudaBruta.deudaBrutaList[i].inv) +
                  int.parse(registros[j].ctd));
          double faltanteValor = faltanteUnidades * valorUnitario;
          // print('faltanteUnidades en ${deudaBruta.deudaBrutaList[i].e4e} : $faltanteUnidades');
          // print('valorunitario en ${deudaBruta.deudaBrutaList[i].e4e} : $valorUnitario');
          // print('faltante valor en ${deudaBruta.deudaBrutaList[i].e4e} : ${deudaBruta.deudaBrutaList[i].faltanteValor}');
          // print('faltante unidades origen en ${deudaBruta.deudaBrutaList[i].e4e} : ${deudaBruta.deudaBrutaList[i].faltanteUnidades}');
          deudaAlmacen.add(DeudaAlmacenSingle(
            e4e: deudaBruta.deudaBrutaList[i].e4e,
            descripcion: deudaBruta.deudaBrutaList[i].descripcion,
            um: deudaBruta.deudaBrutaList[i].um,
            mb52: deudaBruta.deudaBrutaList[i].mb52,
            inv: deudaBruta.deudaBrutaList[i].inv,
            sal: registros[j].ctd,
            faltanteUnidades: faltanteUnidades.toString(),
            faltanteValor: faltanteValor.round().toString(),
            valorUnitario: valorUnitario.toString(),
          ));
        }
      }
      double valorUnitario = int.parse(deudaBruta.deudaBrutaList[i].faltanteValor) /
          int.parse(deudaBruta.deudaBrutaList[i].faltanteUnidades);
      if (!(deudaAlmacen.any((e) => e.e4e == deudaBruta.deudaBrutaList[i].e4e))) {
        deudaAlmacen.add(DeudaAlmacenSingle(
          e4e: deudaBruta.deudaBrutaList[i].e4e,
          descripcion: deudaBruta.deudaBrutaList[i].descripcion,
          um: deudaBruta.deudaBrutaList[i].um,
          mb52: deudaBruta.deudaBrutaList[i].mb52,
          inv: deudaBruta.deudaBrutaList[i].inv,
          sal: "0",
          faltanteValor: deudaBruta.deudaBrutaList[i].faltanteValor,
          faltanteUnidades: deudaBruta.deudaBrutaList[i].faltanteUnidades,
          valorUnitario: valorUnitario.toString(),
        ));
      }
    }
    total();
    deudaAlmacen.sort((a, b) => int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)));
    deudaAlmacenListSearch = [...deudaAlmacen];
    deudaAlmacenListSearch2 = [...deudaAlmacen];
    deudaAlmacenListSearch2.sort((b, a) => int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)));
    return deudaAlmacen;
  }

  void total() {
    totalValor = 0;
    for (var deuda in deudaAlmacen) {
      int valor = int.parse(deuda.faltanteValor);
      totalValor += valor;
      if(valor < 0 ) totalSobrantes += valor;
      if(valor > 0 ) totalFaltantes += valor;
    }
  }

  @override
  String toString() => 'DeudaAlmacen(deudaAlmacen: $deudaAlmacen)';
}

class DeudaAlmacenSingle {
  String e4e;
  String descripcion;
  String um;
  String mb52;
  String inv;
  String sal;
  String faltanteUnidades;
  String faltanteValor;
  String valorUnitario;
  // TextEditingController fisico = TextEditingController();
  Map flex = {
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'mb52': 2,
    'inv': 2,
    'sal': 2,
    'faltanteUnidades': 2,
    'faltanteValor': 2,
  };
  DeudaAlmacenSingle({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.mb52,
    required this.inv,
    required this.sal,
    required this.faltanteUnidades,
    required this.faltanteValor,
    required this.valorUnitario,
  });

  DeudaAlmacenSingle copyWith({
    String? e4e,
    String? descripcion,
    String? um,
    String? mb52,
    String? inv,
    String? sal,
    String? faltanteUnidades,
    String? faltanteValor,
    String? valorUnitario,
  }) {
    return DeudaAlmacenSingle(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      mb52: mb52 ?? this.mb52,
      inv: inv ?? this.inv,
      sal: sal ?? this.sal,
      faltanteUnidades: faltanteUnidades ?? this.faltanteUnidades,
      faltanteValor: faltanteValor ?? this.faltanteValor,
      valorUnitario: valorUnitario ?? this.valorUnitario,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'mb52': mb52,
      'inv': inv,
      'sal': sal,
      'faltanteUnidades': faltanteUnidades,
      'faltanteValor': faltanteValor,
    };
  }

  factory DeudaAlmacenSingle.fromMap(Map<String, dynamic> map) {
    return DeudaAlmacenSingle(
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      mb52: map['mb52'].toString(),
      inv: map['inv'].toString(),
      sal: map['sal'].toString(),
      faltanteUnidades: map['faltanteUnidades'].toString(),
      faltanteValor: map['faltanteValor'].toString(),
      valorUnitario: map['valorUnitario'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeudaAlmacenSingle.fromJson(String source) =>
      DeudaAlmacenSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeudaAlmacenSingle(e4e: $e4e, descripcion: $descripcion, um: $um, mb52: $mb52, inv: $inv, sal: $sal, faltanteUnidades: $faltanteUnidades, faltanteValor: $faltanteValor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeudaAlmacenSingle &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.mb52 == mb52 &&
        other.inv == inv &&
        other.sal == sal &&
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
        sal.hashCode ^
        faltanteUnidades.hashCode ^
        faltanteValor.hashCode;
  }

  List<String> toList() {
    return [
      e4e,
      descripcion,
      um,
      mb52,
      inv,
      sal,
      faltanteUnidades,
      faltanteValor,
    ];
  }

  List<Map> toMapListFlex() {
    return [
      {'index': 'e4e', 'texto': e4e, 'flex': flex['e4e']},
      {
        'index': 'descripcion',
        'texto': descripcion,
        'flex': flex['descripcion']
      },
      {'index': 'um', 'texto': um, 'flex': flex['um']},
      {'index': 'mb52', 'texto': mb52, 'flex': flex['mb52']},
      {'index': 'inv', 'texto': inv, 'flex': flex['inv']},
      {'index': 'sal', 'texto': sal, 'flex': flex['sal']},
      {
        'index': 'faltanteUnidades',
        'texto': faltanteUnidades,
        'flex': flex['faltanteUnidades']
      },
      {
        'index': 'faltanteValor',
        'texto': faltanteValor,
        'flex': flex['faltanteValor']
      },
    ];
  }

  void recalcularFaltante({required String inv}) {
    double faltanteUnidades =
        double.parse(mb52) - double.parse(inv) - double.parse(sal);
    double faltanteValor = double.parse(valorUnitario) * faltanteUnidades;
    this.faltanteUnidades = faltanteUnidades.toString();
    this.inv = inv;
    this.faltanteValor = faltanteValor.toString();
  }

  Map toSaldos({required String pdi}) {
    return {
      "Material": e4e,
      "Texto": descripcion,
      "Lote": pdi,
      "SaldoSAP": mb52,
      "SaldoPDI": inv,
    };
  }
}
