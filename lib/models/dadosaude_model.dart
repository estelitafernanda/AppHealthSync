class DadoSaude {
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

  // Factory para criar o objeto a partir de um JSON
  factory DadoSaude.fromJson(Map<String, dynamic> json) {
    return DadoSaude(
      id: json['id'],
      data: DateTime.parse(json['data']),
      tipo: json['tipo'],
      valor: json['valor'],
      observacoes: json['observacoes'] ?? '',
    );
  }

  // Método para converter o objeto em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'tipo': tipo,
      'valor': valor,
      'observacoes': observacoes,
    };
  }
}