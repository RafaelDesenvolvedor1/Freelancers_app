import 'package:flutter/material.dart';

class DeveloperDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> freelancer;

  const DeveloperDetailsScreen({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Freelancer', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Garante a seta de voltar branca
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar gigante �
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF1E293B),
              child: Icon(Icons.person, size: 50, color: Color(0xFF6366F1)),
            ),
            const SizedBox(height: 16),

            // Nome do Freelancer �️
            Text(
              freelancer['nome'] ?? 'Sem nome',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Bloco de Informações (Moldura Escura) �
            Container(
              width: double.infinity, // Ocupa a largura disponível
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Cor `#1E293B` igual ao layout
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo de Email �
                  const Text(
                    'Email',
                    style: TextStyle(color: Color(0xFF6366F1), fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    freelancer['email'] ?? 'Não informado',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20), // Espaço entre os blocos

                  // Campo de Telefone �
                  const Text(
                    'Telefone',
                    style: TextStyle(color: Color(0xFF6366F1), fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    freelancer['telefone'] ?? 'Não informado',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}