import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import necessário para Firestore
import 'package:apphealthsync/models/perfil_model.dart';
import 'package:apphealthsync/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instância do Firestore

  // Getter para obter o ID do usuário autenticado
  String? get userId {
    final user = _firebaseAuth.currentUser;
    return user?.uid; // Retorna o UID do usuário autenticado
  }

  // Método para obter o email do usuário atual, com verificação de autenticação
  String? getCurrentUserEmail() {
    final user = _firebaseAuth.currentUser;
    return user?.email; // Retorna o email ou null se o usuário não estiver autenticado
  }

  // Método para autenticação com email e senha
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Método para registro de novo usuário com email e senha
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Após criar o usuário, vamos criar o perfil no Firestore
      await criarPerfil(credential.user!);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Função para criar o perfil após o cadastro do usuário
  Future<void> criarPerfil(user) async {
    try {
      final perfilRef = _firestore.collection('perfis').doc(user.uid);  // Usando UID do usuário como docId

      // Criar um perfil vazio ou com dados padrão
      Perfil perfil = Perfil(
        id: user.uid,
        nome: '', // Inicialize conforme necessário
        idade: 0, // Inicialize conforme necessário
        genero: '', // Inicialize conforme necessário
        peso: '', // Inicialize conforme necessário
        altura: '', // Inicialize conforme necessário
        medicacoes: [], // Inicialize conforme necessário
        historicoSaude: [], // Inicialize conforme necessário
      );

      // Salva o perfil no Firestore
      await perfilRef.set(perfil.toJson());

      print("Perfil criado com sucesso no Firestore!");
    } catch (e) {
      print('Erro ao criar perfil: $e');
    }
  }

  // Método para resetar a senha do usuário
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Método para logout
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Método para autenticação anônima
  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
