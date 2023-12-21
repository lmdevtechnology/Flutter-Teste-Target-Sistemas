import 'package:mobx/mobx.dart';

part 'controller_mobx_lista.g.dart';

class ControllerMobXLista = ControllerMobXListaBase with _$ControllerMobXLista;

abstract class ControllerMobXListaBase with Store {

  ObservableList<String> listaTextos = ObservableList();

  @action
  void adicionarItem(String item){
    listaTextos.add(item);
  }
  @action removerItem(String item){
    listaTextos.remove(item);
  }
  @action atualizarLista(int indice, String novoTexto){
    listaTextos[indice] = novoTexto;
  }
  @action
  void setLista(List<String> lista){
    listaTextos = ObservableList<String>.of(lista);
  }
}