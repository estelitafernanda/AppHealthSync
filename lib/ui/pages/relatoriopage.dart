import 'package:apphealthsync/services/relatorioservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:apphealthsync/models/relatorio_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RelatorioPage extends StatefulWidget {
  final String relatorioId;

  const RelatorioPage({Key? key, required this.relatorioId}) : super(key: key);

  @override
  _RelatorioPageState createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  bool isLoading = true;
  Relatorio? relatorio;

  @override
  void initState() {
    super.initState();
    _loadRelatorio();
  }

  Future<void> _loadRelatorio() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuário não autenticado");
      }

      String uid = user.uid;

      // Buscando o relatório na subcoleção 'relatorios' do perfil do usuário
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('perfis') // Coleção 'perfis'
          .doc(uid) // Documento com o UID do usuário
          .collection('relatorios') // Subcoleção 'relatorios'
          .doc(widget.relatorioId) // ID do relatório
          .get();

      if (doc.exists) {
        setState(() {
          relatorio = Relatorio.fromJson(doc.data() as Map<String, dynamic>);
          isLoading = false;
        });
      } else {
        throw Exception("Relatório não encontrado.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar o relatório: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (relatorio == null) {
      return const Center(child: Text('Relatório não encontrado.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Saúde'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${relatorio!.perfil.nome}',
                style: Theme.of(context).textTheme.bodyMedium),
            Text('Idade: ${relatorio!.perfil.idade}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text('Histórico de Saúde:',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            // Aqui, você mapeia os dados de saúde se existir na estrutura do perfil
            ...relatorio!.perfil.historicoSaude?.map(
                  (dado) => Text(
                '- ${dado.tipo}: ${dado.valor} (${dado.data.toIso8601String()})',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ) ?? [const Text('Sem dados de saúde disponíveis.')],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                final relatorioService = RelatorioService();
                try {
                  String pdfPath = await relatorioService.gerarRelatorioPDF(relatorio!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDF gerado: $pdfPath')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao gerar PDF: $e')),
                  );
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Baixar Relatório em PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
