import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria {
  final String nome;
  final String descricao;
  final String responsavel; // Nome do responsável pela categoria
  final Timestamp dataCriacao;
  final Timestamp? dataEdicao; // Pode ser nulo se a categoria nunca foi editada

  Categoria({
    required this.nome,
    required this.descricao,
    required this.responsavel,
    required this.dataCriacao,
    this.dataEdicao,
  });

  // Converte o objeto Categoria para um mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'responsavel': responsavel,
      'dataCriacao': dataCriacao,
      'dataEdicao': dataEdicao,
    };
  }

  // Cria um objeto Categoria a partir de um mapa (JSON)
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      nome: json['nome'],
      descricao: json['descricao'],
      responsavel: json['responsavel'],
      dataCriacao: json['dataCriacao'],
      dataEdicao: json['dataEdicao'],
    );
  }
}