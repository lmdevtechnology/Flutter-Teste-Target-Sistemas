// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller_mobx_lista.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ControllerMobXLista on ControllerMobXListaBase, Store {
  late final _$ControllerMobXListaBaseActionController =
      ActionController(name: 'ControllerMobXListaBase', context: context);

  @override
  void adicionarItem(String item) {
    final _$actionInfo = _$ControllerMobXListaBaseActionController.startAction(
        name: 'ControllerMobXListaBase.adicionarItem');
    try {
      return super.adicionarItem(item);
    } finally {
      _$ControllerMobXListaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removerItem(String item) {
    final _$actionInfo = _$ControllerMobXListaBaseActionController.startAction(
        name: 'ControllerMobXListaBase.removerItem');
    try {
      return super.removerItem(item);
    } finally {
      _$ControllerMobXListaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic atualizarLista(int indice, String novoTexto) {
    final _$actionInfo = _$ControllerMobXListaBaseActionController.startAction(
        name: 'ControllerMobXListaBase.atualizarLista');
    try {
      return super.atualizarLista(indice, novoTexto);
    } finally {
      _$ControllerMobXListaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLista(List<String> lista) {
    final _$actionInfo = _$ControllerMobXListaBaseActionController.startAction(
        name: 'ControllerMobXListaBase.setLista');
    try {
      return super.setLista(lista);
    } finally {
      _$ControllerMobXListaBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
