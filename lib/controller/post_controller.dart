import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/controller/login_controller.dart';

import '../model/post.dart';
import '../view/util.dart';

class PostController{

  criarPost(context, Post t) {
    FirebaseFirestore.instance
        .collection('posts')
        .add(t.toJson())
        .then((resultado) {
      sucesso(context, "Post criado com sucesso");
    }).catchError((e) {
      erro(context, "Não foi possível criar a tarefa");
    }).whenComplete(() => Navigator.pop(context));
  }

  listarPosts() {
    return FirebaseFirestore.instance
        .collection('posts');
  }

  listarPostsUser() {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('uid',isEqualTo: LoginController().idUsuarioLogado());
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
    FirebaseFirestore.instance.collection('posts')
    .doc(id)
    .update(t.toJson())
    .then((value) => sucesso(context, 'Post atualizado com sucesso'))
    .catchError((e) => erro(context, 'Não foi possível atualizar o post'))
    .whenComplete(() => Navigator.pop(context));
  }
}