class Diario {
  final int? id;
  final int userId;
  late final String titulo;
  final String descripcion;
  final DateTime fechahora;

  Diario({
    this.id,
    required this.userId,
    required this.titulo,
    required this.descripcion,
    required this.fechahora,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'titulo': titulo,
      'descripcion': descripcion,
      'fechahora': fechahora.toIso8601String(),
    };
  }

  factory Diario.fromMap(Map<String, dynamic> map) {
    return Diario(
      id: map['id'],
      userId: map['userId'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      fechahora: DateTime.parse(map['fechahora']),
    );
  }
}



