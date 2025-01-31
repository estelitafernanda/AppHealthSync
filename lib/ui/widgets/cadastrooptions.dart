import 'package:flutter/material.dart';

class CadastroOptions extends StatelessWidget {
  const CadastroOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.medication, color: Colors.blue),
            title: const Text('Cadastrar Medicação'),
            onTap: () {
              Navigator.pop(context); // Fecha o modal
              Navigator.pushNamed(context, '/cadastraomedicacaopage'); // Navega para a página de cadastro de medicação
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text('Cadastrar Sintomas'),
            onTap: () {
              Navigator.pop(context); // Fecha o modal
              Navigator.pushNamed(context, '/cadastrosintomaspage'); // Navega para a página de cadastro de sintomas
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_open, color: Colors.amber),
            title: const Text('Cadastrar Relatório'),
            onTap: () {
              Navigator.pop(context); // Fecha o modal
              Navigator.pushNamed(context, '/cadastrorelatorio'); // Corrigido para a rota de cadastro de relatório
            },
          ),
        ],
      ),
    );
  }
}
