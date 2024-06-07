class Autor {
  final String nome;
  final int idade;
  final String estado;
  final String cidade;
  final String fotoUrl; // URL da foto no Firebase Storage (ou similar)

  Autor({
    required this.nome,
    required this.idade,
    required this.estado,
    required this.cidade,
    required this.fotoUrl,
  });

  // Converte o objeto Autor para um mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'idade': idade,
      'estado': estado,
      'cidade': cidade,
      'fotoUrl': fotoUrl,
    };
  }

  // Cria um objeto Autor a partir de um mapa (JSON)
  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      nome: json['nome'],
      idade: json['idade'],
      estado: json['estado'],
      cidade: json['cidade'],
      fotoUrl: json['fotoUrl'],
    );
  }
}
