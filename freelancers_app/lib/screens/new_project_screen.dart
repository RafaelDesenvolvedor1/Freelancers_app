import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // � Estados para os Dropdowns
  List<dynamic> freelancers = [];
  String? statusSelecionado = 'Pendente';
  int? freelancerSelecionadoId;
  bool isLoadingFreelancers = true;

  @override
  void initState() {
    super.initState();
    fetchFreelancers(); // � Busca os profissionais cadastrados ao abrir a tela
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> fetchFreelancers() async {
    final dio = Dio();
    try {
      final response = await dio.get('http://192.168.0.80:8000/freelancers');
      setState(() {
        freelancers = List<dynamic>.from(response.data['data']);
        isLoadingFreelancers = false;
      });
    } catch (e) {
      print('Erro ao buscar freelancers: $e');
      setState(() {
        isLoadingFreelancers = false;
      });
    }
  }

  Future<void> salvarProjeto() async {
    if (!_formKey.currentState!.validate()) return;

    final dio = Dio();
    try {
      // �️ Montagem do Map com os dados do formulário
      final dadosProjeto = {
        'nome': _nameController.text,
        'descricao': _descriptionController.text,
        'status': statusSelecionado,
        'id_cliente': 1, // � Cliente padrão fixado para testes locais
        'id_freelancer': freelancerSelecionadoId,
      };

      await dio.post('http://192.168.0.80:8000/projetos', data: dadosProjeto);

      // � Notificação de sucesso e retorno para a tela anterior
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Projeto criado com sucesso!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); 
    } catch (e) {
      print('Erro ao salvar projeto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar projeto.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Novo Projeto', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoadingFreelancers
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Preencha as informações do projeto', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 24),

                      // � Campo Nome
                      const Text('Nome', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Digite o nome do projeto',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFF1E293B),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Por favor, insira um nome' : null,
                      ),
                      const SizedBox(height: 16),

                      // � Campo Descrição
                      const Text('Descrição', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5, // � Deixa o campo maior para textos longos
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Descreva o projeto...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFF1E293B),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // � Select de Status
                      const Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: statusSelecionado,
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1E293B),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        ),
                        items: ['Pendente', 'Em andamento', 'Concluído'].map((String status) {
                          return DropdownMenuItem<String>(value: status, child: Text(status));
                        }).toList(),
                        onChanged: (value) => setState(() => statusSelecionado = value), // � Captura a mudança
                      ),
                      const SizedBox(height: 16),

                      // � Select de Freelancer
                      const Text('Selecionar Freelancer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: freelancerSelecionadoId,
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        hint: const Text('Escolha um profissional', style: TextStyle(color: Colors.grey)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1E293B),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        ),
                        items: freelancers.map<DropdownMenuItem<int>>((dynamic free) {
                          return DropdownMenuItem<int>(
                            value: free['id_freelancer'] as int,
                            child: Text(free['nome'] ?? 'Sem nome'),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => freelancerSelecionadoId = value), // � Captura a mudança
                        validator: (value) => value == null ? 'Por favor, selecione um freelancer' : null,
                      ),
                      const SizedBox(height: 32),

                      // � Botão Salvar Projeto
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: salvarProjeto,
                          child: const Text('Salvar Projeto', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}