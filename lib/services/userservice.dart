import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apphealthsync/models/user_model.dart';
import 'package:apphealthsync/models/perfil_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Cria um novo usuário no Firebase
  Future<void> criarUsuario(User user) async {
    try {
      // Cria o usuário na coleção 'users'
      await _firestore.collection('users').doc(user.uid).set({
      });

      // Cria os perfis associados ao usuário
      for (Perfil perfil in user.perfis) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('perfis')
            .doc(perfil.id)
            .set({
          'userId': user.uid,
          'nome': perfil.nome,
          'idade': perfil.idade,
          'genero': perfil.genero,
          'peso': perfil.peso,
          'altura': perfil.altura,
        });
      }
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  /// Busca um usuário pelo ID
  Future<User?> buscarUsuarioPorId(String userId) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(userId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        // Buscando os perfis associados ao usuário
        List<Perfil> perfis = await _buscarPerfis(userId);
        return User(
          uid: docSnapshot.id,
          perfis: perfis,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  /// Atualiza os dados de um usuário
  Future<void> atualizarUsuario(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
      });

      // Atualiza os perfis associados ao usuário
      for (Perfil perfil in user.perfis) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('perfis')
            .doc(perfil.id)
            .update({
          'nome': perfil.nome,
          'idade': perfil.idade,
          'genero': perfil.genero,
          'peso': perfil.peso,
          'altura': perfil.altura,
        });
      }
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  /// Deleta um usuário e seus perfis
  Future<void> deletarUsuario(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      // Deleta perfis do usuário
      final perfisSnapshot = await userRef.collection('perfis').get();
      for (var doc in perfisSnapshot.docs) {
        await doc.reference.delete();
      }

      // Deleta o usuário
      await userRef.delete();
    } catch (e) {
      throw Exception('Erro ao deletar usuário: $e');
    }
  }

  /// Busca os perfis associados a um usuário
  Future<List<Perfil>> _buscarPerfis(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('perfis')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Perfil(
          id: doc.id, // Criar User com id
          nome: data['nome'],
          idade: data['idade'],
          genero: data['genero'],
          peso: data['peso'],
          altura: data['altura'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar perfis: $e');
    }
  }
}
