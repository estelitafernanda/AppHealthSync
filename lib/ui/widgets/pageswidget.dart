import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:apphealthsync/models/perfil_model.dart';
import 'package:apphealthsync/models/relatorio_model.dart';
import 'package:apphealthsync/ui/pages/agendapage.dart';
import 'package:apphealthsync/ui/pages/homecontentpage.dart';
import 'package:apphealthsync/ui/pages/perfilpage.dart';
import 'package:apphealthsync/ui/pages/relatoriopage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PagesWidget extends StatefulWidget {
  final String? userId;
  final bool isLoading;
  final Perfil? perfil;
  final int selectedIndex;
  final List<Medicacao> medicamentos;
  final Relatorio? relatorio;

  const PagesWidget({
    Key? key,
    required this.userId,
    required this.isLoading,
    required this.perfil,
    required this.selectedIndex,
    required this.medicamentos,
    this.relatorio,
  }) : super(key: key);

  @override
  _PagesWidgetState createState() => _PagesWidgetState();
}

class _PagesWidgetState extends State<PagesWidget> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.selectedIndex,
      children: [
        if (widget.userId != null)
          HomeContentPage(userId: widget.userId!),
        if (widget.relatorio != null)
          RelatorioPage(relatorioId: widget.relatorio!.id),
        if (widget.relatorio == null)
          const Center(child: Text('Relatório não disponível')),
        const Center(child: Text('Placeholder Cadastrar')),
        AgendaPage(medicamentos: widget.medicamentos),
        if (widget.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (widget.perfil != null)
          PerfilPage(id: widget.userId!)
        else
          const Center(child: Text('Erro ao carregar o perfil. Tente novamente!')),
      ],
    );
  }
}
