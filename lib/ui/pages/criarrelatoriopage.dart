import 'package:apphealthsync/services/relatorioservice.dart';
import 'package:flutter/material.dart';
import 'package:apphealthsync/models/relatorio_model.dart';
import 'package:provider/provider.dart';

class CriarRelatorioPage extends StatefulWidget {
  const CriarRelatorioPage({Key? key}) : super(key: key);

  @override
  _CriarRelatorioPageState createState() => _CriarRelatorioPageState();
}

class _CriarRelatorioPageState extends State<CriarRelatorioPage> {
  bool isLoading = false;
  late RelatorioService _relatorioService;
  late Relatorio _relatorio;

  @override
  void initState() {
    super.initState();
    _relatorioService = RelatorioService();
  }

  Future<void> _gerarRelatorio() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Criando o relatório e automaticamente salvando no Firestore
      _relatorio = await _relatorioService.criarRelatorio(context);
      // Gerando o PDF ou texto
      final pdfFilePath = await _relatorioService.gerarRelatorioPDF(_relatorio);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Relatório gerado e salvo com sucesso em: $pdfFilePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao gerar o relatório: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Relatório de Saúde'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('Gerando relatório...', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _gerarRelatorio,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Gerar Relatório em PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
