import 'package:apphealthsync/services/authservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> provider;

  ConfigureProviders({required this.provider});

  static Future<ConfigureProviders> createDependency(BuildContext context) async {
    final authService = AuthService();


    return ConfigureProviders(provider: [
      Provider<AuthService>.value(value: authService),
    ]);
  }
}