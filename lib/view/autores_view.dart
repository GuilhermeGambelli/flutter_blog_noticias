import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blog/controller/autor_controller.dart';
import '../model/cores.dart';

class AutoresView extends StatefulWidget {
  const AutoresView({super.key});

  @override
  State<AutoresView> createState() => AutoresViewState();
}

class AutoresViewState extends State<AutoresView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Subtle background color
      appBar: AppBar(
        title: Text(
          'Autores',
          style: TextStyle(color: Cores.corPrincipal), // Use your Cores.corPrincipal
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
          //fluxo de dados em tempo real
          stream: AutorController().listarAutores(),
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
                if (dados.size > 0) {
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      final doc = dados.docs[index]; // Use doc como DocumentSnapshot
                      final autorData = doc.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(autorData['fotoUrl']),
                          ),
                          title: Text(autorData['nome']),
                          subtitle: Text(
                            'Idade: ${autorData['idade'].toString()}, ${autorData['cidade']} - ${autorData['estado']}', 
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          trailing: SizedBox(
                            width: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  //
                                  // ATUALIZAR
                                  //
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'criar_autores', arguments: doc); // Passa doc como DocumentSnapshot
                                    },
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                ),

                                //
                                // EXCLUIR
                                //
                                IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Confirmar exclusão"),
                                              content: const Text("Deseja realmente excluir este autor?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context), 
                                                  child: const Text("Cancelar"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    AutorController().excluirAutor(context, doc.id); 
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text("Autor excluído com sucesso!"))
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
                    child: Text('Nenhum autor encontrado.'),
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'criar_autores');
        },
        backgroundColor: Cores.corPrincipal,
        child: const Icon(Icons.person, color: Colors.white),
      ),
    );
  }
}
