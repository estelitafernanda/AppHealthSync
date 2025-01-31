import 'package:flutter/material.dart';
import 'package:apphealthsync/models/dadosaude_model.dart';
import 'package:intl/intl.dart';

import '../../services/dadosaudeservice.dart';

class CadastroSaudePage extends StatefulWidget {
  final DadoSaude? dadoSaude;

  const CadastroSaudePage({Key? key, this.dadoSaude}) : super(key: key);

  @override
  State<CadastroSaudePage> createState() => _CadastroSaudePageState();
}

class _CadastroSaudePageState extends State<CadastroSaudePage> {
  final _formKey = GlobalKey<FormState>();
  final DadoSaudeService _dadoSaudeService = DadoSaudeService();
  late TextEditingController _sistolicaController;
  late TextEditingController _diastolicaController;
  late TextEditingController _frequenciaCardiacaController;
  late TextEditingController _glicoseController;
  late TextEditingController _observacoesController;
  DateTime? _dataSelecionada;

  @override
  void initState() {
    super.initState();
    _sistolicaController = TextEditingController();
    _diastolicaController = TextEditingController();
    _frequenciaCardiacaController = TextEditingController();
    _glicoseController = TextEditingController();
    _observacoesController =
        TextEditingController(text: widget.dadoSaude?.observacoes ?? '');
    _dataSelecionada = widget.dadoSaude?.data ?? DateTime.now();
  }

  @override
  void dispose() {
    _sistolicaController.dispose();
    _diastolicaController.dispose();
    _frequenciaCardiacaController.dispose();
    _glicoseController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _salvarDadoSaude() async {
    if (_formKey.currentState!.validate()) {
      final novoDado = DadoSaude(
        id: widget.dadoSaude?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        data: _dataSelecionada!,
        tipo: "Pressão Arterial, Frequência Cardíaca e Glicose",
        valor: _glicoseController.text, // Nível de glicose como int
        observacoes:
        'Pressão: ${_sistolicaController.text}/${_diastolicaController.text} mmHg\n'
            'Frequência Cardíaca: ${_frequenciaCardiacaController.text} bpm\n'
            'Glicose: ${_glicoseController.text} mg/dL\n'
            '${_observacoesController.text}',
      );

      try {
        await _dadoSaudeService.adicionarOuAtualizarDadoSaude(novoDado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados de saúde salvos com sucesso!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dados de saúde: $e')),
        );
      }
    }
  }

  Future<void> _selecionarData() async {
    DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dataEscolhida != null) {
      setState(() {
        _dataSelecionada = dataEscolhida;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dadoSaude == null
            ? 'Registrar Dados de Saúde'
            : 'Editar Dados de Saúde'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sistolicaController,
                      decoration: const InputDecoration(labelText: 'Sistólica (mmHg)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira a pressão sistólica';
                        }
                        final sistolica = int.tryParse(value);
                        if (sistolica == null || sistolica < 50 || sistolica > 250) {
                          return 'Valor inválido (50-250)';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _diastolicaController,
                      decoration: const InputDecoration(labelText: 'Diastólica (mmHg)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira a pressão diastólica';
                        }
                        final diastolica = int.tryParse(value);
                        if (diastolica == null || diastolica < 30 || diastolica > 150) {
                          return 'Valor inválido (30-150)';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _frequenciaCardiacaController,
                decoration: const InputDecoration(labelText: 'Frequência Cardíaca (bpm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a frequência cardíaca';
                  }
                  final freq = int.tryParse(value);
                  if (freq == null || freq < 30 || freq > 200) {
                    return 'Valor inválido (30-200)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _glicoseController,
                decoration: const InputDecoration(labelText: 'Glicose (mg/dL)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o nível de glicose';
                  }
                  final glicose = int.tryParse(value);
                  if (glicose == null || glicose < 40 || glicose > 400) {
                    return 'Valor inválido (40-400)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observacoesController,
                decoration: const InputDecoration(labelText: 'Observações'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dataSelecionada == null
                          ? 'Nenhuma data selecionada'
                          : 'Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada!)}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selecionarData,
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _salvarDadoSaude,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
