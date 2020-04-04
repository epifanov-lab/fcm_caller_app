abstract class Client {
  Future users();
  Future register(Map<String, dynamic> user);
  Future call(Map<String, dynamic> from, Map<String, dynamic> to);
  Future callSendCancel(Map<String, dynamic> from, Map<String, dynamic> to);
  Future callReceiveDismiss(Map<String, dynamic> from, Map<String, dynamic> to);
  Future callReceiveAnswer(Map<String, dynamic> from, Map<String, dynamic> to);
  Future dbErase();
}