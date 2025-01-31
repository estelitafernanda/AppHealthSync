import 'package:apphealthsync/models/perfil_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  factory Relatorio.fromJson(Map<String, dynamic> json) {
    return Relatorio(
      id: json['id'] as String,
      perfil: Perfil.fromJson(json['perfil'] as Map<String, dynamic>),
      dataGeracao: DateTime.parse(json['dataGeracao'] as String),
      conteudo: json['conteudo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'perfil': perfil.toJson(),
      'dataGeracao': dataGeracao.toIso8601String(),
      'conteudo': conteudo,
    };
  }

  // Método para gerar o relatório em PDF
  Future<String> gerarRelatorioPDF() async {
    final pdf = pw.Document();

    // Adicionando conteúdo ao PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Relatório de Saúde', style: pw.TextStyle(fontSize: 24)),
              pw.Text('Nome: ${perfil.nome}', style: pw.TextStyle(fontSize: 18)),
              pw.Text('Idade: ${perfil.idade}', style: pw.TextStyle(fontSize: 18)),
              pw.Text('Data de Geração: ${dataGeracao.toIso8601String()}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 16),
              pw.Text('Conteúdo:', style: pw.TextStyle(fontSize: 18)),
              pw.Text(conteudo, style: pw.TextStyle(fontSize: 14)),
            ],
          );
        },
      ),
    );

    // Salvando o PDF
    final output = await getExternalStorageDirectory();
    final filePath = '${output!.path}/relatorio_${id}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  String gerarRelatorioTexto() {
    StringBuffer buffer = StringBuffer();

    // Cabeçalho
    buffer.writeln('Relatório de Saúde');
    buffer.writeln('ID do Relatório: $id');
    buffer.writeln('Data de Geração: ${dataGeracao.toIso8601String()}');
    buffer.writeln('--------------------------------------------------');

    // Informações do perfil
    buffer.writeln('Nome: ${perfil.nome}');
    buffer.writeln('Idade: ${perfil.idade}');
    buffer.writeln('--------------------------------------------------');
    buffer.writeln(conteudo);

    return buffer.toString();
  }
}
