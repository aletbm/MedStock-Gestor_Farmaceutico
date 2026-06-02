class User {
  int? id;
  String name;
  String lastname;
  String matricula;
  String password;
  String rol;

  String telefono;
  String? email;
  bool activo;
  DateTime fechaAlta;
  DateTime? ultimoAcceso;

  User({
    this.id, 
    required this.name,
    required this.lastname,
    required this.matricula,
    required this.password,
    required this.rol,
    required this.telefono,
    this.email,
    required this.activo,
    required this.fechaAlta,
    this.ultimoAcceso
  });
  
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'lastname': lastname,
      'matricula': matricula,
      'password': password,
      'rol': rol,
      'telefono': telefono,
      'email': email,
      'activo': activo ? 1 : 0,
      'fechaAlta': fechaAlta.toIso8601String(),
      'ultimoAcceso': ultimoAcceso?.toIso8601String(),
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map){
    return User(
      id: map['id'],
      name: map['name'],
      lastname: map['lastname'],
      matricula: map['matricula'],
      password: map['password'],
      rol: map['rol'],
      telefono: map['telefono'],
      email: map['email'],
      activo: map['activo'] == 1,
      fechaAlta: DateTime.parse(map['fechaAlta']),
      ultimoAcceso: map['ultimoAcceso'] != null 
                       ? DateTime.parse(map['ultimoAcceso']) 
                       : null,
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? lastname,
    String? matricula,
    String? telefono,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      matricula: matricula ?? this.matricula,
      password: password ?? this.password,
      rol: rol,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      activo: activo,
      fechaAlta: fechaAlta,
      ultimoAcceso: ultimoAcceso,
    );
  }
}