import 'package:fcmcallerapp/entities/user.dart';

abstract class AppClient {
  Future<List<User>> users();
  Future register(User user);
  Future call(User from, User to);
  Future callSendCancel(User from, User to);
  Future callReceiveDismiss(User from, User to);
  Future callReceiveAnswer(User from, User to);
  Future dbErase();
}