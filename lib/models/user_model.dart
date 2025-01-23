import 'package:apphealthsync/models/perfil_model.dart';

class User {
  final String id;
  final String nome;
  final String email;
  final String senha;
  List<Perfil> perfis;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.perfis = const [],
  });

}