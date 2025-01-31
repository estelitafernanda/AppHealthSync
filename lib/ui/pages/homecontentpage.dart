import 'package:apphealthsync/services/medicacaoservice.dart';
import 'package:apphealthsync/ui/pages/dadossaudepage.dart';
import 'package:apphealthsync/ui/pages/medicacoespage.dart';
import 'package:flutter/material.dart';

class HomeContentPage extends StatelessWidget {
  final String userId;

  const HomeContentPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MedicacaoService medicamentosService = MedicacaoService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              ListTile(
                leading: const Icon(Icons.medical_services),
                title: const Text('Ver Medicações'),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MedicacoesPage(),
                    ),
                  );
                  await medicamentosService.carregarMedicacoes();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.health_and_safety),
                title: const Text('Ver Dados de Saúde'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DadosSaudePage(),
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
