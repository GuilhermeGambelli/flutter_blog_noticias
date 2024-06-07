import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/usuario.dart';
import '../view/util.dart';

class LoginController {
  //
  // CRIAR CONTA de um usuário no servio Firebase Authentication
  //
  criarConta(context, nome, email, senha, dia, mes, ano, estado, cidade) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      Usuario novoUsuario = Usuario(
        uid: resultado.user!.uid,
        email: email,
        nome: nome,
        dia: dia,
        mes: mes,
        ano: ano,
        estado: estado,
        cidade: cidade,
      );
      //Armazenar o NOME e UID do usuário no Firestore
      FirebaseFirestore.instance
          .collection("usuarios")
          .doc(novoUsuario.uid)
          .set(novoUsuario.toJson());
      //Usuário criado com sucesso!
      sucesso(context, 'Usuário criado com sucesso!');
      Navigator.pop(context);
    }).catchError((e) {
      //Erro durante a criação do usuário
      switch (e.code) {
        case 'email-already-in-use':
          erro(context, 'O email já foi cadastrado.');
          break;
        case 'invalid-email':
          erro(context, 'O formato do e-mail é inválido.');
          break;
        default:
          erro(context, 'ERRO: ${e.toString()}');
      }
    });
  }

  //
  // LOGIN de usuário a partir do provedor Email/Senha
  //
  login(context, email, senha) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      // (resultado.user!.emailVerified) {
      sucesso(context, 'Usuário autenticado com sucesso');
      Navigator.pushNamed(context, 'principal');
      //} else {
      //  erro(context, 'O email ainda não foi verificado');
      //}
    }).catchError((e) {
      switch (e.code) {
        case 'user-not-found':
          erro(context, 'Usuário não encontrado.');
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  esqueceuSenha(context, email) {
    if (email.isNotEmpty) {
      FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      sucesso(context, 'Email enviado com sucesso.');
    } else {
      erro(context, 'Informe o email para recuperar a conta.');
    }
  }

  //
  // Efetuar logout do usuário
  //
  logout() {
    FirebaseAuth.instance.signOut();
  }

  //
  // Retornar o UID (User Identifier) do usuário que está logado no App
  //
  idUsuarioLogado() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  //Listar todos os usuarios
  listaUsers() {
    return FirebaseFirestore.instance.collection('usuarios');
  }

  Future<List<Map<String, dynamic>>> pesquisarUsers(String termo) async {
    final CollectionReference usuariosRef =
        FirebaseFirestore.instance.collection('usuarios');

    final QuerySnapshot querySnapshot = await usuariosRef
        .where('nome', isGreaterThanOrEqualTo: termo)
        .where('nome', isLessThan: '${termo}z')
        .get();

    final List<Map<String, dynamic>> usuarios = [];
    for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
      usuarios.add(doc.data() as Map<String, dynamic>);
    }

    return usuarios;
  }

  // Função para editar usuário
  Future<void> editarUser(String uid, Map<String, dynamic> novosDados) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid) // Acessa o documento do usuário pelo UID
          .update(novosDados); // Atualiza os dados
    } catch (e) {
      // Tratar erros (exibir mensagem, etc.)
      print('Erro ao editar usuário: $e');
    }
  }

  // Função para deletar usuário
  Future<void> deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid) // Acessa o documento do usuário pelo UID
          .delete(); // Remove o documento
    } catch (e) {
      // Tratar erros (exibir mensagem, etc.)
      print('Erro ao deletar usuário: $e');
    }
  }

  Future<String?> obterNomeUsuarioLogado() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        final snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .get();
        if (snapshot.exists) {
          return snapshot.data()?['nome']; // Retorna o nome do usuário
        }
      }
      return null;
    } catch (e) {
      print('Erro ao obter nome do usuário: $e');
      return null;
    }
  }
}
