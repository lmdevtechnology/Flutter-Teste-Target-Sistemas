import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:targettesteapp/controllers/controller_mobx_lista.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TelaCapturaInformacoes extends StatefulWidget {
  const TelaCapturaInformacoes({Key? key}) : super(key: key);

  @override
  State<TelaCapturaInformacoes> createState() => _TelaCapturaInformacoesState();
}

class _TelaCapturaInformacoesState extends State<TelaCapturaInformacoes> {

  ControllerMobXLista _controllerMobXLista = ControllerMobXLista();

  TextEditingController _tecEntradaTexto = TextEditingController();

  int? _indiceEdicao;

  @override
  void initState() {
    super.initState();
    carregarDadosArmazenados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 41, 77, 94),
                    Color.fromARGB(255, 73, 142, 137),
                  ],
                )
            ),
          ),
          Container(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            height: 300,
                            child: Observer(
                              builder: (_){
                                return ListView.separated(
                                  padding: EdgeInsets.only(top: 12, bottom: 12),
                                  itemBuilder: (context, indice){
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.all(12),
                                            child: Text("${_controllerMobXLista.listaTextos[indice]}", maxLines: 2, overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Container(
                                          child: IconButton(
                                            onPressed: (){
                                              setState(() {
                                                _tecEntradaTexto.text = _controllerMobXLista.listaTextos[indice];
                                                _tecEntradaTexto.selection = TextSelection.fromPosition(TextPosition(offset: _tecEntradaTexto.text.length));
                                                _indiceEdicao = indice;
                                              });
                                            },
                                            icon: Icon(Icons.edit_note),
                                          ),
                                        ),
                                        Container(
                                          child: IconButton(
                                            onPressed: (){
                                              mostrarPopupConfirmacao(_controllerMobXLista.listaTextos[indice]);
                                            },
                                            icon: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(14),
                                                color: Colors.red,
                                              ),
                                              child: Icon(Icons.close_rounded, color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, indice){
                                    return Divider();
                                  },
                                  itemCount: _controllerMobXLista.listaTextos.length,
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(top: 12),
                          child: TextField(
                            canRequestFocus: true,
                            autofocus: true,
                            controller: _tecEntradaTexto,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Digite seu texto",
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 12, right: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            maxLines: null,
                            onChanged: (texto){
                              if(texto.contains("\n")){
                                String textoDigitado = texto.replaceAll("\n", "");
                                if(textoDigitado.isNotEmpty){
                                  if(_indiceEdicao != null){
                                    atualizarTexto(_indiceEdicao!, textoDigitado);
                                  }else{
                                    adicionarTexto(textoDigitado);
                                  }
                                }else{
                                  mostrarCaixaDialog(titulo: "Atenção", descricao: "Nenhum texto foi digitado!");
                                }
                                _tecEntradaTexto.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 24),
                  child: TextButton(
                    onPressed: () async {
                      String url = "https://www.google.com.br";
                      if(await canLaunchUrlString(url)){
                        launchUrlString(url);
                      }
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.white
                    ),
                    child: Text("Política de Privacidade"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void mostrarCaixaDialog({required String titulo, required String descricao}){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          title: Text("${titulo}"),
          content: Text("${descricao}"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                primary: Color.fromARGB(255, 100, 177, 112),
              ),
              child: Text("FECHAR"),
            )
          ],
        );
      },
    );
  }

  void adicionarTexto(String texto) async {
    _controllerMobXLista.adicionarItem(texto);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("dados_lista", _controllerMobXLista.listaTextos.toList());
  }
  void removerTexto(String texto) async {
    _controllerMobXLista.removerItem(texto);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("dados_lista", _controllerMobXLista.listaTextos.toList());
  }
  void atualizarTexto(int indice, String novoTexto) async {
    _controllerMobXLista.atualizarLista(indice, novoTexto);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("dados_lista", _controllerMobXLista.listaTextos.toList());
    _indiceEdicao = null;
  }

  void mostrarPopupConfirmacao(String texto) {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          title: Text("Atenção"),
          content: Text("Deseja realmente excluir texto?"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.blueGrey
              ),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: (){
                removerTexto(texto);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text("Sim, excluir"),
            )
          ],
        );
      },
    );
  }

  void carregarDadosArmazenados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> lista = await prefs.getStringList("dados_lista") ?? [];
    _controllerMobXLista.setLista(lista);
    setState(() {});
  }
}
