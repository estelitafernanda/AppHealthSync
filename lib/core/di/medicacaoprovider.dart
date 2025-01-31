import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:apphealthsync/services/medicacaoservice.dart';
import 'package:flutter/cupertino.dart';

class MedicacaoProvider extends ChangeNotifier {
  late MedicacaoService _medicacaoService;
  List<Medicacao> _medicamentos = [];

  List<Medicacao> get medicamentos => _medicamentos;

  // Função para carregar os medicamentos do Firestore
  Future<void> carregarMedicamentos() async {
    try {
      _medicamentos = await _medicacaoService.carregarMedicacoes();
      notifyListeners();
    } catch (e) {
      print("Erro ao carregar medicamentos: $e");
    }
  }

  // Função para adicionar medicamento
  Future<void> adicionarMedicamento(Medicacao medicacao) async {
    try {
      await _medicacaoService.adicionarOuAtualizarMedicacao(medicacao);
      _medicamentos.add(medicacao);
      notifyListeners();
    } catch (e) {
      print("Erro ao adicionar medicação: $e");
    }
  }

  // Função para atualizar medicamento
  Future<void> atualizarMedicamento(Medicacao medicacao) async {
    try {
      await _medicacaoService.adicionarOuAtualizarMedicacao(medicacao);
      int index = _medicamentos.indexWhere((m) => m.id == medicacao.id);
      if (index != -1) {
        _medicamentos[index] = medicacao;
        notifyListeners();
      }
    } catch (e) {
      print("Erro ao atualizar medicação: $e");
    }
  }

  // Função para deletar medicamento
  Future<void> deletarMedicamento(String id) async {
    try {
      await _medicacaoService.deletarMedicacao(id);
      _medicamentos.removeWhere((m) => m.id == id);
      notifyListeners();
    } catch (e) {
      print("Erro ao deletar medicação: $e");
    }
  }
}
