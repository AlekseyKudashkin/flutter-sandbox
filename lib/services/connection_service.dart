import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sandbox/config/app_config.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:web_socket_channel/io.dart';

class ConnectionService {
  final AppConfig appConfig;

  ConnectionService(this.appConfig);

  bool _offer = false;
  final RTCVideoRenderer localRender = new RTCVideoRenderer();
  final RTCVideoRenderer remoteRender = new RTCVideoRenderer();
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;

  late IOWebSocketChannel channel;
  var channelListen;

  final sdpController = TextEditingController();

  initRenderers() async {
    await localRender.initialize();
    await remoteRender.initialize();
  }

  webSocketConnect() async {
    try {
      channel = IOWebSocketChannel.connect(
        Uri.parse('wss://flutter-sandbox-alekskud13.herokuapp.com/'),
      );
      channel.stream.asBroadcastStream();
      print("Connected to heroku!");
    } catch (e) {
      print("Failed connect to heroku!");
    }
  }

  createPeerConnections() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
        {"url": "stun:stun.stunprotocol.org:3478"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    pc.onSignalingState = (state) {
      if (state == RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
        print("Have remote offer");
      }
      if (state == RTCSignalingState.RTCSignalingStateHaveLocalOffer) {
        print("Have local offer");
      }
      if (state == RTCSignalingState.RTCSignalingStateHaveLocalPrAnswer) {
        print("Have local answer");
      }
      if (state == RTCSignalingState.RTCSignalingStateHaveRemotePrAnswer) {
        print("Have remote answer");
      }
    };

    pc.addStream(localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMlineIndex,
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      remoteRender.srcObject = stream;
    };

    return pc;
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints;
    mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user', 'optional': []},
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    localRender.srcObject = stream;

    return stream;
  }

  void createOffer() async {
    RTCSessionDescription description = await peerConnection!.createOffer({
      'offerToReceiveVideo': 1,
    });
    var session = parse(description.sdp.toString());
    print(json.encode(session));
    _offer = true;

    peerConnection!.setLocalDescription(description);
    print(description.sdp);
    channel.sink.add("Offer");
    channel.sink.add(description.sdp);
  }

  void createAnswer() async {
    RTCSessionDescription description =
        await peerConnection!.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp.toString());
    //print(json.encode(session));

    peerConnection!.setLocalDescription(description);

    channel.sink.add("Answer: " + json.encode(session));
  }

  void sinkData(String data, String id) {
    channel.sink.add('Id: $id $data');
  }

  void setRemoteDescription(String jsonString) async {
    dynamic session = await jsonDecode('$jsonString');

    String sdp = write(session, null);

    RTCSessionDescription description =
        new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print(description.toMap());

    await peerConnection!.setRemoteDescription(description);
  }

  void addCandidate() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');
    //print(session['candidate']);
    dynamic candidate = new RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await peerConnection!.addCandidate(candidate);
  }
}
