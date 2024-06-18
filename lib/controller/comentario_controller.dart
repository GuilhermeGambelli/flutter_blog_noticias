// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/comentario.dart';
import '../view/util.dart';

class ComentarioController {
  // Criar comentário (modificado)
  Future<void> criarComentario(BuildContext context, String postId, Comentario comentario) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comentarios')
          .add(comentario.toJson()); // Salva a avaliação junto com o comentário
      sucesso(context, 'Comentário criado com sucesso!');
    } catch (e) {
      erro(context, 'Erro ao criar comentário: $e');
    }
  }

  // Listar comentários de um post
  Stream<QuerySnapshot<Map<String, dynamic>>> listarComentarios(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comentarios')
        .orderBy('data', descending: true) // Ordenar por data decrescente
        .snapshots();
  }
}
