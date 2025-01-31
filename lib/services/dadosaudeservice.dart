import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apphealthsync/models/dadosaude_model.dart';

class DadoSaudeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "perfis"; // Nome da coleção no Firestore

  // Função para carregar os dados de saúde do usuário autenticado
  Future<List<DadoSaude>> carregarDadosSaude() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Recuperando os dados de saúde do Firestore com base no ID do usuário
      QuerySnapshot snapshot = await _firestore
          .collection(collectionPath)
          .doc(user.uid)
          .collection('dadosSaude')
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Nenhum dado de saúde encontrado');
      }

      // Retorna a lista de dados de saúde a partir dos dados do Firestore
      return snapshot.docs
          .map((doc) => DadoSaude.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Erro ao carregar os dados de saúde: $e");
    }
  }

  // Função para buscar um dado de saúde pelo ID
  Future<DadoSaude?> buscarDadoSaudePorId(String id) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Recuperando o dado de saúde pelo ID no Firestore
      DocumentSnapshot snapshot = await _firestore
          .collection(collectionPath)
          .doc(user.uid)
          .collection('dadosSaude')
          .doc(id)
          .get();

      if (snapshot.exists) {
        return DadoSaude.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Dado de saúde não encontrado');
      }
    } catch (e) {
      throw Exception("Erro ao buscar dado de saúde: $e");
    }
  }

  // Função para adicionar ou atualizar um dado de saúde no Firestore
  Future<void> adicionarOuAtualizarDadoSaude(DadoSaude dadoSaude) async {
    try {
      // Autenticação do usuário
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Erro: Usuário não autenticado.');
        throw Exception('Usuário não autenticado');
      }

      // Referência para o documento
      DocumentReference dadoSaudeRef = _firestore
          .collection(collectionPath)
          .doc(user.uid)
          .collection('dadosSaude')
          .doc(dadoSaude.id);

      // Log de validação
      print('Dados a salvar: ${dadoSaude.toJson()}');

      // Salvando os dados
      await dadoSaudeRef.set(dadoSaude.toJson());
      print('Dado de saúde ${dadoSaude.id} adicionado ou atualizado com sucesso!');
    } catch (e) {
      print('Erro ao adicionar ou atualizar dado de saúde: $e');
      throw Exception("Erro ao adicionar ou atualizar dado de saúde: $e");
    }
  }

  // Função para deletar um dado de saúde
  Future<void> deletarDadoSaude(String id) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Deletando o dado de saúde do Firestore
      await _firestore
          .collection(collectionPath)
          .doc(user.uid)
          .collection('dadosSaude')
          .doc(id)
          .delete();
      print('Dado de saúde deletado com sucesso!');
    } catch (e) {
      print('Erro ao deletar dado de saúde: $e');
      throw Exception("Erro ao deletar dado de saúde");
    }
  }
}
