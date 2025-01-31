import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:apphealthsync/ui/pages/edicaomedicacaopage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MedicaoDetailPage extends StatefulWidget {
  final Medicacao medicacao;

  const MedicaoDetailPage({Key? key, required this.medicacao}) : super(key: key);

  @override
  State<MedicaoDetailPage> createState() => _MedicaoDetailPageState();
}

class _MedicaoDetailPageState extends State<MedicaoDetailPage> {
  late Medicacao medicacao;

  @override
  void initState() {
    super.initState();
    medicacao = widget.medicacao;
  }

  // Função para navegar para a página de edição
  void editarMedicacao() async {
    final updatedMedicacao = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarMedicacaoPage(medicacao: medicacao),
      ),
    );

    // Verifica se a medicação foi atualizada
    if (updatedMedicacao != null) {
      setState(() {
        medicacao = updatedMedicacao; // Atualiza a medicação com os dados mais recentes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes de ${medicacao.nome}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text('Descrição: ${medicacao.descricao}'),
                        const SizedBox(height: 10),
                        Text('Dose: ${medicacao.dose} ${medicacao.unidade}'),
                        const SizedBox(height: 10),
                        Text('Intervalo: ${medicacao.intervaloHoras} horas'),
                        const SizedBox(height: 10),
                        Text('Horário de Início: ${medicacao.horarioInicio}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: editarMedicacao, // Chama a função para editar a medicação
                  child: const Text('Editar Medicação'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
