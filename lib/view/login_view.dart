// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:flutter_blog/controller/login_controller.dart';
import '../model/cores.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var txtEmail = TextEditingController(); // Preenche o e-mail
  var txtSenha = TextEditingController();
  var txtEmailEsqueceuSenha = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Subtle background color
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center elements vertically
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 40,
                color: Cores.corPrincipal,
                fontWeight: FontWeight.bold, // Make title bolder
              ),
            ),
            SizedBox(height: 60),
            TextField(
              controller: txtEmail,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Cores.corPrincipal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  borderSide: BorderSide(color: Cores.corPrincipal),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: txtSenha,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.password, color: Cores.corPrincipal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Cores.corPrincipal),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Cores.corPrincipal,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Esqueceu a senha?"),
                        content: Container(
                          height: 150,
                          child: Column(
                            children: [
                              Text(
                                "Identifique-se para receber um e-mail com as instruções e o link para criar uma nova senha.",
                              ),
                              SizedBox(height: 25),
                              TextField(
                                controller: txtEmailEsqueceuSenha,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actionsPadding: EdgeInsets.all(20),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              //
                              // Enviar email recuperação de senha
                              //
                              LoginController().esqueceuSenha(
                                context,
                                txtEmailEsqueceuSenha.text,
                              );
                              Navigator.pop(context);
                            },
                            child: Text('enviar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Esqueceu a senha?'),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 40),
                backgroundColor: Cores.corPrincipal, // Primary button color
              ),
              onPressed: () {
                //
                // Login
                //
                LoginController().login(
                  context,
                  txtEmail.text,
                  txtSenha.text,
                );
              },
              child: Text(
                'Entrar',
                style: TextStyle(
                    color: Colors.white), // White text for better contrast
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ainda não tem conta?',
                  style:
                      TextStyle(color: Colors.grey[600]), // Subdued text color
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'cadastrar');
                  },
                  child: Text(
                    'Cadastre-se',
                    style: TextStyle(
                        color: Cores.corPrincipal), // Primary color for link
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
