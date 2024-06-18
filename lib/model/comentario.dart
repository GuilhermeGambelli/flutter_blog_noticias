import 'package:cloud_firestore/cloud_firestore.dart';

class Comentario {
  final String nomeAutor;
  final String texto;
  final Timestamp data;
  final int avaliacao; // Adiciona o campo avaliacao

  Comentario({
    required this.nomeAutor,
    required this.texto,
    required this.data,
    required this.avaliacao, // Adiciona o parâmetro avaliacao
  });

  Map<String, dynamic> toJson() {
    return {
      'nomeAutor': nomeAutor,
      'texto': texto,
      'data': data,
      'avaliacao': avaliacao,
    };
  }

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      nomeAutor: json['nomeAutor'],
      texto: json['texto'],
      data: json['data'],
      avaliacao: json['avaliacao'],
    );
  }
}
