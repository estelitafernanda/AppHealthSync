import 'package:apphealthsync/ui/pages/cadastromedicacaopage.dart';
import 'package:apphealthsync/ui/pages/cadastrosaudepage.dart';
import 'package:apphealthsync/ui/pages/criarrelatoriopage.dart';
import 'package:apphealthsync/ui/widgets/authchecker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/di/configure_providers.dart';
import 'firebase_options.dart';
import 'core/di/medicacaoprovider.dart'; // Importe o MedicacaoProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConfigureProviders>(
      future: ConfigureProviders.createDependency(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Erro ao inicializar: ${snapshot.error}'),
              ),
            ),
          );
        }

        final data = snapshot.data!;

        return MultiProvider(
          providers: [
            ...data.providers,  // Provedores existentes
            ChangeNotifierProvider(create: (_) => MedicacaoProvider()), // Adiciona o MedicacaoProvider
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HealthSync',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            // Configuração das rotas
            routes: {
              '/': (context) => const AuthChecker(), // Página inicial
              '/cadastraomedicacaopage': (context) => CadastroMedicacaoPage(), // Página de cadastro de medicação
              // Adicione outras rotas conforme necessário
              '/cadastrosintomaspage' : (context) => CadastroSaudePage(),
              '/cadastrorelatorio' : (context) => CriarRelatorioPage(),
            },
          ),
        );
      },
    );
  }
}
