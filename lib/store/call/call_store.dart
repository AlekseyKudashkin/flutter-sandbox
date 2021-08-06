import 'package:mobx/mobx.dart';

part 'call_store.g.dart';

class CallStore = _CallStore with _$CallStore;

abstract class _CallStore with Store {
  @observable
  bool isConnected = false;

  @observable
  String opponentName = "";

  @observable
  String waitingToConnect = "Waiting to connect with user...";

  @observable
  String name = "";

  @observable
  bool offer = false;

  @observable
  bool micEnabled = true;

  @observable
  bool camEnabled = true;
}
