import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/controller/login_controller.dart';
import 'package:flutter_blog/controller/post_controller.dart';
import 'package:flutter_blog/controller/autor_controller.dart';
import 'package:flutter_blog/controller/categoria_controller.dart';
import 'package:intl/intl.dart';

import '../model/post.dart';
import '../model/cores.dart';

class PostCreateView extends StatefulWidget {
  const PostCreateView({Key? key}) : super(key: key);

  @override
  State<PostCreateView> createState() => _PostCreateViewState();
}

class _PostCreateViewState extends State<PostCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _conteudoController = TextEditingController();
  final _dataCriacaoController = TextEditingController();
  final _dataEdicaoController = TextEditingController();
  final _imagemUrlController = TextEditingController();
  List<String> _categorias = [];
  List<String> _categoriasSelecionadas = [];
  bool isEditing = false;
  final agora = DateTime.now().toUtc().add(const Duration(hours: -3));

  String? _selectedAuthor;
  List<DropdownMenuItem<String>> _authorDropdownItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final DocumentSnapshot? postDoc = ModalRoute.of(context)?.settings.arguments as DocumentSnapshot?;
    if (postDoc != null) {
      isEditing = true;
      final postData = postDoc.data() as Map<String, dynamic>;
      _selectedAuthor = postData['nomeAutor'];
      _tituloController.text = postData['titulo'];
      _descricaoController.text = postData['descricao'];
      _conteudoController.text = postData['conteudo'];
      _categoriasSelecionadas = postData.containsKey('categorias') && postData['categorias'] is List
            ? List<String>.from(postData['categorias'] as List<dynamic>)
            : [];
      _imagemUrlController.text = postData['imagemUrl'] ?? '';
      _dataCriacaoController.text = DateFormat('dd/MM/yyyy HH:mm').format((postData['dataCriacao'] as Timestamp).toDate());
      _dataEdicaoController.text = postData['dataEdicao'] != null
        ? DateFormat('dd/MM/yyyy HH:mm').format((postData['dataEdicao'] as Timestamp).toDate())
        : 'Nunca editado';
    } else {
      _dataCriacaoController.text = DateFormat('dd/MM/yyyy HH:mm').format(agora);
      _dataEdicaoController.text = DateFormat('dd/MM/yyyy HH:mm').format(agora);
    }

    _loadAuthors();
    _loadCategorias();
  }

  Future<void> _loadAuthors() async {
    final authorsSnapshot = await AutorController().listarAutoresFuture();
    setState(() {
      _authorDropdownItems = authorsSnapshot.docs.map((doc) {
        final authorData = doc.data() as Map<String, dynamic>;
        return DropdownMenuItem<String>(
          value: authorData['nome'],
          child: Text(authorData['nome']),
        );
      }).toList();
    });
  }

  Future<void> _loadCategorias() async {
    final categoriasSnapshot = await CategoriaController().listarCategoriasFuture();
    setState(() {
      _categorias = categoriasSnapshot.docs.map((doc) {
        final categoriaData = doc.data() as Map<String, dynamic>;
        return categoriaData['nome'] as String;
      }).toList().cast<String>();
    });
  }

  void _criarOuEditarPost() async {
    if (_formKey.currentState!.validate()) {
      final DocumentSnapshot? postDoc = ModalRoute.of(context)?.settings.arguments as DocumentSnapshot?;
      Timestamp dataCriacao = isEditing 
          ? (postDoc!.data() as Map<String, dynamic>)['dataCriacao'] 
          : Timestamp.fromDate(DateFormat('dd/MM/yyyy HH:mm').parse(_dataCriacaoController.text));
      Timestamp dataEdicao = Timestamp.fromDate(
          DateFormat('dd/MM/yyyy HH:mm').parse(_dataEdicaoController.text));
      var t = Post(
        uid: LoginController().idUsuarioLogado(),
        categoria: _categoriasSelecionadas,
        nomeAutor: _selectedAuthor!,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        conteudo: _conteudoController.text,
        imagemUrl: _imagemUrlController.text,
        dataCriacao: dataCriacao,
        dataEdicao: dataEdicao,
      );
      if (isEditing) {
        PostController().atualizarPost(context, postDoc!.id, t);
      } else {
        PostController().criarPost(context, t);
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _conteudoController.dispose();
    _dataCriacaoController.dispose();
    _dataEdicaoController.dispose();
    _imagemUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Post' : 'Criar Post',
          style: TextStyle(color: Cores.corPrincipal),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, 'principal'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedAuthor,
                decoration: InputDecoration(
                  labelText: 'Nome do Autor',
                  prefixIcon: Icon(Icons.person, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                items: _authorDropdownItems,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAuthor = newValue!;
                  });
                },
                validator: (value) => value == null ? 'Selecione um autor' : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField2<String>(
                decoration: InputDecoration(
                  labelText: 'Categorias',
                  prefixIcon: Icon(Icons.category, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                value: null,
                onChanged: (String? newValue) {
                  setState(() {
                    if (_categoriasSelecionadas.contains(newValue)) {
                      _categoriasSelecionadas.remove(newValue);
                    } else {
                      _categoriasSelecionadas.add(newValue!);
                    }
                  });
                },
                items: _categorias.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                customButton: DropdownButtonHideUnderline(
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: _categoriasSelecionadas.map((categoria) => Chip(
                            label: Text(categoria),
                            onDeleted: () {
                              setState(() {
                                _categoriasSelecionadas.remove(categoria);
                              });
                            },
                          )).toList(),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Cores.corPrincipal),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _tituloController,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descricaoController,
                maxLength: 60,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A descrição é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _conteudoController,
                maxLength: 500,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Conteúdo',
                  prefixIcon: Icon(Icons.article, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O conteúdo é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _imagemUrlController,
                decoration: InputDecoration(
                  labelText: 'URL da Imagem',
                  prefixIcon: Icon(Icons.image, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a URL da imagem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _dataCriacaoController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Data de Criação',
                  prefixIcon: Icon(Icons.calendar_today, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _dataEdicaoController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Data de Edição',
                  prefixIcon: Icon(Icons.edit_calendar, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(140, 40),
                      backgroundColor: Cores.corPrincipal,
                    ),
                    onPressed: _criarOuEditarPost,
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
