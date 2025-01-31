import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/authservice.dart';
import '../../services/perfilservice.dart';
import '../../models/perfil_model.dart';

class PerfilLoader extends StatelessWidget {
  const PerfilLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Perfil>(
      future: _loadPerfil(context),
      builder: (context, AsyncSnapshot<Perfil> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar perfil: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Se o perfil for carregado com sucesso, retorna um Widget vazio ou o widget desejado
          return Container(); // ou qualquer outro widget de fallback
        } else {
          return const Center(child: Text('Nenhum perfil encontrado'));
        }
      },
    );
  }

  Future<Perfil> _loadPerfil(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final perfilService = PerfilService();
    final userId = authService.userId;

    if (userId != null) {
      // Usando o método correto carregarPerfil
      final perfil = await perfilService.carregarPerfil();
      return perfil; // Retorna o perfil encontrado
    } else {
      throw Exception('Usuário não autenticado');
    }
  }
}
