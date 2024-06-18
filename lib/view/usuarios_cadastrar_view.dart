// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/service/ibge_service.dart';
import '../controller/login_controller.dart';
import '../model/estado.dart';
import '../model/municipio.dart';
import '../model/cores.dart';

class UsuariosCadastrarView extends StatefulWidget {
  const UsuariosCadastrarView({super.key});

  @override
  State<UsuariosCadastrarView> createState() => _UsuariosCadastrarState();
}

class _UsuariosCadastrarState extends State<UsuariosCadastrarView> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey para o formulário
  var txtNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtDia = TextEditingController(); // Controller para o dia
  var txtMes = TextEditingController(); // Controller para o mês
  var txtAno = TextEditingController(); // Controller para o ano
  var txtEstado = TextEditingController();
  var txtCidade = TextEditingController();
  bool _obscureText = true;
  int? _anoSelecionado;
  int? _mesSelecionado;
  int? _diaSelecionado;
  List<Estado> _estados = [];
  List<Municipio> _municipios = [];
  String? _estadoSelecionado;
  String? _municipioSelecionado;

  List<int> _getDiasNoMes(int ano, int mes) {
    final isLeapYear = (ano % 4 == 0) && (ano % 100 != 0) || (ano % 400 == 0);
    if (mes == 2) {
      return isLeapYear ? List.generate(29, (index) => index + 1) : List.generate(28, (index) => index + 1);
    } else if ([4, 6, 9, 11].contains(mes)) {
      return List.generate(30, (index) => index + 1);
    } else {
      return List.generate(31, (index) => index + 1);
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarEstados();
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

  String? validarData(String campo, String valor) {
    if (_anoSelecionado == null || _mesSelecionado == null || _diaSelecionado == null) {
      return 'Selecione uma data completa';
    }
    // Verifica a validade da data usando a classe DateTime
    try {
      final data = DateTime(_anoSelecionado!, _mesSelecionado!, _diaSelecionado!);
      // Se não lançar exceção, a data é válida
    } catch (e) {
      return 'Data inválida';
    }

    return null; // Data válida
  }

  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'O email é obrigatório';
    }

    // Expressão regular para verificar o formato do email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'O email deve conter @ e ter um formato válido (ex: nome@dominio.com)';
    }

    return null; // Email válido
  }

  String? validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'A senha é obrigatória';
    }

    // Verifica o comprimento mínimo da senha (8 caracteres ou mais)
    if (value.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres';
    }

    // Verifica a presença de pelo menos uma letra maiúscula
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }

    // Verifica a presença de pelo menos uma letra minúscula
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'A senha deve conter pelo menos uma letra minúscula';
    }

    // Verifica a presença de pelo menos um número
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'A senha deve conter pelo menos um número';
    }

    // Verifica a presença de pelo menos um caractere especial
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'A senha deve conter pelo menos um caractere especial';
    }

    return null; // Senha válida
  }

  @override
  Widget build(BuildContext context) {
    final anos = List.generate(DateTime.now().year - 1900 + 1, (index) => 1900 + index).reversed.toList();
    final meses = List.generate(12, (index) => index + 1);
    final dias = _getDiasNoMes(_anoSelecionado ?? DateTime.now().year, _mesSelecionado ?? DateTime.now().month); // Dias iniciais
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Criar Conta',
          style: TextStyle(color: Cores.corPrincipal), // Use your Cores.corPrincipal
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, 'principal'),
        ), // Subtle background color
      ),
      body: SingleChildScrollView( // Permite rolagem se o conteúdo for grande
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center elements vertically
            children: [
              SizedBox(height: 60),
              TextFormField(
                controller: txtNome,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person, color: Cores.corPrincipal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    borderSide: BorderSide(color: Cores.corPrincipal),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Ano',
                        prefixIcon: Icon(Icons.calendar_today, color: Cores.corPrincipal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      value: _anoSelecionado,
                      onChanged: (int? newValue) {
                        setState(() {
                          _anoSelecionado = newValue;
                          _diaSelecionado = null; // Reinicia o dia ao mudar o ano ou mês
                        });
                      },
                      items: anos.map((ano) {
                        return DropdownMenuItem<int>(
                          value: ano,
                          child: Text(ano.toString()),
                        );
                      }).toList(),
                      validator: (value) => validarData('Ano', value?.toString() ?? ''), // Validação do ano
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Mês',
                        prefixIcon: Icon(Icons.calendar_today, color: Cores.corPrincipal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      value: _mesSelecionado,
                      onChanged: (int? newValue) {
                        setState(() {
                          _mesSelecionado = newValue;
                          _diaSelecionado = null; // Reinicia o dia ao mudar o ano ou mês
                        });
                      },
                      items: meses.map((mes) {
                        return DropdownMenuItem<int>(
                          value: mes,
                          child: Text(mes.toString()),
                        );
                      }).toList(),
                      validator: (value) => validarData('Mês', value?.toString() ?? ''), // Validação do mês
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Dia',
                        prefixIcon: Icon(Icons.calendar_today, color: Cores.corPrincipal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      value: _diaSelecionado,
                      onChanged: (int? newValue) {
                        setState(() {
                          _diaSelecionado = newValue;
                        });
                      },
                      items: dias.map((dia) {
                        return DropdownMenuItem<int>(
                          value: dia,
                          child: Text(dia.toString().padLeft(2, '0')), // Exibe dia com dois dígitos (ex: 01, 02, ...)
                        );
                      }).toList(),
                      validator: (value) => validarData('Dia', value?.toString() ?? ''), // Validação do dia
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
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
                  SizedBox(width: 10),
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
              SizedBox(height: 15),
              TextFormField(
                controller: txtEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Cores.corPrincipal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Cores.corPrincipal),
                  ),
                ),
                validator: validarEmail,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: txtSenha,
                obscureText: _obscureText, // Controla a visibilidade
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.password, color: Cores.corPrincipal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  suffixIcon: IconButton( // Botão para mostrar/ocultar senha
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Cores.corPrincipal,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Inverte a visibilidade
                      });
                    },
                  ),
                ),
                validator: validarSenha,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.grey[600]), // Subdued text color
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(140, 40),
                      backgroundColor: Cores.corPrincipal, // Primary button color
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Verificar se os valores foram selecionados
                        if (_diaSelecionado != null && _mesSelecionado != null && _anoSelecionado != null && _estadoSelecionado != null && _municipioSelecionado != null) { 
                          LoginController().criarConta(
                            context,
                            txtNome.text,
                            txtEmail.text,
                            txtSenha.text,
                            _diaSelecionado!, 
                            _mesSelecionado!,
                            _anoSelecionado!,
                            _estadoSelecionado!, // Usar os valores dos Dropdowns
                            _municipioSelecionado!,
                          );
                        } else {
                          // Tratar o caso em que a data ou estado/cidade não foram selecionados
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor, preencha todos os campos.')),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white), // White text for better contrast
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
