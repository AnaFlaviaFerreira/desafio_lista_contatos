import 'dart:io';

import 'package:desafiolistacontatos/model/contatos_back4app_model.dart';
import 'package:desafiolistacontatos/pages/adicionar_editar_page.dart';
import 'package:desafiolistacontatos/repositories/contatos_back4app_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListagemPage extends StatefulWidget {
  const ListagemPage({super.key});

  @override
  State<ListagemPage> createState() => _ListagemPageState();
}

class _ListagemPageState extends State<ListagemPage> {
  bool loading = true;
  ContatosBack4AppRepositoy contatosRepository = ContatosBack4AppRepositoy();
  var _contatosBack4App = ContatosBack4appModel([]);

  @override
  void initState() {
    super.initState();
    obterContatos();
  }

  obterContatos() async {
    setState(() {
      loading = true;
    });
    _contatosBack4App = await contatosRepository.obterContatos();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Listagem",
            style: GoogleFonts.nosifer(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdicionarEditarPage(
                  contatoModel: ContatoModel.vazio(),
                ),
              )),
          child: const Icon(Icons.add),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: loading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LinearProgressIndicator(),
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                        child: ListView.builder(
                      itemCount: _contatosBack4App.contatos.length,
                      itemBuilder: (context, index) {
                        var contato = _contatosBack4App.contatos[index];

                        return Column(
                          children: [
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdicionarEditarPage(
                                      contatoModel: contato,
                                    ),
                                  )),
                              child: Dismissible(
                                key: Key(contato.objectId),
                                onDismissed: (direction) async {
                                  await contatosRepository
                                      .remover(contato.objectId);
                                  obterContatos();
                                },
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  color: Colors.red,
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                child: ListTile(
                                  title: Text(contato.nome),
                                  // leading: Image.asset(AppImages.user1),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.file(
                                        File(contato.imagePath),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Telefone: ${contato.telefone}"),
                                      Text(
                                          "Sexo: ${contato.sexo == 'F' ? 'Feminino' : 'Masculino'}"),
                                    ],
                                  ),
                                  trailing: const FaIcon(
                                      FontAwesomeIcons.pencil,
                                      color: Colors.purple),
                                ),
                              ),
                            ),
                            const Divider(color: Colors.purple, thickness: 2),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ))
                  ],
                ),
        ),
      ),
    );
  }
}
