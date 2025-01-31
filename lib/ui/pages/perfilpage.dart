import 'package:flutter/material.dart';
import 'package:apphealthsync/models/perfil_model.dart';
import 'package:apphealthsync/services/perfilservice.dart';
import '../widgets/perfilloader.dart';

class PerfilPage extends StatefulWidget {
  final String id;

  const PerfilPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _formKey = GlobalKey<FormState>();
  bool isFamiliaMode = false;
  late String _peso;
  late String _altura;
  late String _genero;
  late int _idade;
  late String _nome;
  late Perfil _perfil;
  bool _isLoading = true;
  final List<Perfil> familiares = [];

  @override
  void initState() {
    super.initState();
    _peso = '';
    _altura = '';
    _genero = 'Outro';
    _idade = 0;
    _nome = '';
    _perfil = Perfil(id: widget.id);
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final perfilService = PerfilService();
      Perfil perfil = await perfilService.carregarPerfil();
      setState(() {
        _perfil = perfil;
        _peso = perfil.peso;
        _altura = perfil.altura;
        _genero = perfil.genero.isNotEmpty ? perfil.genero : 'Outro';
        _idade = perfil.idade;
        _nome = perfil.nome.isNotEmpty ? perfil.nome : '';
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

  Future<void> _atualizarPerfil() async {
    try {
      final perfilService = PerfilService();
      _perfil.peso = _peso;
      _perfil.altura = _altura;
      _perfil.genero = _genero;
      _perfil.idade = _idade;
      _perfil.nome = _nome;

      await perfilService.atualizarPerfil(_perfil);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );

      if (isFamiliaMode) {
        // Salvar os perfis dos familiares
        for (var familiar in familiares) {
          await perfilService.atualizarPerfil(familiar);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfis familiares atualizados!')),
        );
      }

      // Recarregar os dados atualizados
      _carregarPerfil();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o perfil: $e')),
      );
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _atualizarPerfil();
    }
  }

  // Função para adicionar um perfil de familiar
  void _adicionarFamiliar() {
    setState(() {
      familiares.add(Perfil(
        id: DateTime.now().toString(), // ID único para o familiar
        nome: 'Nome Familiar', // Dados de exemplo
        idade: 30,
        peso: '70',
        altura: '170',
        genero: 'Outro',
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: _nome,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o nome';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nome = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: _peso,
                      decoration: const InputDecoration(labelText: 'Peso (kg)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o peso';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _peso = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: _altura,
                      decoration: const InputDecoration(labelText: 'Altura (cm)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a altura';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _altura = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _genero,
                      decoration: const InputDecoration(labelText: 'Gênero'),
                      items: ['Masculino', 'Feminino', 'Outro']
                          .map(
                            (genero) => DropdownMenuItem(
                          value: genero,
                          child: Text(genero),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _genero = value!;
                        });
                      },
                      onSaved: (value) {
                        _genero = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: _idade.toString(),
                      decoration: const InputDecoration(labelText: 'Idade'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a idade';
                        }
                        if (int.tryParse(value) == null) {
                          return 'A idade deve ser um número';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _idade = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      title: const Text('Modo Família'),
                      value: isFamiliaMode,
                      onChanged: (value) {
                        setState(() {
                          isFamiliaMode = value;
                        });
                      },
                    ),
                    if (isFamiliaMode)
                      Column(
                        children: [
                          // Exemplo de perfis da família - você pode carregar os dados dinamicamente
                          ListTile(
                            title: Text('Nome do Familiar'),
                            subtitle: Text('Idade: 30'),
                          ),
                          ListTile(
                            title: Text('Nome do Familiar 2'),
                            subtitle: Text('Idade: 25'),
                          ),
                          ElevatedButton(
                            onPressed: _adicionarFamiliar,
                            child: const Text('Adicionar Familiar'),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveForm,
                        child: const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}