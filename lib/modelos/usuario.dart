class Usuario {
  final int? id;
  final String Nombre;
  final String ApellidoPaterno;
  final String usuario;
  final String Contrasena;

  Usuario({
    this.id,
    required this.Nombre,
    required this.ApellidoPaterno,
    required this.usuario,
    required this.Contrasena,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Nombre': Nombre,
      'ApellidoPaterno': ApellidoPaterno,
      'usuario': usuario,
      'Contrasena': Contrasena,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      Nombre: map['Nombre'],
      ApellidoPaterno: map['ApellidoPaterno'],
      usuario: map['usuario'],
      Contrasena: map['Contrasena'],
    );
  }
}
