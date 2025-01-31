import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:apphealthsync/services/medicacaoservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de data/hora
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroMedicacaoPage extends StatefulWidget {
  const CadastroMedicacaoPage({Key? key}) : super(key: key);

  @override
  _CadastroMedicacaoPageState createState() => _CadastroMedicacaoPageState();
}

class _CadastroMedicacaoPageState extends State<CadastroMedicacaoPage> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _horarioController = TextEditingController();
  final _intervaloController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _doseController = TextEditingController();

  DateTime? horarioInicio;

  // Função para salvar a medicação
  void salvarMedicacao() async {
    final nome = _nomeController.text.trim();
    final descricao = _descricaoController.text.trim();
    final intervaloHoras = int.tryParse(_intervaloController.text.trim());
    final unidade = _unidadeController.text.trim();
    final dose = int.tryParse(_doseController.text.trim());

    if (nome.isEmpty || descricao.isEmpty || horarioInicio == null || intervaloHoras == null || unidade.isEmpty || dose == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
        ),
      );
      return;
    }

    // Recuperar o UID do usuário autenticado
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não autenticado!'),
        ),
      );
      return;
    }

    // Criação do objeto Medicacao
    final medicacao = Medicacao(
      id: FirebaseFirestore.instance.collection("medicacoes").doc().id, // Gerando um ID único temporário
      nome: nome,
      descricao: descricao,
      horarioInicio: horarioInicio!, // Usando a data selecionada
      intervaloHoras: intervaloHoras,
      unidade: unidade,
      dose: dose, // Inicializando o proximoHorario com o mesmo valor de horarioInicio
    );

    // Criando o MedicacaoService com o uid do usuário
    final medicacaoService = MedicacaoService();
    await medicacaoService.adicionarOuAtualizarMedicacao(medicacao);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medicação cadastrada com sucesso!'),
      ),
    );

    // Limpar os campos após o cadastro
    _nomeController.clear();
    _descricaoController.clear();
    _intervaloController.clear();
    _unidadeController.clear();
    _doseController.clear();
    setState(() {
      horarioInicio = null;
      _horarioController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Medicação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome da Medicação',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _horarioController,
              decoration: const InputDecoration(
                labelText: 'Horário de Início (yyyy-MM-dd HH:mm)',
              ),
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
                    initialTime: TimeOfDay.fromDateTime(pickedDate),
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
                      _horarioController.text = DateFormat('yyyy-MM-dd HH:mm').format(finalDate);
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _intervaloController,
              decoration: const InputDecoration(
                labelText: 'Intervalo entre Doses (em horas)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _unidadeController,
              decoration: const InputDecoration(
                labelText: 'Unidade de Medicação',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _doseController,
              decoration: const InputDecoration(
                labelText: 'Dose',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarMedicacao,
              child: const Text('Salvar Medicação'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
