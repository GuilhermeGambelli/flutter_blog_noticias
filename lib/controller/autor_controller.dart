import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/autor.dart';
import '../view/util.dart';

class AutorController {
  // Criar autor
  criarAutor(BuildContext context, Autor autor) async {
    try {
      await FirebaseFirestore.instance
          .collection('autores')
          .add(autor.toJson());
      sucesso(context, 'Autor criado com sucesso!');
    } catch (e) {
      erro(context, 'Erro ao criar autor: $e');
    }
  }

  // Atualizar autor
  atualizarAutor(BuildContext context, String documentId, Autor autor) async {
    try {
      await FirebaseFirestore.instance
          .collection('autores')
          .doc(documentId)
          .update(autor.toJson());
      sucesso(context, 'Autor atualizado com sucesso!');
    } catch (e) {
      erro(context, 'Erro ao atualizar autor: $e');
    }
  }

  // Excluir autor
  excluirAutor(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('autores')
          .doc(documentId)
          .delete();
      sucesso(context, 'Autor excluído com sucesso!');
    } catch (e) {
      erro(context, 'Erro ao excluir autor: $e');
    }
  }

  // Listar autores
  listarAutores() {
    return FirebaseFirestore.instance.collection('autores').snapshots();
  }
}
