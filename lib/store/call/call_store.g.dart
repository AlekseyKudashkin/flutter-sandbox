// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CallStore on _CallStore, Store {
  final _$isConnectedAtom = Atom(name: '_CallStore.isConnected');

  @override
  bool get isConnected {
    _$isConnectedAtom.reportRead();
    return super.isConnected;
  }

  @override
  set isConnected(bool value) {
    _$isConnectedAtom.reportWrite(value, super.isConnected, () {
      super.isConnected = value;
    });
  }

  final _$opponentNameAtom = Atom(name: '_CallStore.opponentName');

  @override
  String get opponentName {
    _$opponentNameAtom.reportRead();
    return super.opponentName;
  }

  @override
  set opponentName(String value) {
    _$opponentNameAtom.reportWrite(value, super.opponentName, () {
      super.opponentName = value;
    });
  }

  final _$waitingToConnectAtom = Atom(name: '_CallStore.waitingToConnect');

  @override
  String get waitingToConnect {
    _$waitingToConnectAtom.reportRead();
    return super.waitingToConnect;
  }

  @override
  set waitingToConnect(String value) {
    _$waitingToConnectAtom.reportWrite(value, super.waitingToConnect, () {
      super.waitingToConnect = value;
    });
  }

  final _$nameAtom = Atom(name: '_CallStore.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  @override
  String toString() {
    return '''
isConnected: ${isConnected},
opponentName: ${opponentName},
waitingToConnect: ${waitingToConnect},
name: ${name}
    ''';
  }
}
