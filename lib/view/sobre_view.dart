import 'package:flutter/material.dart';
import '../model/cores.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre o desenvolvedor',
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
        child: Column(
          children: [
            // Information section with padding and spacing
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Guilherme Sandri Gambelli'),
                  ),
                  ListTile(
                    leading: Icon(Icons.functions),
                    title: Text('Desenvolvedor Flutter'),
                  ),
                  ListTile(
                    leading: Icon(Icons.code),
                    title: Text('Código: 836515'),
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Curso: Engenharia da Computação'),
                  ),
                  ListTile(
                    leading: Icon(Icons.link),
                    title: Text(
                      'github.com/GuilhermeGambelli',
                      style: TextStyle(color: Colors.blue),                     
                      ),
                  ),
                  SizedBox(height: 20.0), // Add some space after links
                ],
              ),
            ),

            const SizedBox(height: 400), // Adjust spacing before copyright

            _copyright(),
          ],
        ),
      ),
    );
  }

  Widget _copyright() {
    return const Padding(
      padding: EdgeInsets.all(8.0), // Adjust padding
      child: Text(
        '© 2024 - Projeto Gambelli',
        style: TextStyle(fontSize: 12, color: Colors.grey), // Gray color for copyright
      ),
    );
  }
}
