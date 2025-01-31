import 'package:flutter/material.dart';
import 'package:apphealthsync/models/dadosaude_model.dart';
import 'package:apphealthsync/services/dadosaudeservice.dart';

class EditDadoPage extends StatefulWidget {
  final DadoSaude dado;

  const EditDadoPage({Key? key, required this.dado}) : super(key: key);

  @override
  _EditDadoPageState createState() => _EditDadoPageState();
}

class _EditDadoPageState extends State<EditDadoPage> {
  final _formKey = GlobalKey<FormState>();
  late String _tipo;
  late String _valor;
  late DateTime _data;

  @override
  void initState() {
    super.initState();
    _tipo = widget.dado.tipo;
    _valor = widget.dado.valor.toString();
    _data = widget.dado.data;
  }

  // Função para atualizar os dados de saúde
  Future<void> _atualizarDado() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      DadoSaude dadoAtualizado = DadoSaude(
        id: widget.dado.id,
        tipo: _tipo,
        valor: _valor,
        data: _data,
      );

      try {
        final dadoSaudeService = DadoSaudeService();
        await dadoSaudeService.adicionarOuAtualizarDadoSaude(dadoAtualizado);
        Navigator.pop(context); // Voltar para a página anterior

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dado de saúde atualizado com sucesso')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar dado de saúde: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Dado de Saúde'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _tipo,
                decoration: const InputDecoration(labelText: 'Tipo do Dado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o tipo do dado';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tipo = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _valor,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Informe um valor válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _valor = value!;
                },
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  DateTime? newData = await showDatePicker(
                    context: context,
                    initialDate: _data,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (newData != null && newData != _data) {
                    setState(() {
                      _data = newData;
                    });
                  }
                },
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    hintText: '${_data.day}/${_data.month}/${_data.year}',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a data';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _atualizarDado,
                  child: const Text('Salvar Alterações'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
