import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<dynamic> avaliacoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews(); // � Busca os depoimentos ao abrir a tela
  }

  Future<void> fetchReviews() async {
    final dio = Dio();
    try {
      final response = await dio.get('http://192.168.0.80:8000/avaliacoes');
      setState(() {
        avaliacoes = List<dynamic>.from(response.data['data']);
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao buscar avaliacoes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // � Cor de fundo da badge de aprovação
  Color _getBadgeBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'aprovado':
        return const Color(0xFF064E3B).withOpacity(0.4); // Verde suave
      case 'pendente':
        return const Color(0xFF78350F).withOpacity(0.4); // Laranja suave
      default:
        return const Color(0xFF334155);
    }
  }

  // � Cor do texto da badge de aprovação
  Color _getBadgeTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'aprovado':
        return const Color(0xFF10B981); // Verde vivo
      case 'pendente':
        return const Color(0xFFF59E0B); // Laranja vivo
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Fundo escuro padrão
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // � Cabeçalho da Tela
              const Text(
                'Avaliações',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Feedbacks e depoimentos dos clientes',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // �️ Lista de Avaliações
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
                    : avaliacoes.isEmpty
                        ? const Center(child: Text('Nenhuma avaliação encontrada.', style: TextStyle(color: Colors.white)))
                        : ListView.builder(
                            itemCount: avaliacoes.length,
                            itemBuilder: (context, index) {
                              final avaliacao = avaliacoes[index];
                              final statusStr = avaliacao['status'] ?? 'Pendente';

                              return Card(
                                color: const Color(0xFF1E293B),
                                margin: const EdgeInsets.only(bottom: 16.0),
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
                                            // � Nome de quem avaliou (Chave do banco)
                                            Text(
                                              avaliacao['nome'] ?? 'Cliente Anônimo',
                                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            // � Depoimento (Chave do banco)
                                            Text(
                                              avaliacao['descricao'] ?? 'Sem comentário.',
                                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // � Badge de Status da Avaliação
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
    );
  }
}