import 'package:apphealthsync/ui/pages/EditDadoPage.dart';
import 'package:flutter/material.dart';
import 'package:apphealthsync/models/dadosaude_model.dart';
import 'package:apphealthsync/services/dadosaudeservice.dart';

class DadosSaudePage extends StatefulWidget {
  @override
  _DadosSaudePageState createState() => _DadosSaudePageState();
}

class _DadosSaudePageState extends State<DadosSaudePage> {
  final DadoSaudeService _dadoSaudeService = DadoSaudeService();
  late Future<List<DadoSaude>> _dadosSaude;

  @override
  void initState() {
    super.initState();
    _dadosSaude = _dadoSaudeService.carregarDadosSaude();
  }

  // Função para deletar um dado de saúde
  void _deletarDado(DadoSaude dado) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Deleção'),
          content: Text('Você tem certeza que deseja deletar o dado de saúde "${dado.tipo}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _dadoSaudeService.deletarDadoSaude(dado.id); // Passando o ID do dado
        setState(() {
          _dadosSaude = _dadoSaudeService.carregarDadosSaude(); // Recarrega os dados
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dado de saúde deletado com sucesso')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar dado: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados de Saúde'),
      ),
      body: FutureBuilder<List<DadoSaude>>(
        future: _dadosSaude,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum dado de saúde encontrado.'));
          } else {
            List<DadoSaude> dados = snapshot.data!;
            return ListView.builder(
              itemCount: dados.length,
              itemBuilder: (context, index) {
                DadoSaude dado = dados[index];
                return Card(
                  margin: const EdgeInsets.all(16.0), // Aumentando a margem externa
                  elevation: 4.0, // Adicionando uma sombra para destacar o card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Adicionando bordas arredondadas
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Aumentando o padding interno
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dado.tipo,
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis, // Garante que o texto não ultrapasse os limites
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                dado.observacoes.isEmpty
                                    ? 'Sem observações'
                                    : dado.observacoes,
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '${dado.data.day}/${dado.data.month}/${dado.data.year}',
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Navegar para a página de edição
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditDadoPage(dado: dado)));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deletarDado(dado); // Chama a função de deletar
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
