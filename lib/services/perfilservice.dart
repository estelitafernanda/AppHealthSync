import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apphealthsync/models/perfil_model.dart';

class PerfilService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "perfis"; // Nome da coleção no Firestore

  // Função para carregar o perfil do Firebase do usuário autenticado
  Future<Perfil> carregarPerfil() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Recuperando o perfil do Firestore com base no ID do usuário
      DocumentSnapshot snapshot = await _firestore.collection(collectionPath).doc(user.uid).get();

      if (!snapshot.exists) {
        throw Exception('Perfil não encontrado');
      }

      // Retorna o perfil a partir dos dados do Firestore
      return Perfil.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Erro ao carregar o perfil: $e");
    }
  }

  // Função para buscar o perfil de um usuário pelo ID
  Future<Perfil?> buscarPerfilPorId(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection(collectionPath).doc(userId).get();
      if (snapshot.exists) {
        return Perfil.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Perfil não encontrado');
      }
    } catch (e) {
      throw Exception("Erro ao buscar perfil: $e");
    }
  }

  // Função para atualizar o perfil no Firestore
  Future<void> atualizarPerfil(Perfil perfil) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Atualizando o perfil no Firestore
      await _firestore.collection(collectionPath).doc(user.uid).update(perfil.toJson());
      print('Perfil atualizado com sucesso!');
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  // Função para salvar o perfil no Firestore
  Future<void> salvarPerfilFirestore(Perfil perfil) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Referência para o documento do perfil
      DocumentReference perfilRef = _firestore.collection(collectionPath).doc(user.uid);

      // Salvando ou criando o perfil no Firestore
      await perfilRef.set(perfil.toJson());
      print("Perfil salvo com sucesso no Firestore!");
    } catch (e) {
      print('Erro ao salvar perfil no Firestore: $e');
      throw Exception("Erro ao salvar perfil");
    }
  }
}
