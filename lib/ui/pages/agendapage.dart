import 'package:apphealthsync/services/notificationservice.dart';
import 'package:flutter/material.dart';
import 'package:apphealthsync/models/medicacao_model.dart';

class AgendaPage extends StatelessWidget {
  final List<Medicacao> medicamentos;

  const AgendaPage({Key? key, required this.medicamentos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda de Medicação'),
      ),
      body: ListView.builder(
        itemCount: medicamentos.length,
        itemBuilder: (context, index) {
          final medicacao = medicamentos[index];
          final proximoHorario = DateTime.now().add(Duration(minutes: 1)); // Exemplo de agendamento para 10 minutos depois

          // Agendar a notificação
          NotificationService.scheduleNotification(
            medicacao.id.hashCode, // Usando hashCode para garantir um id int único
            'Lembrete de Medicação', // Título
            'É hora de tomar ${medicacao.nome}!', // Corpo da notificação
            proximoHorario, // Horário agendado
          );

          return ListTile(
            title: Text(medicacao.nome),
            subtitle: Text('Próxima dose: ${proximoHorario.toString()}'),
          );
        },
      ),
    );
  }
}
