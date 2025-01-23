class DadoSaude{
  final String id;
  final DateTime data;
  final String tipo;
  final String valor;
  final String observacoes;

  DadoSaude({
    required this.id,
    required this.data,
    required this.tipo,
    required this.valor,
    this.observacoes = '',
  });
}