import 'package:apphealthsync/models/dadosaude_model.dart';
import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:apphealthsync/models/user_model.dart';

class Perfil {
  String id;
  String nome;
  int idade;
  String genero;
  String peso;
  String altura;
  List<Medicacao> medicacoes;
  List<DadoSaude> historicoSaude;

  Perfil({
    required this.id,
    this.nome = '',
    this.idade = 0,
    this.genero = '',
    this.peso = '',
    this.altura = '',
    this.medicacoes = const [],
    this.historicoSaude = const [],
  });

  // Método para criar um Perfil a partir de um Map (json)
  factory Perfil.fromJson(Map<String, dynamic> json) {
    List<Medicacao> medicacoes = [];
    if (json['medicacoes'] != null) {
      medicacoes = List<Medicacao>.from(json['medicacoes'].map((m) => Medicacao.fromJson(m)));
    }

    List<DadoSaude> historicoSaude = [];
    if (json['historicoSaude'] != null) {
      historicoSaude = List<DadoSaude>.from(json['historicoSaude'].map((d) => DadoSaude.fromJson(d)));
    }

    return Perfil(
      id: json['id'],
      nome: json['nome'],
      idade: json['idade'],
      genero: json['genero'],
      peso: json['peso'],
      altura: json['altura'],
      medicacoes: medicacoes,
      historicoSaude: historicoSaude,
    );
  }

  // Método para converter o Perfil para um Map (json) para salvar no Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'genero': genero,
      'peso': peso,
      'altura': altura,
      'medicacoes': medicacoes.map((m) => m.toJson()).toList(),
      'historicoSaude': historicoSaude.map((d) => d.toJson()).toList(),
    };
  }
}
