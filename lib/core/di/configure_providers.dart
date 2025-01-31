import 'package:apphealthsync/services/authservice.dart';
import 'package:apphealthsync/services/perfilservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../services/databaseservice.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependency(BuildContext context) async {
    // Inicialize os serviços necessários
    final authService = AuthService();
    final database = DatabaseService();
    final perfilService = PerfilService();

    return ConfigureProviders(providers: [
      Provider<DatabaseService>(create: (_) => database), // Usando Provider diretamente
      Provider<AuthService>(create: (_) => authService), // Usando Provider diretamente
      Provider<PerfilService>(create: (_) => perfilService), // Usando Provider diretamente
    ]);
  }
}
