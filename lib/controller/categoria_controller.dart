// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/categoria.dart';
import '../view/util.dart';

class CategoriaController {
  // Criar categoria
  Future<void> criarCategoria(BuildContext context, Categoria categoria) async {
    try {
      await FirebaseFirestore.instance
          .collection('categorias')
          .add(categoria.toJson());
      sucesso(context, 'Categoria criada com sucesso!');
    } catch (e) {
      erro(context, 'Erro ao criar categoria: $e');
    }
  }

  // Atualizar categoria
  Future<void> atualizarCategoria(BuildContext context, String documentId, Categoria categoria) async {
    try {
      await FirebaseFirestore.instance
          .collection('categorias')
          .doc(documentId)
          .update(categoria.toJson());
      sucesso(context, 'Categoria atualizada com sucesso!');
    } catch (e) {
      erro(context, 'Erro ao atualizar categoria: $e');
    }
  }

  // Excluir categoria
  Future<void> excluirCategoria(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categorias')
          .doc(documentId)
          .delete();
      sucesso(context, 'Categoria excluída com sucesso!');
    } catch (e) {
      erro(context, 'Erro ao excluir categoria: $e');
    }
  }

    // Listar autores
  Stream<QuerySnapshot> listarCategorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  Future<QuerySnapshot> listarCategoriasFuture() {
    return FirebaseFirestore.instance.collection('categorias').get();
  }
}
