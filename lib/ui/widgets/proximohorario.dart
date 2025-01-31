import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProximoHorarioPage extends StatefulWidget {
  @override
  _ProximoHorarioPageState createState() => _ProximoHorarioPageState();
}

class _ProximoHorarioPageState extends State<ProximoHorarioPage> {
  List<Medicacao> listaDeMedicacoes = [];

  // Função para buscar os dados do Firebase
  Future<void> _buscarMedicacoes() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc('userId')  // Coloque o ID do usuário correto aqui
          .collection('medicacoes')
          .get();

      setState(() {
        listaDeMedicacoes = snapshot.docs
            .map((doc) => Medicacao.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Erro ao buscar as medicações: $e');
    }
  }

  // Chama a função para buscar os dados ao inicializar
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buscarMedicacoes(); // Chama a função para buscar os dados após o layout estar pronto
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Próximos Horários'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: listaDeMedicacoes.isEmpty
            ? Center(child: CircularProgressIndicator())  // Indicador de carregamento
            : Column(
          children: [
            Expanded(  // Expande a ListView para ocupar o espaço restante
              child: ListView.builder(
                itemCount: listaDeMedicacoes.length,
                itemBuilder: (context, index) {
                  final medicacao = listaDeMedicacoes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(medicacao.nome),
                      subtitle: Text('Próximo horário: ${medicacao.proximoHorario}'),
                      trailing: IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          // Acionar notificação ou outro comportamento
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
