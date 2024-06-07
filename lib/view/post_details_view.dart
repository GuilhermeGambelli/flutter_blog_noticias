import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/cores.dart';

class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final postDoc = ModalRoute.of(context)?.settings.arguments as DocumentSnapshot?;
    
    if (postDoc == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Erro'),
        ),
        body: const Center(child: Text('Post não encontrado')),
      );
    }

    final postData = postDoc!.data() as Map<String, dynamic>;
    final nomeAutor = postData['nomeAutor'];
    final primeiraLetra = nomeAutor.isNotEmpty ? nomeAutor[0].toUpperCase() : '';
    final imagemUrl = postData['imagemUrl'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'UNAERP NEWS', 
          style: TextStyle(color: Cores.corPrincipal)),
          centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Cores.corPrincipal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postData['titulo'],
              style: const TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Cores.corPrincipal,
                  radius: 15,
                  child: Text(
                    primeiraLetra,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  nomeAutor,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Criado em: ${_formataDataAmigavel(postData['dataCriacao'].toDate())}', 
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 10),
                if (postData['dataEdicao'] != null)
                  Text(
                    'Editado em: ${_formataDataAmigavel(postData['dataEdicao'].toDate())}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (imagemUrl != null && imagemUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imagemUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text('Erro ao carregar a imagem'),
                  ), // Exibe uma mensagem de erro
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Conteúdo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adiciona padding horizontal ao conteúdo
              child: Text(
                postData['conteudo'],
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: postData.containsKey('categorias') && postData['categorias'] is List<dynamic> // Verifica se existe e é uma lista
                  ? (postData['categorias'] as List<dynamic>).map((categoria) {
                      if (categoria is String) {
                        return Chip(
                          label: Text(categoria),
                          backgroundColor: Colors.grey[300],
                        );
                      }
                      return const SizedBox.shrink();
                    }).toList()
                  : [], // Se não existe ou não é uma lista, retorna uma lista vazia
            ),
          ],
        ),
      ),
    );
  }

  String _formataDataAmigavel(DateTime data) {
    DateTime agora = DateTime.now();
    Duration diferenca = agora.difference(data);

    if (diferenca.inDays > 0) {
      return 'há ${diferenca.inDays} dia${diferenca.inDays > 1 ? 's' : ''}';
    } else if (diferenca.inHours > 0) {
      return 'há ${diferenca.inHours} hora${diferenca.inHours > 1 ? 's' : ''}';
    } else if (diferenca.inMinutes > 0) {
      return 'há ${diferenca.inMinutes} minuto${diferenca.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'agora';
    }
  }
}
