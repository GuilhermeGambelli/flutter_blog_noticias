import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/estado.dart';
import '../model/municipio.dart';

class IbgeService {
  //
  // Retornar a lista de Estados
  //
  Future<List<Estado>> listarEstados() async {
    var resposta = await http.get(
      Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/?orderby=nome',
      ),
    );

    if (resposta.statusCode == 200) {
      Iterable lista = json.decode(resposta.body);
      return lista.map((modelo) => Estado.fromJson(modelo)).toList();
    } else {
      return [];
    }
  }

  //
  // Retornar a lista de Municipios
  //
  Future<List<Municipio>> listarMunicipios(String sigla) async {
    var resposta = await http.get(
      Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$sigla/municipios',
      ),
    );

    if (resposta.statusCode == 200) {
      Iterable lista = json.decode(resposta.body);
      return lista.map((modelo) => Municipio.fromJson(modelo)).toList();
    } else {
      return [];
    }
  }
}
