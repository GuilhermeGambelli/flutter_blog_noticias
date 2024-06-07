// ignore_for_file: prefer_const_constructors

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_blog/view/post_details_view.dart';
import 'package:flutter_blog/view/usuarios_view.dart';
import 'firebase_options.dart';
import 'view/autores_cadastrar_view.dart';
import 'view/autores_view.dart';
import 'view/login_view.dart';
import 'view/post_create_view.dart';
import 'view/principal_view.dart';
import 'view/sobre_view.dart';
import 'view/usuarios_cadastrar_view.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginView(),
        'cadastrar': (context) => UsuariosCadastrarView(),
        'principal': (context) => PrincipalView(),
        'sobre': (context) => SobreView(),
        'posts': (context) => PostCreateView(),
        'post_detalhes': (context) => PostDetailsView(),
        'usuarios': (context) => UsuariosView(),
        'autores': (context) => AutoresView(),
        'criar_autores': (context) => AutoresCadastrarView(),
      },
    );
  }
}
