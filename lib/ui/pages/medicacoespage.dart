import 'package:apphealthsync/services/medicacaoservice.dart';
import 'package:apphealthsync/ui/widgets/medicacaodetails.dart';
import 'package:flutter/material.dart';
import 'package:apphealthsync/models/medicacao_model.dart';

class MedicacoesPage extends StatefulWidget {
  const MedicacoesPage({Key? key}) : super(key: key);

  @override
  _MedicacoesPageState createState() => _MedicacoesPageState();
}

class _MedicacoesPageState extends State<MedicacoesPage> {
  late MedicacaoService _medicacaoService;
  List<Medicacao> _medicacoes = [];
  List<Medicacao> _filteredMedicacoes = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _medicacaoService = MedicacaoService();
    _loadMedicacoes();
  }

  Future<void> _loadMedicacoes() async {
    try {
      final medicacoes = await _medicacaoService.carregarMedicacoes();
      setState(() {
        _medicacoes = medicacoes;
        _filteredMedicacoes = medicacoes;
      });
    } catch (e) {
      print('Erro ao carregar medicações: $e');
    }
  }

  void _filterMedicacoes(String query) {
    final filtered = _medicacoes.where((medicacao) {
      final nomeLower = medicacao.nome.toLowerCase();
      final descricaoLower = medicacao.descricao.toLowerCase();
      final queryLower = query.toLowerCase();
      return nomeLower.contains(queryLower) || descricaoLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredMedicacoes = filtered;
    });
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir esta medicação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMedicacao(id);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _deleteMedicacao(String id) async {
    try {
      await _medicacaoService.deletarMedicacao(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicação deletada com sucesso!')),
      );
      _loadMedicacoes(); // Recarregar as medicações após a exclusão
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao deletar medicação!')),
      );
    }
  }

  Widget _buildMedicacaoTile(Medicacao medicacao) {
    return ListTile(
      title: Text(medicacao.nome),
      subtitle: Text(medicacao.descricao),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicaoDetailPage(medicacao: medicacao),
          ),
        );
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _confirmDelete(medicacao.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Medicações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MedicacaoSearchDelegate(_filterMedicacoes),
              );
            },
          ),
        ],
      ),
      body: _medicacoes.isEmpty
          ? const Center(child: Text('Nenhuma medicação encontrada.'))
          : ListView.builder(
        itemCount: _filteredMedicacoes.length,
        itemBuilder: (context, index) {
          final medicacao = _filteredMedicacoes[index];
          return _buildMedicacaoTile(medicacao);
        },
      ),
    );
  }
}

class MedicacaoSearchDelegate extends SearchDelegate {
  final Function(String) onSearch;

  MedicacaoSearchDelegate(this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}
