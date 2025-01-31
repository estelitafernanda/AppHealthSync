import 'package:apphealthsync/models/perfil_model.dart';

class User {
  final String uid;
  List<Perfil> perfis;

  User({
    required this.uid,
    this.perfis = const [],
  });

}