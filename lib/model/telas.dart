import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/post_controller.dart';
import '../model/cores.dart';

class Telas {
  static const String erroCarregarPosts = 'Erro ao carregar posts';
  static const double cardElevation = 4.0;
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(vertical: 8, horizontal: 16);

  static Widget _buildNomeAutor(String nomeAutor, String primeiraLetra) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Cores.corPrincipal,
          radius: 10,
          child: Text(
            primeiraLetra,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          nomeAutor,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  static Widget _buildPostItem(BuildContext context, Map<String, dynamic> post, DocumentSnapshot postDoc, {bool mostrarBotoes = false}) {
    final nomeAutor = post['nomeAutor'];
    final primeiraLetra = nomeAutor.isNotEmpty ? nomeAutor[0].toUpperCase() : '';
    final imageUrl = post['imagemUrl'];

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'post_detalhes', arguments: postDoc);
      },
      child: Card(
        margin: cardMargin,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(child: Text('Erro ao carregar a imagem')),
                  ),
                ),
              ),
            ListTile(
              title: Text(post['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['descricao']),
                  const SizedBox(height: 4),
                  _buildNomeAutor(nomeAutor, primeiraLetra),
                ],
              ),
              trailing: mostrarBotoes
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Cores.corPrincipal),
                          onPressed: () {
                            Navigator.pushNamed(context, 'posts', arguments: postDoc);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar Exclusão'),
                                content: const Text('Deseja realmente excluir este post?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      PostController().excluirPost(context, postDoc.id);
                                    },
                                    child: const Text('Excluir'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : null, // Não exibe os botões se mostrarBotoes for falso
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildPost() {
    return StreamBuilder<QuerySnapshot>(
      stream: PostController().listarPosts().snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text(erroCarregarPosts));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final postDoc = posts[index];
            final post = postDoc.data() as Map<String, dynamic>;
            return _buildPostItem(context, post, postDoc);
          },
        );
      },
    );
  }

  static Widget buildAutorais() {
    return StreamBuilder<QuerySnapshot>(
      stream: PostController().listarPostsUser().snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text(erroCarregarPosts));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final postDoc = posts[index];
            final post = postDoc.data() as Map<String, dynamic>;
            return _buildPostItem(context, post, postDoc, mostrarBotoes: true); // Exibe os botões em 'autorais'
          },
        );
      },
    );
  }
}
