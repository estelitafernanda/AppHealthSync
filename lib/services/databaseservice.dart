import 'package:apphealthsync/models/dadosaude_model.dart';
import 'package:apphealthsync/models/medicacao_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:apphealthsync/models/perfil_model.dart';


class DatabaseService {
  final DatabaseReference _firebaseDatabase = FirebaseDatabase.instance.ref();

  DatabaseReference get databaseReference => _firebaseDatabase;

  // Salvar o perfil no Firebase
  Future<void> salvarPerfil(Perfil perfil) async {
    try {
      final perfilRef = _firebaseDatabase.child('users/${perfil.id}/perfil');

      await perfilRef.set({
        'nome': perfil.nome,
        'idade': perfil.idade,
        'genero': perfil.genero,
        'peso': perfil.peso,
        'altura': perfil.altura,
        'medicacoes': perfil.medicacoes.map((m) => {
          'id': m.id,
          'nome': m.nome,
          'descricao': m.descricao,
          'horarioInicio': m.horarioInicio.toIso8601String(),
          'intervaloHoras': m.intervaloHoras,
          'unidade': m.unidade,
          'dose': m.dose,
          'notificacaoAtivada': m.notificacaoAtivada,
        }).toList(),
        'historicoSaude': perfil.historicoSaude.map((d) => {
          'id': d.id,
          'data': d.data.toIso8601String(),
          'tipo': d.tipo,
          'valor': d.valor,
          'observacoes': d.observacoes,
        }).toList(),
      });

      print("Perfil salvo com sucesso!");
    } catch (e) {
      print('Erro ao salvar perfil: $e');
    }
  }

  // Buscar um perfil específico
  // Buscar um perfil específico
  Future<Perfil?> getPerfil(String userId) async {
    try {
      final snapshot = await _firebaseDatabase.child('users/$userId/perfil').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        // Garantir que os campos estejam presentes e no formato esperado
        List<Medicacao> medicacoes = [];
        if (data['medicacoes'] != null) {
          medicacoes = List<Medicacao>.from(data['medicacoes'].map((m) => Medicacao(
            id: m['id'] ?? '',
            nome: m['nome'] ?? '',
            descricao: m['descricao'] ?? '',
            horarioInicio: DateTime.parse(m['horarioInicio'] ?? '1970-01-01T00:00:00Z'),
            intervaloHoras: m['intervaloHoras'] ?? 0,
            unidade: m['unidade'] ?? '',
            dose: m['dose'] ?? 0.0,
            notificacaoAtivada: m['notificacaoAtivada'] ?? false, // Aqui estamos inicializando proximoHorario
          )));
        }

        List<DadoSaude> historicoSaude = [];
        if (data['historicoSaude'] != null) {
          historicoSaude = List<DadoSaude>.from(data['historicoSaude'].map((d) => DadoSaude(
            id: d['id'] ?? '',
            data: DateTime.parse(d['data'] ?? '1970-01-01T00:00:00Z'),
            tipo: d['tipo'] ?? '',
            valor: d['valor'] ?? '',
            observacoes: d['observacoes'] ?? '',
          )));
        }

        return Perfil(
          id: userId,
          nome: data['nome'] ?? '',
          idade: data['idade'] ?? 0,
          genero: data['genero'] ?? '',
          peso: data['peso'] ?? '',
          altura: data['altura'] ?? '',
          medicacoes: medicacoes,
          historicoSaude: historicoSaude,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao obter perfil: $e');
      return null;
    }
  }
  // Atualizar o perfil no Firebase
  Future<void> atualizarPerfil(String userId, Map<String, dynamic> updates) async {
    try {
      final perfilRef = _firebaseDatabase.child('users/$userId/perfil');
      await perfilRef.update(updates);
      print("Perfil atualizado com sucesso!");
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      rethrow;
    }
  }
  // Deletar o perfil
  Future<void> deletarPerfil(String userId) async {
    try {
      await _firebaseDatabase.child('users/$userId/perfil').remove();
      print("Perfil deletado com sucesso!");
    } catch (e) {
      print('Erro ao deletar perfil: $e');
    }
  }
}
