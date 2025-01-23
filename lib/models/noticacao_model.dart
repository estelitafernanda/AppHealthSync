class Notificacao {
  final String id;
  final String titulo;
  final String mensagem;
  final DateTime horario;

  Notificacao({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.horario,
  });

  void enviarNotificacao() {
    // Lógica para disparar uma notificação.
  }
}
