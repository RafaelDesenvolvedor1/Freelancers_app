import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// O Widget que representa a tela
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

// O Estado da tela (onde criamos as variáveis e a lógica)
class _DiscoverScreenState extends State<DiscoverScreen> {
  List<dynamic> freelancers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFreelancers();
  }

  Future<void> fetchFreelancers() async {
    final dio = Dio();
    try {
      final response = await dio.get('http://192.168.0.80:8000/freelancers');
      setState(() {
        freelancers = List<dynamic>.from(response.data['data']);
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao buscar freelancers: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinha os textos à esquerda
          children: [
            // --- CABEÇALHO ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Descobrir Freelancers',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ), // Espaço pequeno entre título e subtítulo
                  const Text(
                    'Encontre freelancers cadastrados',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 16,
                  ), // Espaço antes da barra de pesquisa
                  // BARRA DE PESQUISA (TextField)
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ), // Lupa
                      filled: true,
                      fillColor: const Color(
                        0xFF1E293B,
                      ), // Fundo escuro do input
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // Remove a linha ao redor
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- LISTA DE FREELANCERS ---
            // O Expanded garante que a lista use o espaço restante e role corretamente
            isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xff5366f1)),
                    ),
                )
            : Expanded(
              child: ListView.builder(
                itemCount: freelancers.length,
                itemBuilder: (context, index) {
                  final freelancer = freelancers[index] as Map<String, dynamic>;

                  return Card(
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF0F172A),
                        child: Icon(Icons.person, color: Color(0xFF6366F1)),
                      ),
                      title: Text(
                        freelancer['nome'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        '${freelancer['email'] ?? 'Não informado'}\n${freelancer['telefone'] ?? 'Não informado'}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      isThreeLine: true,
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
