import 'package:apphealthsync/core/di/medicacaoprovider.dart';
import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:apphealthsync/models/user_model.dart' as user;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicacaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "perfis"; // Nome da coleção no Firestore

  // Função para carregar as medicações do usuário autenticado
  Future<List<Medicacao>> carregarMedicacoes() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Recuperando as medicações do Firestore com base no ID do usuário
      QuerySnapshot snapshot = await _firestore.collection(collectionPath).doc(user.uid).collection('medicacoes').get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Nenhuma medicação encontrada');
      }

      // Retorna a lista de medicações a partir dos dados do Firestore
      return snapshot.docs
          .map((doc) {
        var medicacao = Medicacao.fromJson(doc.data() as Map<String, dynamic>);
        // Calcular o próximo horário de medicação
        medicacao.proximoHorario = calcularProximoHorario(medicacao);
        return medicacao;
      })
          .toList();
    } catch (e) {
      throw Exception("Erro ao carregar as medicações: $e");
    }
  }
  // Função para buscar uma medicação pelo ID
  Future<Medicacao?> buscarMedicacaoPorId(String id) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Recuperando a medicação pelo ID no Firestore
      DocumentSnapshot snapshot = await _firestore.collection(collectionPath).doc(user.uid).collection('medicacoes').doc(id).get();

      if (snapshot.exists) {
        return Medicacao.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Medicação não encontrada');
      }
    } catch (e) {
      throw Exception("Erro ao buscar medicação: $e");
    }
  }
  // Função para adicionar ou atualizar uma medicação no Firestore
  Future<void> adicionarOuAtualizarMedicacao(Medicacao medicacao) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Referência para a coleção de medicações
      DocumentReference medicacaoRef = _firestore.collection(collectionPath).doc(user.uid).collection('medicacoes').doc(medicacao.id);

      // Usando o método set() para adicionar ou atualizar
      await medicacaoRef.set(medicacao.toJson());
      print('Medicação ${medicacao.id} adicionada ou atualizada com sucesso!');
    } catch (e) {
      print('Erro ao adicionar ou atualizar medicação: $e');
      throw Exception("Erro ao adicionar ou atualizar medicação");
    }
  }
  // Função para deletar uma medicação
  Future<void> deletarMedicacao(String id) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Deletando a medicação do Firestore
      await _firestore.collection(collectionPath).doc(user.uid).collection('medicacoes').doc(id).delete();
      print('Medicação deletada com sucesso!');
    } catch (e) {
      print('Erro ao deletar medicação: $e');
      throw Exception("Erro ao deletar medicação");
    }
  }
  // Função para calcular o próximo horário de medicação
  DateTime calcularProximoHorario(Medicacao medicacao) {
    DateTime dataAtual = DateTime.now();
    DateTime proximoHorario = medicacao.horarioInicio;

    // Ajuste até o próximo horário após a data atual
    while (proximoHorario.isBefore(dataAtual)) {
      proximoHorario = proximoHorario.add(Duration(hours: medicacao.intervaloHoras));
    }
    return proximoHorario;
  }

}