class ContatosBack4appModel {
  List<ContatoModel> contatos = [];

  ContatosBack4appModel(this.contatos);

  ContatosBack4appModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contatos = <ContatoModel>[];
      json['results'].forEach((v) {
        contatos.add(ContatoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contatos.isNotEmpty) {
      data['results'] = contatos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContatoModel {
  String objectId = "";
  String nome = "";
  String sexo = "";
  String telefone = "";
  String imagePath = "";
  String createdAt = "";
  String updatedAt = "";

  ContatoModel(this.objectId, this.nome, this.sexo, this.telefone,
      this.imagePath, this.createdAt, this.updatedAt);

  ContatoModel.criar(this.nome, this.sexo, this.telefone, this.imagePath);

  ContatoModel.vazio() {
    nome = "";
    sexo = "";
    telefone = "";
    imagePath = "";
  }

  ContatoModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['nome'];
    sexo = json['sexo'];
    telefone = json['telefone'];
    imagePath = json['imagePath'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['nome'] = nome;
    data['sexo'] = sexo;
    data['telefone'] = telefone;
    data['imagePath'] = imagePath;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['sexo'] = sexo;
    data['telefone'] = telefone;
    data['imagePath'] = imagePath;
    return data;
  }
}
