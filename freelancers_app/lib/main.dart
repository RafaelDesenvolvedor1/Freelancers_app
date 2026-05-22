import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:freelancers_app/screens/discover_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF6366F1),
        ),
      ),
      home: DiscoverScreen()
    );
  }
}

class ApiTestWidget extends StatefulWidget {
  const ApiTestWidget({super.key});

  @override
  State<ApiTestWidget> createState() => _ApiTestWidgetState();
}

class _ApiTestWidgetState extends State<ApiTestWidget> {
  String _response = 'Carregando dados da API PHP...';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final dio = Dio();
    try {
      // ATENÇÃO: Como estamos rodando no Linux/Desktop, usamos localhost.
      // Se for testar no emulador Android do Android Studio depois, mude para 10.0.2.2
      final response = await dio.get('http://192.168.0.80:8000');

      setState(() {
        _response = response.data['mensagem'] ?? 'Chave não encontrada';
      });
    } catch (e) {
      setState(() {
        _response = 'Erro ao conectar na API: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        // Se a API Docker responder, vai mostrar "Conectado ao MySQL com sucesso via Docker!"
        child: Text(
          _response,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
