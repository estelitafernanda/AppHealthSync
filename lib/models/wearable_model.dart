import 'dadosaude_model.dart';

class Wearable {
  final String id;
  final String nome;
  final String fabricante;
  final List<DadoSaude> dadosSincronizados;

  Wearable({
    required this.id,
    required this.nome,
    required this.fabricante,
    this.dadosSincronizados = const [],
  });

  void sincronizarDados() {
    // Lógica para conectar ao wearable e sincronizar dados.
  }
}