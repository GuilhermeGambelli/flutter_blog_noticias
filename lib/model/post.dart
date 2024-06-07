import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final dynamic categoria;
  final String nomeAutor;
  final String titulo;
  final String descricao;
  final String conteudo;
  final String imagemUrl;
  final Timestamp dataCriacao;
  final Timestamp? dataEdicao;

  Post({
    required this.uid,
    required this.categoria, 
    required this.nomeAutor, 
    required this.titulo, 
    required this.descricao,
    required this.conteudo,
    required this.imagemUrl,
    required this.dataCriacao,
    this.dataEdicao});

  //Transforma um OBJETO em JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'categoria': categoria,
      "nomeAutor": nomeAutor,
      'titulo': titulo,
      'descricao': descricao,
      'conteudo': conteudo,
      'imagemUrl': imagemUrl,
      "dataCriacao": dataCriacao,
      "dataEdicao": dataEdicao
    };
  }

  //Transforma um JSON em OBJETO
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      uid: json['uid'],
      categoria: List<String>.from(json['categoria']),
      nomeAutor: json['nomeAutor'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      conteudo:  json['conteudo'],
      imagemUrl:  json['imagemUrl'],
      dataCriacao:  json['dataCriacao'],
      dataEdicao:  json['dataEdicao']
    );
  }
}
