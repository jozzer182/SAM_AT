import 'dart:convert';

class ToCelda {
  String valor;
  int flex;
  ToCelda({
    required this.valor,
    required this.flex,
  });

  ToCelda copyWith({
    String? titulo,
    int? flex,
  }) {
    return ToCelda(
      valor: titulo ?? this.valor,
      flex: flex ?? this.flex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': valor,
      'flex': flex,
    };
  }

  factory ToCelda.fromMap(Map<String, dynamic> map) {
    return ToCelda(
      valor: map['titulo'] ?? '',
      flex: map['flex']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToCelda.fromJson(String source) => ToCelda.fromMap(json.decode(source));

  @override
  String toString() => 'Titulo(titulo: $valor, flex: $flex)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ToCelda &&
      other.valor == valor &&
      other.flex == flex;
  }

  @override
  int get hashCode => valor.hashCode ^ flex.hashCode;
}
