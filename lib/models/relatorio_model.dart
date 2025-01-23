import 'dart:io';
import 'package:apphealthsync/models/perfil_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Relatorio {
  final String id;
  final Perfil perfil;
  final DateTime dataGeracao;
  final String conteudo;

  Relatorio({
    required this.id,
    required this.perfil,
    required this.dataGeracao,
    required this.conteudo,
  });

  /// Gera um relatório textual
  String gerarRelatorioTexto() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('Relatório de Saúde');
    buffer.writeln('Nome: ${perfil.nome}');
    buffer.writeln('Idade: ${perfil.idade}');
    buffer.writeln('Histórico de Saúde:');

    for (var dado in perfil.historicoSaude) {
      buffer.writeln('- ${dado.tipo}: ${dado.valor} (${dado.data.toIso8601String()})');
    }

    return buffer.toString();
  }

  /// Gera um relatório em PDF e salva no dispositivo
  Future<String> gerarRelatorioPDF() async {
    final pdf = pw.Document();

    // Adiciona conteúdo ao PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Relatório de Saúde', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('Nome: ${perfil.nome}', style: pw.TextStyle(fontSize: 16)),
            pw.Text('Idade: ${perfil.idade}', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 16),
            pw.Text('Histórico de Saúde:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: perfil.historicoSaude.map((dado) {
                return pw.Text(
                  '- ${dado.tipo}: ${dado.valor} (${dado.data.toIso8601String()})',
                  style: pw.TextStyle(fontSize: 14),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );

    // Salva o PDF no armazenamento local
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/relatorio_saude_${perfil.id}.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    print('Relatório PDF salvo em: $filePath');

    return filePath; // Retorna o caminho do arquivo
  }
}
