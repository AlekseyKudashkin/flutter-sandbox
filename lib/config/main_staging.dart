import 'package:flutter_sandbox/config/app_config.dart';
import 'package:flutter_sandbox/main_app.dart';

Future<void> main() async {
  final appConfig = AppConfig(
    iceServer1: "stun:stun.l.google.com:19302",
    iceServer2: "stun:stun.stunprotocol.org:3478",
    signalingServer: "wss://flutter-sandbox-alekskud13.herokuapp.com/",
    httpServer: "https://flutter-sandbox-alekskud13.herokuapp.com/",
  );
  return mainApp(appConfig);
}
