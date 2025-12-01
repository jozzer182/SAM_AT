// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  String id = '';
  String correo = '';
  String perfil = '';
  String pdi = '';
  String telefono = '';
  String empresa = '';
  String nombrecorto = '';
  List<String> permisos = [];

  set({
    required String id,
    required String correo,
    required String perfil,
    required String pdi,
    required String telefono,
    required String empresa,
    required String nombrecorto,
    required List<String> permisos,
  }) {
    this.id = id;
    this.correo = correo;
    this.perfil = perfil;
    this.pdi = pdi;
    this.telefono = telefono;
    this.empresa = empresa;
    this.nombrecorto = nombrecorto;
    this.permisos = permisos;
  }

  User({
    id,
    correo,
    perfil,
    pdi,
    telefono,
    empresa,
    nombrecorto,
  });

  User copyWith({
    String? id,
    String? correo,
    String? perfil,
    String? pdi,
    String? telefono,
    String? empresa,
    String? nombrecorto,
  }) {
    return User(
      id: id ?? this.id,
      correo: correo ?? this.correo,
      perfil: perfil ?? this.perfil,
      pdi: pdi ?? this.pdi,
      telefono: telefono ?? this.telefono,
      empresa: empresa ?? this.empresa,
      nombrecorto: nombrecorto ?? this.nombrecorto,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'correo': correo,
      'perfil': perfil,
      'pdi': pdi,
      'telefono': telefono,
      'empresa': empresa,
      'nombrecorto': nombrecorto,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      correo: map['correo'].toString(),
      perfil: map['perfil'].toString(),
      pdi: map['pdi'].toString(),
      telefono: map['telefono'].toString(),
      empresa: map['empresa'].toString(),
      nombrecorto: map['nombrecorto'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, correo: $correo, perfil: $perfil, pdi: $pdi, telefono: $telefono, empresa: $empresa, nombrecorto: $nombrecorto, permisos: $permisos)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.correo == correo &&
        other.perfil == perfil &&
        other.pdi == pdi &&
        other.telefono == telefono &&
        other.empresa == empresa &&
        other.nombrecorto == nombrecorto;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        correo.hashCode ^
        perfil.hashCode ^
        pdi.hashCode ^
        telefono.hashCode ^
        empresa.hashCode ^
        nombrecorto.hashCode;
  }
}
