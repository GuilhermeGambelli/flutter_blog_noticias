import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blog/controller/login_controller.dart';
import '../model/cores.dart';
import '../model/usuario.dart';

class UsuariosView extends StatefulWidget {
  const UsuariosView({super.key});

  @override
  State<UsuariosView> createState() => _UsuariosViewState();
}

class _UsuariosViewState extends State<UsuariosView> {
  final TextEditingController _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Usuários',
          style: TextStyle(color: Cores.corPrincipal),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, 'principal'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: LoginController().listaUsers().snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text('Não foi possível conectar.'),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                final dados = snapshot.requireData;
                return ListView.builder(
                  itemCount: dados.size,
                  itemBuilder: (context, index) {
                    Usuario usuario = Usuario.fromJson(
                        dados.docs[index].data() as Map<String, dynamic>);

                    return Card(
                      child: ListTile(
                        title: Text(usuario.nome),
                        subtitle: Text(
                          usuario.email,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                        onTap: () {
                          _mostrarDetalhesUsuario(usuario);
                        },
                        trailing: IconButton(
                          // Botão de edição
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _mostrarDialogoEditarNome(usuario);
                          },
                        ),
                      ),
                    );
                  },
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'cadastrar');
        },
        backgroundColor: Cores.corPrincipal,
        child: const Icon(Icons.person, color: Colors.white),
      ), // Fechamento do floatingActionButton
    ); // Fechamento do Scaffold
  }

  // Função para exibir os detalhes do usuário em um diálogo
  void _mostrarDetalhesUsuario(Usuario usuario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(usuario.nome),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${usuario.email}'),
              Text(
                  'Data de Nascimento: ${usuario.dia}/${usuario.mes}/${usuario.ano}'),
              Text('Estado: ${usuario.estado}'),
              Text('Cidade: ${usuario.cidade}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // Função para exibir o diálogo de edição do nome
  void _mostrarDialogoEditarNome(Usuario usuario) {
    _nomeController.text =
        usuario.nome; // Preenche o controlador com o nome atual
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Nome'),
          content: TextField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Novo Nome'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                _editarNomeUsuario(usuario);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Função para editar o nome do usuário no Firestore
  void _editarNomeUsuario(Usuario usuario) async {
    String novoNome = _nomeController.text;
    if (novoNome.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuario.uid)
            .update({'nome': novoNome});
        // Atualizar a interface (opcional)
        setState(() {}); // Recarrega a lista de usuários
      } catch (e) {
        // Tratar erros (exibir mensagem, etc.)
        print('Erro ao editar nome do usuário: $e');
      }
    }
  }
}
