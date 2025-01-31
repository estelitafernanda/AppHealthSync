import 'package:cloud_firestore/cloud_firestore.dart';

class Medicacao {
  final String id;
  final String nome;
  final String descricao;
  final DateTime horarioInicio;
  final int intervaloHoras;
  final String unidade;
  final int dose;
  final bool notificacaoAtivada;

  DateTime proximoHorario; // Para armazenar o próximo horário calculado

  Medicacao({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.horarioInicio,
    required this.intervaloHoras,
    required this.unidade,
    required this.dose,
    this.notificacaoAtivada = true,
  }) : proximoHorario = horarioInicio; // Inicializa o proximoHorario com o horário de início

  // Método para criar uma Medicacao a partir de um Map (json)
  factory Medicacao.fromJson(Map<String, dynamic> json) {
    return Medicacao(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      horarioInicio: DateTime.parse(json['horarioInicio']),
      intervaloHoras: json['intervaloHoras'],
      unidade: json['unidade'],
      dose: json['dose'],
      notificacaoAtivada: json['notificacaoAtivada'] ?? true,
    );
  }

  // Método para converter a Medicacao para um Map (json) para salvar no Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'horarioInicio': horarioInicio.toIso8601String(),
      'intervaloHoras': intervaloHoras,
      'unidade': unidade,
      'dose': dose,
      'notificacaoAtivada': notificacaoAtivada,
    };
  }

  // Função para gerar os próximos horários baseados no horário de início e intervalo
  List<DateTime> gerarHorarioProximos(DateTime dataAtual) {
    List<DateTime> horarios = [];
    DateTime proximoHorario = horarioInicio;

    // Ajustar o primeiro horário até o futuro, se necessário
    while (proximoHorario.isBefore(dataAtual)) {
      proximoHorario = proximoHorario.add(Duration(hours: intervaloHoras));
    }

    // Gerar os próximos 5 horários após o horário atual
    for (int i = 0; i < 5; i++) {
      horarios.add(proximoHorario);
      proximoHorario = proximoHorario.add(Duration(hours: intervaloHoras));
    }

    return horarios;
  }
}
