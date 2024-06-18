// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/login_controller.dart';
import '../model/comentario.dart';
import '../controller/comentario_controller.dart';
import '../model/cores.dart';

class ComentariosView extends StatefulWidget {
  const ComentariosView({Key? key}) : super(key: key);

  @override
  _ComentariosViewState createState() => _ComentariosViewState();
}

class _ComentariosViewState extends State<ComentariosView> {
  final _formKey = GlobalKey<FormState>();
  final _comentarioController = TextEditingController();
  String? nomeUsuario;
  int _avaliacao = 0;

  Future<void> _carregarNomeUsuario() async {
    String? nome = await LoginController().obterNomeUsuarioLogado();
    setState(() {
      nomeUsuario = nome;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  @override
  Widget build(BuildContext context) {
    final postDoc = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COMENTÁRIOS', 
          style: TextStyle(color: Cores.corPrincipal)),
          centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Cores.corPrincipal),
      ),     
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ComentarioController().listarComentarios(postDoc.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar comentários'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comentarios = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comentarios.length,
                  itemBuilder: (context, index) {
                    final comentarioData = comentarios[index].data();
                    final comentario = Comentario.fromJson(comentarioData);

                    final primeiraLetra = comentario.nomeAutor.isNotEmpty ? comentario.nomeAutor[0].toUpperCase() : '';

                    return Card( // Card para cada comentário
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 2, // Sombra sutil
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                Text(comentario.nomeAutor, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(comentario.texto),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow[700], size: 16),
                                const SizedBox(width: 5),
                                Text('${comentario.avaliacao}/5'),
                                const Spacer(),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm').format(comentario.data.toDate()),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Campo para novo comentário
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column( 
                children: [
                  TextFormField(
                    controller: _comentarioController,
                    decoration: const InputDecoration(labelText: 'Escreva seu comentário'),
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite um comentário';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) => IconButton(
                      icon: Icon(
                        index < _avaliacao ? Icons.star : Icons.star_border,
                        color: Colors.yellow[700],
                        size: 16,
                      ),
                      onPressed: () => setState(() => _avaliacao = index + 1),
                    )),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cores.corPrincipal,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _avaliacao > 0) {
                        ComentarioController().criarComentario(
                          context,
                          postDoc.id,
                          Comentario(
                            nomeAutor: nomeUsuario!,
                            texto: _comentarioController.text,
                            data: Timestamp.now(),
                            avaliacao: _avaliacao, 
                          ),
                        );
                        setState(() {
                          _avaliacao = 0; 
                          _comentarioController.clear();
                        });
                      } else if (_avaliacao == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selecione uma avaliação'))
                        );
                      }
                    },
                    child: const Text('Enviar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}