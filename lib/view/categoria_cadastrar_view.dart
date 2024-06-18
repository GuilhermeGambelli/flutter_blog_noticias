// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/autor_controller.dart';
import '../controller/categoria_controller.dart'; // Importe o controlador de categorias
import '../model/autor.dart';
import '../model/categoria.dart'; // Importe o modelo de categoria
import '../model/cores.dart'; // Importe o modelo Municipio

class CadastrarCategoriaView extends StatefulWidget {
  const CadastrarCategoriaView({Key? key}) : super(key: key);

  @override
  CadastrarCategoriaViewState createState() => CadastrarCategoriaViewState();
}

class CadastrarCategoriaViewState extends State<CadastrarCategoriaView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  String? _selectedAuthor;
  List<DropdownMenuItem<String>> _authorDropdownItems = [];

  @override
  void initState() {
    super.initState();
    _loadAuthors();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Cadastrar Categoria', style: TextStyle(color: Cores.corPrincipal)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, 'principal'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome da Categoria',
                        prefixIcon: Icon(Icons.category, color: Cores.corPrincipal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'O nome da categoria é obrigatório' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _descricaoController,
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        prefixIcon: Icon(Icons.description, color: Cores.corPrincipal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'A descrição é obrigatória' : null,
                    ),
                    const SizedBox(height: 15),
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
                    // Campos de data (não editáveis)
                    TextFormField(
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                      ),
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Data de Criação',
                        prefixIcon: Icon(Icons.calendar_today, color: Cores.corPrincipal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),

                    const SizedBox(height: 15),
                    TextFormField(
                      controller: TextEditingController(
                        text: 'Nunca editado',
                      ),
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Data de Edição',
                        prefixIcon: Icon(Icons.edit_calendar, color: Cores.corPrincipal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 40),
                        backgroundColor: Cores.corPrincipal,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final categoria = Categoria(
                            nome: _nomeController.text,
                            descricao: _descricaoController.text,
                            responsavel: _selectedAuthor as String, // Obtém o nome do responsável do controlador
                            dataCriacao: Timestamp.now(),
                            dataEdicao: null,
                          );

                          await CategoriaController().criarCategoria(context, categoria);
                          Navigator.pop(context); 
                        }
                      },
                      child: const Text('Salvar', style: TextStyle(color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}