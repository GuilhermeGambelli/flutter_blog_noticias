import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/controller/login_controller.dart';

import '../model/post.dart';
import '../view/util.dart';

class PostController {
  criarPost(context, Post t) {
    FirebaseFirestore.instance
        .collection('posts')
        .add(t.toJson())
        .then((resultado) {
      sucesso(context, "Post criado com sucesso");
    }).catchError((e) {
      erro(context, "Não foi possível criar o post");
    }).whenComplete(() => Navigator.pop(context));
  }

  listarPosts() {
    return FirebaseFirestore.instance.collection('posts');
  }

  listarPostsUser() {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: LoginController().idUsuarioLogado());
  }

  excluirPost(context, id) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .delete()
        .then((value) => sucesso(context, 'Post excluído com sucesso!'))
        .catchError((e) => erro(context, 'Não foi possível excluir o post!'))
        .whenComplete(() => Navigator.pop(context));
  }

  atualizarPost(context, id, Post t) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .update(t.toJson())
        .then((value) => sucesso(context, 'Post atualizado com sucesso'))
        .catchError((e) => erro(context, 'Não foi possível atualizar o post'))
        .whenComplete(() => Navigator.pop(context));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> aplicarFiltros(
    String? titulo,
    String? autor,
    List<String>? categorias,
    DateTime? data,
    String? orderBy,
    bool ordemDescendente,
  ) {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('posts');

    // Filtro por título (ignorando maiúsculas/minúsculas)
    if (titulo != null && titulo.isNotEmpty) {
      query = query
          .where('titulo', isGreaterThanOrEqualTo: titulo.toLowerCase())
          .where('titulo', isLessThan: titulo.toLowerCase() + 'z');
    }

    // Filtro por autor (ignorando maiúsculas/minúsculas)
    if (autor != null && autor.isNotEmpty) {
      query = query
          .where('nomeAutor', isGreaterThanOrEqualTo: autor.toLowerCase())
          .where('nomeAutor', isLessThan: autor.toLowerCase() + 'z');
    }

    // Filtro por categorias
    if (categorias != null && categorias.isNotEmpty) {
      query = query.where('categorias', arrayContainsAny: categorias);
    }

    // Filtro por data
    if (data != null) {
      final inicioDoDia = DateTime(data.year, data.month, data.day);
      final fimDoDia = inicioDoDia.add(const Duration(days: 1));
      query = query
          .where('dataCriacao',
              isGreaterThanOrEqualTo: Timestamp.fromDate(inicioDoDia))
          .where('dataCriacao', isLessThan: Timestamp.fromDate(fimDoDia));
    }
    
    if (orderBy != null) {
      if (orderBy == 'dataCriacao') {
        query = query.orderBy(orderBy, descending: ordemDescendente);
      } else if (orderBy == 'titulo' || orderBy == 'nomeAutor') {
        query = query.orderBy(orderBy, descending: ordemDescendente).orderBy('dataCriacao', descending: true);
      }
    }

    return query.snapshots();
  }
}
