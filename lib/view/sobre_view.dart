import 'package:flutter/material.dart';
import '../model/cores.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre',
          style: TextStyle(color: Cores.corPrincipal), // White text for better contrast
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[200], // Apply a primary color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, 'Login'), // Go back on press
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de Informações
            Text(
              'Informações do Aplicativo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Cores.corPrincipal,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.topic, color: Cores.corPrincipal),
                      title: const Text('Tema Escolhido:'),
                      subtitle: const Text('Blog de Notícias'),
                    ),
                    ListTile(
                      leading: Icon(Icons.lightbulb, color: Cores.corPrincipal),
                      title: const Text('Objetivo:'),
                      subtitle: const Text('Informar os usuários na internet'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seção do Desenvolvedor
            Text(
              'Desenvolvedor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Cores.corPrincipal,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: Cores.corPrincipal),
                      title: const Text('Guilherme Sandri Gambelli'),
                    ),
                    ListTile(
                      leading: Icon(Icons.functions, color: Cores.corPrincipal),
                      title: const Text('Desenvolvedor Flutter'),
                    ),
                    ListTile(
                      leading: Icon(Icons.code, color: Cores.corPrincipal),
                      title: const Text('Código: 836515'),
                    ),
                    ListTile(
                      leading: Icon(Icons.book, color: Cores.corPrincipal),
                      title: const Text('Curso: Engenharia da Computação'),
                    ),
                    ListTile(
                      leading: Icon(Icons.link, color: Cores.corPrincipal),
                      title: const Text(
                        'github.com/GuilhermeGambelli',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 20.0), 
                  ],
                ),
              ),
            ),
            const SizedBox(height: 400),
            _copyright(),
          ],
        ),
      ),
    );
  }

  Widget _copyright() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '© 2024 - Projeto Gambelli',
        style: TextStyle(fontSize: 12, color: Colors.grey), 
      ),
    );
  }
}
