import 'package:apphealthsync/models/perfil_model.dart';
import 'package:apphealthsync/services/perfilservice.dart';
import 'package:apphealthsync/ui/widgets/cadastrooptions.dart';
import 'package:apphealthsync/ui/widgets/navigationbar.dart';
import 'package:apphealthsync/ui/widgets/pageswidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/authservice.dart'; // Importando o PagesWidget

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Perfil? _perfil; // Perfil do usuário
  String? _userId; // ID do usuário autenticado
  bool _isLoading = false; // Estado de carregamento do perfil

  @override
  void initState() {
    super.initState();
    _obterUsuarioAutenticado();
  }

  // Obtém o ID do usuário autenticado
  Future<void> _obterUsuarioAutenticado() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.userId; // Pegando o ID do usuário atual do AuthService
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      _carregarPerfil();  // Carrega o perfil após o usuário ser autenticado
    }
  }

  // Verifica e carrega o perfil no Firestore
  Future<void> _carregarPerfil() async {
    if (_userId == null) return; // Garante que o ID do usuário está disponível

    setState(() {
      _isLoading = true;
    });

    try {
      final perfilService = PerfilService();
      final perfil = await perfilService.carregarPerfil();

      setState(() {
        _perfil = perfil;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar perfil: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showCadastroOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const CadastroOptions();
      },
    );
  }

  void _signOut() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HealthSync"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: _signOut,
          ),
        ],
      ),
      body: SafeArea(
        child: PagesWidget(
          medicamentos: [],
          userId: _userId,
          isLoading: _isLoading,
          perfil: _perfil,
          selectedIndex: _selectedIndex,
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        onPlusTapped: () => _showCadastroOptions(context),
      ),
    );
  }
}
