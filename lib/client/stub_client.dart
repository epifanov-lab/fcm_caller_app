import 'package:fcmcallerapp/client/client.dart';

class StubClient extends Client {

  @override
  Future users() => Future.value({});

  @override
  Future register(Map<String, dynamic> user) => Future.value({});

  @override
  Future call(Map<String, dynamic> from, Map<String, dynamic> to)
    => Future.value({});

  @override
  Future callReceiveAnswer(Map<String, dynamic> from, Map<String, dynamic> to)
    => Future.value({});

  @override
  Future callReceiveDismiss(Map<String, dynamic> from, Map<String, dynamic> to)
    => Future.value({});

  @override
  Future callSendCancel(Map<String, dynamic> from, Map<String, dynamic> to)
    => Future.value({});

  @override
  Future dbErase() => Future.value({});

}
