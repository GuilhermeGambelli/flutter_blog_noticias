class Usuario {
  final String uid;
  final String email;
  final String nome;
  final String dia;
  final String mes;
  final String ano;
  final String estado;
  final String cidade;

  Usuario({
    required this.uid,
    required this.email,
    required this.nome,
    required this.dia,
    required this.mes,
    required this.ano,
    required this.estado,
    required this.cidade,
  });

  // Converte o objeto Usuario para um mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'nome': nome,
      'dia': dia,
      'mes': mes,
      'ano': ano,
      'estado': estado,
      'cidade': cidade,
    };
  }

  // Cria um objeto Usuario a partir de um mapa (JSON)
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      uid: json['uid'],
      email: json['email'],
      nome: json['nome'],
      dia: json['dia'],
      mes: json['mes'],
      ano: json['ano'],
      estado: json['estado'],
      cidade: json['cidade'],
    );
  }
}
