import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freelancers_app/screens/new_project_screen.dart';

class MyProjectsScreen extends StatefulWidget {
  const MyProjectsScreen({super.key});

  @override
  State<MyProjectsScreen> createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends State<MyProjectsScreen> {
  List<dynamic> projetos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProjetos();
  }

  Future<void> fetchProjetos() async {
    final dio = Dio();
    try {
      final response = await dio.get('http://192.168.0.80:8000/projetos');
      setState(() {
        projetos = List<dynamic>.from(response.data['data']);
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao buscar projetos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // � Lógica condicional para definir a cor de fundo da badge de status
  Color _getBadgeBgColor(String status) {
    switch (status) {
      case 'Em andamento':
        return const Color(0xFF1E3A8A).withOpacity(0.4); // Azul escuro suave
      case 'Pendente':
        return const Color(0xFF78350F).withOpacity(0.4); // Laranja suave
      case 'Concluído':
        return const Color(0xFF064E3B).withOpacity(0.4); // Verde suave
      default:
        return const Color(0xFF334155);
    }
  }

  // � Lógica condicional para definir a cor do texto da badge de status
  Color _getBadgeTextColor(String status) {
    switch (status) {
      case 'Em andamento':
        return const Color(0xFF3B82F6); // Azul vivo
      case 'Pendente':
        return const Color(0xFFF59E0B); // Laranja vivo
      case 'Concluído':
        return const Color(0xFF10B981); // Verde vivo
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Fundo escuro do app
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // � Título e Subtítulo
              const Text(
                'Meus Projetos',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Lista de projetos cadastrados',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),

              // � Barra de Pesquisa e Filtro
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Buscar por nome de projeto',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF1E293B),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // �️ Lista de Projetos Dinâmica
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
                    : projetos.isEmpty
                        ? const Center(child: Text('Nenhum projeto encontrado.', style: TextStyle(color: Colors.white)))
                        : ListView.builder(
                            itemCount: projetos.length,
                            itemBuilder: (context, index) {
                              final projeto = projetos[index];
                              final statusStr = projeto['status'] ?? 'Pendente';

                              return Card(
                                color: const Color(0xFF1E293B),
                                margin: const EdgeInsets.only(bottom: 10.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              projeto['nome'] ?? 'Sem nome',
                                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              projeto['descricao'] ?? 'Sem descrição',
                                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // � Badge com Cores Condicionais
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getBadgeBgColor(statusStr),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          statusStr,
                                          style: TextStyle(
                                            color: _getBadgeTextColor(statusStr),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      
      // ➕ Botão Flutuante posicionado corretamente no Scaffold
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6366F1),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewProjectScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}