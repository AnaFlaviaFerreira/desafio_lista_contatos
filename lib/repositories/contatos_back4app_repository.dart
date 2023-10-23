import 'package:desafiolistacontatos/model/contatos_back4app_model.dart';

import 'back4app_custon_dio.dart';

class ContatosBack4AppRepositoy {
  final _custonDio = Back4AppCustonDio();

  ContatosBack4AppRepositoy();

  Future<ContatosBack4appModel> obterContatos() async {
    var url = "/Contatos";
    var result = await _custonDio.dio.get(url);
    return ContatosBack4appModel.fromJson(result.data);
  }

  Future<void> criar(ContatoModel contatoModel) async {
    try {
      await _custonDio.dio
          .post("/Contatos", data: contatoModel.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(ContatoModel contatoModel) async {
    try {
      await _custonDio.dio.put("/Contatos/${contatoModel.objectId}",
          data: contatoModel.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      await _custonDio.dio.delete(
        "/Contatos/$objectId",
      );
    } catch (e) {
      rethrow;
    }
  }
}
