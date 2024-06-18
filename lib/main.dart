import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_blog/view/categoria_cadastrar_view.dart';
import 'package:flutter_blog/view/pesquisa_view.dart';
import 'package:flutter_blog/view/post_details_view.dart';
import 'package:flutter_blog/view/usuarios_view.dart';
import 'firebase_options.dart';
import 'view/autores_cadastrar_view.dart';
import 'view/autores_view.dart';
import 'view/categoria_view.dart';
import 'view/comentarios_view.dart';
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
    enabled: false,
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
        'login': (context) => const LoginView(),
        'cadastrar': (context) => const UsuariosCadastrarView(),
        'principal': (context) => const PrincipalView(),
        'sobre': (context) => const SobreView(),
        'posts': (context) => const PostCreateView(),
        'post_detalhes': (context) => const PostDetailsView(),
        'usuarios': (context) => const UsuariosView(),
        'autores': (context) => const AutoresView(),
        'criar_autores': (context) => const AutoresCadastrarView(),
        'comentario': (context) => const ComentariosView(),
        'pesquisa': (context) => const PesquisaView(),
        'criar_categorias': (context) => const CadastrarCategoriaView(),
        'categorias': (context) => const CategoriasView(),
      },
    );
  }
}
