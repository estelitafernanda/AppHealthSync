import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:apphealthsync/services/medicacaoservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de data/hora
import 'package:firebase_auth/firebase_auth.dart';

class EditarMedicacaoPage extends StatefulWidget {
  final Medicacao medicacao;

  const EditarMedicacaoPage({Key? key, required this.medicacao}) : super(key: key);

  @override
  State<EditarMedicacaoPage> createState() => _EditarMedicacaoPageState();
}

class _EditarMedicacaoPageState extends State<EditarMedicacaoPage> {
  late TextEditingController descricaoController;
  late TextEditingController doseController;
  late TextEditingController intervaloController;
  late TextEditingController horarioInicioController;
  late String unidadeSelecionada;
  DateTime? horarioInicio;

  @override
  void initState() {
    super.initState();
    descricaoController = TextEditingController(text: widget.medicacao.descricao);
    doseController = TextEditingController(text: widget.medicacao.dose.toString());
    intervaloController = TextEditingController(text: widget.medicacao.intervaloHoras.toString());
    horarioInicio = widget.medicacao.horarioInicio;
    horarioInicioController = TextEditingController(text: DateFormat('yyyy-MM-dd HH:mm').format(horarioInicio!));
    unidadeSelecionada = widget.medicacao.unidade;
  }

  @override
  void dispose() {
    descricaoController.dispose();
    doseController.dispose();
    intervaloController.dispose();
    horarioInicioController.dispose();
    super.dispose();
  }

  void salvarAlteracoes() async {
    try {
      if (horarioInicio == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Horário de início é obrigatório")),
        );
        return;
      }

      // Recuperar o UID do usuário autenticado
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não autenticado!")),
        );
        return;
      }

      // Converter o texto para DateTime
      DateTime horarioInicioConvertido = DateFormat('yyyy-MM-dd HH:mm').parse(horarioInicioController.text);

      Medicacao updatedMedicacao = Medicacao(
        id: widget.medicacao.id,
        nome: widget.medicacao.nome,
        descricao: descricaoController.text,
        horarioInicio: horarioInicioConvertido,
        dose: int.parse(doseController.text),
        unidade: unidadeSelecionada,
        intervaloHoras: int.parse(intervaloController.text),
      );

      // Atualizar a medicação no Firestore usando o MedicacaoService
      final medicacaoService = MedicacaoService();
      await medicacaoService.adicionarOuAtualizarMedicacao(updatedMedicacao);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicação atualizada com sucesso!")),
      );

      Navigator.pop(context, updatedMedicacao); // Retorna a medicação atualizada para a página anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar medicação: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar ${widget.medicacao.nome}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: doseController,
              decoration: const InputDecoration(labelText: 'Dose'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: intervaloController,
              decoration: const InputDecoration(labelText: 'Intervalo entre doses (em horas)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: horarioInicioController,
              decoration: const InputDecoration(labelText: 'Horário de Início'),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                // Mostrar um DateTime Picker ao clicar no campo
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: horarioInicio ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(horarioInicio ?? DateTime.now()),
                  );

                  if (pickedTime != null) {
                    DateTime finalDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    setState(() {
                      horarioInicio = finalDate;
                      horarioInicioController.text = DateFormat('yyyy-MM-dd HH:mm').format(finalDate);
                    });
                  }
                }
              },
            ),
            DropdownButton<String>(
              value: unidadeSelecionada,
              onChanged: (String? newValue) {
                setState(() {
                  unidadeSelecionada = newValue!;
                });
              },
              items: <String>['mg', 'g', 'ml', 'UI']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarAlteracoes,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
