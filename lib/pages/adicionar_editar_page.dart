import 'dart:io';

import 'package:desafiolistacontatos/model/contatos_back4app_model.dart';
import 'package:desafiolistacontatos/pages/listagem_page.dart';
import 'package:desafiolistacontatos/repositories/contatos_back4app_repository.dart';
import 'package:desafiolistacontatos/shared/widgets/text_label.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class AdicionarEditarPage extends StatefulWidget {
  final ContatoModel contatoModel;
  const AdicionarEditarPage({super.key, required this.contatoModel});

  @override
  State<AdicionarEditarPage> createState() => _AdicionarEditarPageState();
}

class _AdicionarEditarPageState extends State<AdicionarEditarPage> {
  XFile? photo;
  var nomeController = TextEditingController();
  var telefoneController = TextEditingController();
  String genero = "";
  ContatosBack4AppRepositoy contatosRepository = ContatosBack4AppRepositoy();
  bool loading = true;

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      photo = XFile(croppedFile.path);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    obterDados();
  }

  obterDados() {
    if (widget.contatoModel.objectId.isNotEmpty) {
      genero = widget.contatoModel.sexo;
      nomeController.text = widget.contatoModel.nome;
      telefoneController.text = widget.contatoModel.telefone;
      photo = XFile(widget.contatoModel.imagePath);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Adicionar Contato",
            style: GoogleFonts.nosifer(fontSize: 16),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return Wrap(
                        children: [
                          ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.camera,
                              color: Colors.purple,
                            ),
                            title: const Text("Camera"),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              photo = await _picker.pickImage(
                                  source: ImageSource.camera);
                              if (photo != null) {
                                String path = (await path_provider
                                        .getApplicationDocumentsDirectory())
                                    .path;
                                String name = basename(photo!.path);
                                await photo!.saveTo("$path/$name");

                                await GallerySaver.saveImage(photo!.path);
                                Navigator.pop(context);

                                cropImage(photo!);
                              }
                            },
                          ),
                          ListTile(
                              leading: const FaIcon(
                                FontAwesomeIcons.images,
                                color: Colors.purple,
                              ),
                              title: const Text("Galeria"),
                              onTap: () async {
                                final ImagePicker _picker = ImagePicker();
                                photo = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                if (photo != null) {
                                  Navigator.pop(context);

                                  cropImage(photo!);
                                }
                              })
                        ],
                      );
                    });
              },
              child: CircleAvatar(
                backgroundColor: Colors.purple,
                radius: 59.0,
                child: CircleAvatar(
                    backgroundColor:
                        photo == null ? Colors.white : Colors.transparent,
                    radius: 55.0,
                    child: photo == null
                        ? const FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.purple,
                          )
                        : ClipOval(
                            child: Image.file(
                              File(photo!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )),
              ),
            ),
            const TextLabel(texto: "Nome:"),
            TextField(
              controller: nomeController,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: -2),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple)),
              ),
            ),
            const TextLabel(texto: "Gênero:"),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => setState(() {
                      genero = "F";
                    }),
                    child: Card(
                      color:
                          genero == "F" ? Colors.purple : Colors.grey.shade300,
                      elevation: 8,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.female,
                              size: 50,
                              color:
                                  genero == "F" ? Colors.white : Colors.black,
                            ),
                            Text(
                              "Femino",
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    genero == "F" ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      genero = "M";
                    }),
                    child: Card(
                      color:
                          genero == "M" ? Colors.purple : Colors.grey.shade300,
                      elevation: 8,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.male,
                              size: 50,
                              color:
                                  genero == "M" ? Colors.white : Colors.black,
                            ),
                            Text(
                              "Masculino",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: genero == "M"
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const TextLabel(texto: "Telefone:"),
            TextFormField(
              controller: telefoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: -2),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple)),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor: MaterialStateProperty.all(Colors.purple)),
                onPressed: () async {
                  if (photo == null) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: const Text("Favor informar uma foto válido!"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("ok"))
                        ],
                      ),
                    );
                    return;
                  } else if (nomeController.text.isEmpty &&
                      nomeController.text.trim() == "") {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: const Text("Favor informar um nome válido!"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("ok"))
                        ],
                      ),
                    );
                    return;
                  } else if (genero.isEmpty && genero.trim() == "") {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content:
                            const Text("Favor informar selecionar um gênero!"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("ok"))
                        ],
                      ),
                    );
                    return;
                  } else if (telefoneController.text.isEmpty ||
                      telefoneController.text.trim() == "") {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content:
                            const Text("Favor informar um telefone válido!"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("ok"))
                        ],
                      ),
                    );
                    return;
                  }

                  widget.contatoModel.nome = nomeController.text;
                  widget.contatoModel.sexo = genero;
                  widget.contatoModel.telefone = telefoneController.text;
                  widget.contatoModel.imagePath = photo!.path;
                  if (widget.contatoModel.objectId.isNotEmpty) {
                    await contatosRepository.atualizar(widget.contatoModel);
                  } else {
                    await contatosRepository.criar(widget.contatoModel);
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListagemPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                    widget.contatoModel.objectId.isNotEmpty
                        ? "Alterar"
                        : "Adicionar",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
