// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/post_controller.dart';
import '../model/cores.dart';
import '../model/telas.dart';

class PesquisaView extends StatefulWidget {
  const PesquisaView({Key? key}) : super(key: key);

  @override
  _PesquisaViewState createState() => _PesquisaViewState();
}

class _PesquisaViewState extends State<PesquisaView> {
  @override
  void initState() {
    super.initState();
    _postsStream = PostController().listarPosts().snapshots(); // Inicializa com todos os posts
  }
  String? _filtroTitulo;
  String? _filtroAutor;
  List<String>? _filtroCategorias;
  DateTime? _filtroData;
  String? _ordemSelecionada = 'dataCriacao'; // Ordenação padrão por data de criação
  bool _ordemDescendente = true; // Ordem descendente por padrão
  final Telas telas = Telas();
  bool _mostrarFiltros = false;
  final List<String> _categorias = [
    'Carros', 'Motos', 'Jogos', 'Tecnologia', 'Comida', 'Moda',
    'Eletrônicos', 'Anime', 'Filmes', 'Séries'
  ];
  Stream<QuerySnapshot<Map<String, dynamic>>>? _postsStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Pesquisar Posts',
          style: TextStyle(color: Cores.corPrincipal),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, 'principal'),
        ), 
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _mostrarFiltros = !_mostrarFiltros;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Campos de Filtro
            if (_mostrarFiltros) ...[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (value) => setState(() => _filtroTitulo = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome do Autor'),
                onChanged: (value) => setState(() => _filtroAutor = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField2<String>(
                decoration: InputDecoration(
                  labelText: 'Categorias',
                  prefixIcon: Icon(Icons.category, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                value: null,
                onChanged: (String? newValue) {
                  setState(() {
                    if (_filtroCategorias!.contains(newValue)) {
                      _filtroCategorias!.remove(newValue);
                    } else {
                      _filtroCategorias!.add(newValue!);
                    }
                  });
                },
                items: _categorias.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: _filtroData != null ? DateFormat('dd/MM/yyyy').format(_filtroData!) : '',
                ),
                decoration: InputDecoration(
                  labelText: 'Data (dd/MM/yyyy)',
                  hintText: 'Ex: 30/05/2024',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final dataSelecionada = await showDatePicker(
                        context: context,
                        initialDate: _filtroData ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (dataSelecionada != null) {
                        setState(() {
                          _filtroData = dataSelecionada;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ordenar por:'),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _ordemSelecionada,
                    onChanged: (String? newValue) {
                      setState(() {
                        _ordemSelecionada = newValue!;
                      });
                    },
                    items: <String>['dataCriacao', 'titulo', 'nomeAutor']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value == 'dataCriacao' ? 'Data' : (value == 'titulo' ? 'Título' : 'Autor')),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(_ordemDescendente ? Icons.arrow_downward : Icons.arrow_upward),
                    onPressed: () {
                      setState(() {
                        _ordemDescendente = !_ordemDescendente;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
               ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Cores.corPrincipal,
                ),
                onPressed: () {
                  setState(() {
                    _postsStream = PostController().aplicarFiltros(
                      _filtroTitulo,
                      _filtroAutor,
                      _filtroCategorias,
                      _filtroData,
                      _ordemSelecionada,
                      _ordemDescendente,
                    ); // Atualiza o stream com os filtros aplicados
                  });
                },
                child: const Text('Pesquisar', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16.0),
            ],

            // Resultado da Pesquisa (ListView.builder)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _postsStream, // Usa o _postsStream atualizado
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('Erro na consulta: ${snapshot.error}');
                    return Center(child: Text('Erro ao carregar posts: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final posts = snapshot.data!.docs;

                  if (posts.isEmpty) {
                    return const Center(child: Text('Nenhum post encontrado.'));
                  }

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final postDoc = posts[index];
                      final post = postDoc.data() as Map<String, dynamic>;
                      return Telas.buildPostItem(context, post, postDoc);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}