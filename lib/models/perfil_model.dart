import 'dadosaude_model.dart';
import 'medicacao_model.dart';

class Perfil{
  final String id;
  final String nome;
  final int idade;
  final String genero;
  final String peso;
  final String altura;
  List<Medicacao> medicacoes;
  List<DadoSaude> historicoSaude;

  Perfil({
    required this.id,
    required this.nome,
    required this.idade,
    required this.genero,
    required this.peso,
    required this.altura,
    this.medicacoes = const [],
    this.historicoSaude = const [],

  });
}