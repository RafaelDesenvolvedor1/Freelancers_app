import 'package:flutter/material.dart';
import 'package:freelancers_app/screens/discover_screen.dart';
import 'package:freelancers_app/screens/projects_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // � Controla qual aba está ativa no momento
  int _abaAtiva = 0;

  // �️ Lista de telas na ordem exata das abas da barra inferior
  final List<Widget> _telas = [
    const DiscoverScreen(),   // Aba 0: Descobrir
    const MyProjectsScreen(), // Aba 1: Projetos
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // � Renderiza a tela correspondente à aba selecionada
      body: _telas[_abaAtiva],
      
      // �️ Barra de Navegação Inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaAtiva, // Diz ao Flutter qual botão deve ficar aceso
        backgroundColor: const Color.fromARGB(255, 5, 10, 20), // Fundo escuro padrão
        selectedItemColor: const Color(0xFF6366F1), // Cor roxa para o ícone ativo
        unselectedItemColor: Colors.grey, // Cor cinza para o ícone inativo
        type: BottomNavigationBarType.fixed, // Mantém os botões firmes no lugar
        
        // � Evento que dispara toda vez que você clica em uma aba
        onTap: (index) {
          setState(() {
            _abaAtiva = index; // Atualiza o índice para trocar a tela no body
          });
        },
        
        // �️ Os botões da barra (Ícone + Texto)
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Descobrir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            label: 'Projetos',
          ),
        ],
      ),
    );
  }
}