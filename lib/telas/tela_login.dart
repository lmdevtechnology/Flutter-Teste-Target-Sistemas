import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:targettesteapp/telas/tela_captura_informacoes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {

  TextEditingController _tecUsuario = TextEditingController();
  TextEditingController _tecSenha = TextEditingController();

  bool _senhaVisivel = false;
  bool _logando = false;

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
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Usuário", style: TextStyle(color: Colors.white)),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(top: 8),
                          child: TextField(
                            controller: _tecUsuario,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9]{1,20}"))],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.person, color: Colors.black),
                              contentPadding: EdgeInsets.only(left: 12, right: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              )
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 24),
                          child: Text("Senha", style: TextStyle(color: Colors.white)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: TextField(
                            controller: _tecSenha,
                            obscureText: !_senhaVisivel,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9]{1,20}"))],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 12, right: 12),
                              prefixIcon: Icon(Icons.lock, color: Colors.black),
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    _senhaVisivel = !_senhaVisivel;
                                  });
                                },
                                icon: Icon(_senhaVisivel ? Icons.visibility : Icons.visibility_off, color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 120,
                          margin: EdgeInsets.only(top: 24),
                          child: ElevatedButton(
                            onPressed: (){
                              bool camposPreenchidos = validarPreenchimentoCampos();
                              if(camposPreenchidos){
                                FocusManager.instance.primaryFocus?.unfocus();
                                validarLogin(_tecUsuario.text, _tecSenha.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 100, 177, 112),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(45/2)
                              ),
                            ),
                            child: Text("Entrar"),
                          ),
                        ),
                        Visibility(
                          visible: _logando,
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(top: 24),
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 100, 177, 112),
                            ),
                          ),
                        )
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

  bool validarPreenchimentoCampos(){
    if(_tecUsuario.text.isEmpty){
      mostrarCaixaDialog(titulo: "Atenção", descricao: "O campo usuário deve ser preenchido!");
      return false;
    }else if(_tecSenha.text.length < 2){
      mostrarCaixaDialog(titulo: "Atenção", descricao: "O campo senha deve ter no mínimo dois caracteres!");
      return false;
    }else if(_tecUsuario.text.characters.last == " "){
      mostrarCaixaDialog(titulo: "Atenção", descricao: "O campo usuário não deve terminar com caractere espaço!");
      return false;
    }else if(_tecSenha.text.characters.last == " "){
      mostrarCaixaDialog(titulo: "Atenção", descricao: "O campo senha não deve terminar com caractere espaço!");
      return false;
    }else{
      return true;
    }
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
              child: Text("Fechar"),
            )
          ],
        );
      },
    );
  }

  void validarLogin(String usuario, String senha) async {
    setState(() {
      _logando = true;
    });
    String url = "https://6583c5274d1ee97c6bce46fe.mockapi.io/api/v1/login";
    Map<String,String> parametros = {
      "user" : usuario,
      "senha" : senha
    };
    try{
      http.Response response = await http.post(Uri.parse(url), body: jsonEncode(parametros));
      setState(() {
        _logando = false;
      });
      if(response.statusCode == 201){
        print("Dados de Login");
        print(response.body);
        Navigator.push(context, MaterialPageRoute(builder: (context) => TelaCapturaInformacoes()));
      }else{
        mostrarCaixaDialog(titulo: "Atenção", descricao: "Não foi possível realizar login!");
      }
    }catch(e){
      setState(() {
        _logando = false;
      });
      mostrarCaixaDialog(titulo: "Atenção", descricao: "Não foi possível realizar login!");
    }
  }
}
