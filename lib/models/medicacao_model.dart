class Medicacao{
  final String id;
  final String nome;
  final String descricao;
  final DateTime horarioInicio;
  final int intervaloHoras;
  final String unidade;
  final int dose;
  final bool notificacaoAtivada;

  Medicacao({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.horarioInicio,
    required this.intervaloHoras,
    required this.unidade,
    required this.dose,
    this.notificacaoAtivada = true,
  });

  List<DateTime> gerarHorarioProximos(DateTime dataAtual){
    List<DateTime> horarios = [];
    DateTime proximoHorario = horarioInicio;

    while (proximoHorario.isBefore(dataAtual)) {
      proximoHorario = proximoHorario.add(Duration(hours: intervaloHoras));
    }

    for (int i = 0; i < 5; i++) {
      horarios.add(proximoHorario);
      proximoHorario = proximoHorario.add(Duration(hours: intervaloHoras));
    }

    return horarios;
  }

}