import 'package:apphealthsync/models/dadosaude_model.dart';
import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:apphealthsync/models/perfil_model.dart';
import 'package:apphealthsync/models/relatorio_model.dart';
import 'package:apphealthsync/models/user_model.dart' as user;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RelatorioService {
  // Método para criar um relatório e retornar um objeto Relatório
  Future<Relatorio> criarRelatorio(BuildContext context) async {
    // Obtendo o usuário atual do Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuário não autenticado');
      throw Exception("Usuário não autenticado");
    }

    final uid = user.uid;
    print('Usuário autenticado: $uid'); // Verificando o uid do usuário

    // Aqui você pode pegar o perfil do Firebase ou do PerfilProvider
    final perfil = await _buscarPerfilDoFirebase(uid);

    // Buscando medicações e dados de saúde
    final medicacoes = await _buscarMedicacoes(uid);
    final dadosSaude = await _buscarDadosSaude(uid);

    final DateTime dataGeracao = DateTime.now();
    print('Data de Geração: $dataGeracao'); // Verificando a data de geração

    final String conteudo = _gerarConteudoRelatorio(perfil, medicacoes, dadosSaude);

    final relatorio = Relatorio(
      id: '${uid}-${dataGeracao.toIso8601String()}', // Prefixando o ID com o UID
      perfil: perfil,
      dataGeracao: dataGeracao,
      conteudo: conteudo,
    );

    print('Relatório criado com ID: ${relatorio.id}'); // Verificando o ID do relatório

    // Agora salva o relatório no Firestore
    await _salvarRelatorioNoFirestore(relatorio);

    return relatorio;
  }

  // Método para buscar o perfil no Firebase usando o uid do usuário
  Future<Perfil> _buscarPerfilDoFirebase(String uid) async {
    try {
      final perfilDoc = await FirebaseFirestore.instance.collection('perfis').doc(uid).get();
      if (perfilDoc.exists) {
        return Perfil.fromJson(perfilDoc.data()!);
      } else {
        print('Perfil não encontrado para o usuário: $uid');
        throw Exception("Perfil não encontrado para o usuário.");
      }
    } catch (e) {
      print('Erro ao buscar perfil: $e');
      throw Exception("Erro ao buscar perfil do Firebase: $e");
    }
  }

  // Método para buscar as medicações do usuário no Firebase
  Future<List<Medicacao>> _buscarMedicacoes(String uid) async {
    try {
      final medicacoesSnapshot = await FirebaseFirestore.instance
          .collection('perfis')
          .doc(uid)
          .collection('medicacoes')
          .get();

      return medicacoesSnapshot.docs
          .map((doc) => Medicacao.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Erro ao buscar medicações: $e');
      throw Exception("Erro ao buscar medicações do Firebase: $e");
    }
  }

  // Método para buscar os dados de saúde do usuário no Firebase
  Future<List<DadoSaude>> _buscarDadosSaude(String uid) async {
    try {
      final dadosSaudeSnapshot = await FirebaseFirestore.instance
          .collection('perfis')
          .doc(uid)
          .collection('dadosSaude')
          .get();

      return dadosSaudeSnapshot.docs
          .map((doc) => DadoSaude.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Erro ao buscar dados de saúde: $e');
      throw Exception("Erro ao buscar dados de saúde do Firebase: $e");
    }
  }

  // Método para salvar o relatório no Firestore
  Future<void> _salvarRelatorioNoFirestore(Relatorio relatorio) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Usuário não autenticado');
        throw Exception("Usuário não autenticado");
      }

      // Referência para a subcoleção 'relatorios' dentro do perfil do usuário
      await FirebaseFirestore.instance
          .collection('perfis') // Pegando o perfil do usuário
          .doc(user.uid) // Usando o UID do usuário
          .collection('relatorios') // Criando/pegando a subcoleção 'relatorios'
          .doc(relatorio.id) // ID único para o relatório
          .set(relatorio.toJson()); // Salvando os dados

      print('Relatório salvo no Firestore dentro do perfil do usuário');
    } catch (e) {
      print('Erro ao salvar o relatório no Firestore: $e');
      throw Exception("Erro ao salvar o relatório no Firestore: $e");
    }
  }

  // Método privado para gerar o conteúdo textual do relatório
  String _gerarConteudoRelatorio(Perfil perfil, List<Medicacao> medicacoes, List<DadoSaude> dadosSaude) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('Relatório de Saúde');
    buffer.writeln('Nome: ${perfil.nome}');
    buffer.writeln('Idade: ${perfil.idade}');
    buffer.writeln('Histórico de Saúde:');

    // Adicionando dados de saúde ao relatório
    for (var dado in dadosSaude) {
      buffer.writeln('- ${dado.tipo}: ${dado.valor} (${dado.data.toIso8601String()})');
    }

    buffer.writeln('Medicações:');
    // Adicionando medicações ao relatório
    for (var medicacao in medicacoes) {
      buffer.writeln('- ${medicacao.nome} (Início: ${medicacao.horarioInicio.toIso8601String()}, Intervalo: ${medicacao.intervaloHoras}h)');
    }

    return buffer.toString();
  }

  // Método para gerar o relatório em PDF e salvar no dispositivo
  Future<String> gerarRelatorioPDF(Relatorio relatorio) async {
    final pdfFilePath = await relatorio.gerarRelatorioPDF();
    return pdfFilePath;
  }

  // Método para gerar um relatório textual
  String gerarRelatorioTexto(Relatorio relatorio) {
    return relatorio.gerarRelatorioTexto();
  }
}
