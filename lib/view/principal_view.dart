import 'package:flutter/material.dart';
import 'package:flutter_blog/model/telas.dart';
import '../controller/login_controller.dart';
import '../model/cores.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  var txtTitulo = TextEditingController();
  var txtDescricao = TextEditingController();
  String? nomeUsuario;
  int _selectedIndex = 0;
  final Telas telas = Telas();

  Future<void> _carregarNomeUsuario() async {
    // Chama a função para obter o nome do usuário e atualiza o estado
    String? nome = await LoginController().obterNomeUsuarioLogado();
    setState(() {
      nomeUsuario = nome;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> telasWidget = [
      Telas.buildPost(), // Chame buildPost na instância de Telas
      Telas.buildAutorais(), // Chame buildPost na instância de Telas
    ];
    return Scaffold(
      backgroundColor: Colors.grey[200], // Subtle background color
      appBar: AppBar(
        title: Text(
          'UNAERP NEWS',
          style: TextStyle(color: Cores.corPrincipal), // Title color
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            color: Cores.corPrincipal, // Icon color
          ),
        ),
      ), 
        drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Cores.corPrincipal,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, ${nomeUsuario ?? ""}', 
                    style: const TextStyle(color: Colors.white),
                  ),
                ],           
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Cores.corPrincipal), // Icon color
              title: const Text('Usuários'),
              onTap: () => Navigator.pushNamed(context, 'usuarios'),
            ),
            ListTile(
              leading: Icon(Icons.attribution, color: Cores.corPrincipal), // Icon color
              title: const Text('Autores'),
              onTap: () => Navigator.pushNamed(context, 'autores'),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Cores.corPrincipal), // Icon color
              title: const Text('Categorias'),
              onTap: () => Navigator.pushNamed(context, 'categorias'),
            ),
            ListTile(
              leading: Icon(Icons.search, color: Cores.corPrincipal), // Icon color
              title: const Text('Pesquisa'),
              onTap: () => Navigator.pushNamed(context, 'pesquisa'),
            ),
            ListTile(
              leading: Icon(Icons.info, color: Cores.corPrincipal), // Icon color
              title: const Text('Sobre'),
              onTap: () => Navigator.pushNamed(context, 'sobre'),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Cores.corPrincipal), // Icon color
              title: const Text('Sair'),
              onTap: () {
                LoginController().logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
      body: IndexedStack( // Usa IndexedStack para alternar entre as telas
        index: _selectedIndex,
        children: telasWidget,
      ),
  
      floatingActionButton: _selectedIndex == 1 // Verifica se está na tela "Autorais"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, 'posts');
              }, 
              backgroundColor: Cores.corPrincipal,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      // Add the bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Notícias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Autorais',
          ),
        ],
        selectedItemColor: Cores.corPrincipal,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}