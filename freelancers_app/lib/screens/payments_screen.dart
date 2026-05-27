import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  List<dynamic> pagamentos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPagamentos(); // � Busca o histórico ao carregar a tela
  }

  Future<void> fetchPagamentos() async {
    final dio = Dio();
    try {
      final response = await dio.get('http://192.168.0.80:8000/pagamentos');
      setState(() {
        pagamentos = List<dynamic>.from(response.data['data']);
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao buscar pagamentos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // � Lógica condicional para o fundo da badge
  Color _getBadgeBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'concluído':
      case 'concluido':
        return const Color(0xFF064E3B).withOpacity(0.4); // Verde suave
      case 'pendente':
        return const Color(0xFF78350F).withOpacity(0.4); // Laranja suave
      default:
        return const Color(0xFF334155);
    }
  }

  // � Lógica condicional para o texto da badge
  Color _getBadgeTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'concluído':
      case 'concluido':
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
      backgroundColor: const Color(0xFF0F172A), // Fundo escuro do layout
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // � Título e Subtítulo
              const Text(
                'Pagamentos',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Histórico de pagamentos do projeto',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // �️ Lista de Pagamentos Dinâmica
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
                    : pagamentos.isEmpty
                        ? const Center(child: Text('Nenhum pagamento registrado.', style: TextStyle(color: Colors.white)))
                        : ListView.builder(
                            itemCount: pagamentos.length,
                            itemBuilder: (context, index) {
                              final pagamento = pagamentos[index];
                              final statusStr = pagamento['status'] ?? 'Pendente';

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
                                            Text(
                                              pagamento['nome'] ?? 'Pagamento sem nome',
                                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              pagamento['descricao'] ?? 'Sem descrição cadastrada.',
                                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // � Badge de Status do Pagamento
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