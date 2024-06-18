import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/categoria_controller.dart';
import '../model/cores.dart';

class CategoriasView extends StatefulWidget {
  const CategoriasView({Key? key}) : super(key: key);

  @override
  CategoriasViewState createState() => CategoriasViewState();
}

class CategoriasViewState extends State<CategoriasView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Cor de fundo da tela
      appBar: AppBar(
        title: Text(
          'Categorias',
          style: TextStyle(color: Cores.corPrincipal),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, 'principal'),
        ),
      ),
      // BODY
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          //fluxo de dados em tempo real
          stream: CategoriaController().listarCategorias(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              //sem conexão
              case ConnectionState.none:
                return const Center(
                  child: Text('Não foi possível conectar.'),
                );

              //aguardando a execução da consulta
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              default:
                final dados = snapshot.requireData;
                if (dados.size > 0) {
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      dynamic doc = dados.docs[index].data();
                      return Card(
                        child: ListTile(
                          title: Text(doc['nome']),
                          subtitle: Text(
                            doc['responsavel'],
                            style: const TextStyle(fontSize: 12.0)),
                          trailing: SizedBox( // Adiciona a linha com os botões de editar e excluir
                            width: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                    },
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Confirmar exclusão"),
                                        content: const Text("Deseja realmente excluir esta categoria?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context), 
                                            child: const Text("Cancelar"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              CategoriaController().excluirCategoria(context, doc.id); 
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Categoria excluído com sucesso!"))
                                              );
                                            },
                                            child: const Text("Excluir"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete_outlined),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Nenhuma categoria encontrada.'),
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'criar_categorias');
        }, // Icon color on primary background
        backgroundColor: Cores.corPrincipal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
