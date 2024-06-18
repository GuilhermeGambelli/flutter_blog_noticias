import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/service/ibge_service.dart';

import '../controller/autor_controller.dart';
import '../model/autor.dart';
import '../model/estado.dart';
import '../model/municipio.dart';
import '../model/cores.dart';

class AutoresCadastrarView extends StatefulWidget {
  const AutoresCadastrarView({Key? key}) : super(key: key);

  @override
  AutoresCadastrarViewViewState createState() => AutoresCadastrarViewViewState();
}

class AutoresCadastrarViewViewState extends State<AutoresCadastrarView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _fotoUrlController = TextEditingController();

  List<Estado> _estados = [];
  List<Municipio> _municipios = [];
  String? _estadoSelecionado;
  String? _municipioSelecionado;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _carregarEstados();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final DocumentSnapshot? autorDoc = ModalRoute.of(context)?.settings.arguments as DocumentSnapshot?;
    if (autorDoc != null) {
      isEditing = true;
      _preencherCamposComDadosDoAutor(autorDoc); // Chama a função para preencher os campos
    }
  }

  Future<void> _carregarEstados() async {
    final estados = await IbgeService().listarEstados();
    setState(() {
      _estados = estados;
    });
  }

  Future<void> _carregarMunicipios(String siglaEstado) async {
    final municipios = await IbgeService().listarMunicipios(siglaEstado);
    setState(() {
      _municipios = municipios;
      _municipioSelecionado = null; // Limpar a cidade ao trocar o estado
    });
  }

  void _criarOuEditarAutor(bool isEditing) async { // Adiciona o parâmetro isEditing
    if (_formKey.currentState!.validate()) {
      final DocumentSnapshot? autorDoc = ModalRoute.of(context)?.settings.arguments as DocumentSnapshot?;

      final autor = Autor(
        nome: _nomeController.text,
        idade: int.parse(_idadeController.text),
        estado: _estadoSelecionado!,
        cidade: _municipioSelecionado!,
        fotoUrl: _fotoUrlController.text,
      );

      if (isEditing) {
        AutorController().atualizarAutor(context, autorDoc!.id, autor);
      } else {
        AutorController().criarAutor(context, autor);
      }

      Navigator.pop(context); // Fecha a tela após criar/editar o autor
    }
  }
// Função para preencher os campos com os dados do autor
  void _preencherCamposComDadosDoAutor(DocumentSnapshot autorDoc) {
    final autorData = autorDoc.data() as Map<String, dynamic>;
    _nomeController.text = autorData['nome'];
    _idadeController.text = autorData['idade'].toString();
    _estadoSelecionado = autorData['estado'];
    _municipioSelecionado = autorData['estado']; // Carrega os municípios do estado
    _municipioSelecionado = autorData['cidade'];
    _fotoUrlController.text = autorData['fotoUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Cadastrar Autor',
          style: TextStyle(color: Cores.corPrincipal), // Use your Cores.corPrincipal
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, 'principal'),
        ), // Subtle background color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'O nome é obrigatório' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Idade',
                  prefixIcon: Icon(Icons.cake, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A idade é obrigatória';
                  }
                  final idade = int.tryParse(value);
                  if (idade == null || idade <= 0) {
                    return 'Idade inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Estado (UF)',
                        prefixIcon: Icon(Icons.map, color: Cores.corPrincipal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      value: _estadoSelecionado, // Estado selecionado (inicia nulo)
                      onChanged: (String? newValue) {
                        setState(() {
                          _estadoSelecionado = newValue;
                          _municipioSelecionado = null; // Limpa a cidade ao mudar o estado
                          _carregarMunicipios(newValue!);
                        });
                      },
                      items: _estados.map((estado) {
                        return DropdownMenuItem<String>(
                          value: estado.sigla,
                          child: Text(estado.sigla),
                        );
                      }).toList(),
                      validator: (value) => value == null ? 'Selecione um estado' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Cidade',
                        prefixIcon: Icon(Icons.location_city, color: Cores.corPrincipal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      value: _municipioSelecionado,
                      onChanged: (String? newValue) {
                        setState(() {
                          _municipioSelecionado = newValue;
                        });
                      },
                      items: _municipios.map((municipio) {
                        return DropdownMenuItem<String>(
                          value: municipio.nome,
                          child: Text(municipio.nome),
                        );
                      }).toList(),
                      validator: (value) => value == null ? 'Selecione uma cidade' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _fotoUrlController,
                decoration: InputDecoration(
                  labelText: 'URL da Foto',
                  prefixIcon: Icon(Icons.image, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'A URL da foto é obrigatória' : null,
              ),
              const SizedBox(height: 30),
                        ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(140, 40),
              backgroundColor: Cores.corPrincipal,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _criarOuEditarAutor(isEditing);
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
