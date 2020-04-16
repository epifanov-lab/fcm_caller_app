import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/utils/ui_utils.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import '../theme.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _methodChannel = const MethodChannel('com.lab.fcmcallerapp.channel');

  User _user = STUB_USER;
  List<User> _allUsers = List();

  List<StreamSubscription> _subscriptions = List();

  @override
  void initState() {
    _updateUser()
        .then((user) => wss.setUser(user))
        .then((_) => _subscriptions.add(_listenWsEvents()))
        .then((_) => _checkAndroidIntentData());

    _methodChannel.setMethodCallHandler((call) {
      var args = call.arguments;
      print('@@@@@ f.channel receve: ${call.method}: $args');
      switch (call.method) {
        case 'onNewIntent':
          _startCallReceiveFromIntent(args);
          break;
      }
      return Future.value(null);
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscriptions.forEach((subscription) => subscription.cancel());
    super.dispose();
  }

  void _checkAndroidIntentData() {
    if (Platform.isAndroid) {
      _methodChannel.invokeMapMethod('get_intent_data')
          .then((result) {
            print('get_intent_data: $result');
            if (result['event'] == 'get call') _startCallReceiveFromIntent(result);
          });
    }
  }

  Future _startCallReceiveFromIntent(Map data) {
    var user = User(data['id'], data['token'], data['type'], data['name']);
    var encode = json.encode([data['event'], user.toMap(), data['roomId']]);
    List args = json.decode(encode) as List;
    _methodChannel.invokeMapMethod('stop_CallFgService');
    return Navigator.pushNamed(context, '/callReceive', arguments: args);
  }

  Future<User> _updateUser() {
    return fcm.initialize().then((token) {
      print('@@@@@ fcmService.initialize: $token');
      return firestore.getUsers().then((users) {
        return _checkIsRegistered(token, users)
            ? Future.value(_user) : _registerNewUser(token);
      });
    });
  }

  bool _checkIsRegistered(String token, List<User> users) {
    bool result = false;
    users.forEach((user) {
      if (token == user.token) {
        result = true;
        setState(() => _user = user);
      }});
    print('@@@@@ checkIsRegistered: $result $_user');
    return result;
  }

  Future<User> _registerNewUser(String token) {
    setState(() => _user = User.generate(token));
    return firestore.register(_user);
  }

  StreamSubscription _listenWsEvents() {
    return wss.data.listen((map) {

      if (map[0] == 'get users list') {
        List rawUsers = (map[1]['push'] as List);
        rawUsers.addAll(map[1]['ws'] as List);
        setState(() {
          _allUsers = rawUsers.map((raw) => User.fromJson(raw)).toList()..remove(_user);
        });

      } else if (map[0] == 'call:get call') {
        Navigator.pushNamed(context, '/callReceive', arguments: map);

      } else if (map[0] == 'twilio:token') {
      Navigator.pushNamed(context, '/twilioRoom', arguments: map);
    }
    });
  }

  Future<void> _refresh() {
    return wss.sendMessage('get users list', null)
        .catchError((error) { /* todo show error */ });
  }

  void _onTapUser(User from, User to)
      => wss.sendMessage('call:send call', to.id)
      .then((_) => Navigator.pushNamed(context, '/callSend',
          arguments: {'id': to.id, 'name': to.name}))
      .catchError((error) { /* todo show error */ });

  @override
  Widget build(BuildContext context) {
    fcm.context = context;
    return Scaffold(
      appBar: AppBar(title: Text('FCM-CALLER-APP')),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _widgetTopUser(),
            Padding(
                padding: EdgeInsets.only(top: 196),
                child: _widgetUsersList()),
            Positioned(bottom: 32, right: 32,
                child: _widgetRefreshButton()),
          ],
        ),
      ),);
  }

  Widget _widgetTopUser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 32),
        AvatarWidget(_user.name, 80, onTap: () => _onTapUser(_user, _user)),
        SizedBox(height: 8),
        _widgetEditableUserName(_user),
        SizedBox(height: 16),
        Text('Контакты:', style: appTheme.textTheme.subtitle1, textAlign: TextAlign.center),
        _allUsers.length > 0 ? Container() : _widgetStubContact()
      ],
    );
  }

  Center _widgetUsersList() {
    return Center(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _allUsers.length,
              itemBuilder: (context, index) => _widgetUserContact(_allUsers[index]),
            ),);
  }

  Widget _widgetEditableUserName(User user) {
    return InkWell(
      onTap: () => UiUtils.dialogEditText(context, _user.name)
          .then((result) {
            if (result != null) {
              setState(() => _user.name = result);
              return firestore.rename(_user)
                  .then((_) => wss.sendMessage('user remove', _user.id))
                  .then((_) => wss.sendMessage('user add', {'name': user.name, 'type': 'mobile'}));
            } else return Future.value(null);
          }),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 16),
            Text(user.name, style: appTheme.textTheme.headline1),
            SizedBox(width: 8),
            Image.asset('assets/icons/ic_edit.png', scale: 2.5, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _widgetUserContact(User user) {
    return InkWell(onTap: () => _onTapUser(_user, user),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(children: <Widget>[
                AvatarWidget(user.name, 48),
                SizedBox(width: 16),
                Text('${user.name}', style: appTheme.textTheme.headline2),
                Expanded(
                  child: Text('[${user.token == null ? 'wss' : 'push'}]', textAlign: TextAlign.end,
                      style: appTheme.textTheme.headline2),
                )
              ],),
            ),);
  }

  Widget _widgetStubContact() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
          'Список доступных для звонка контактов пуст. '
          'Установите приложение на другие устройства. '
          'Проверьте подключение к сети.',
          style: appTheme.textTheme.subtitle2),
    );
  }

  Widget _widgetRefreshButton() {
    return UiUtils.widgetCircleButton(56, colorAccent,
      'assets/icons/ic_refresh.png', 2.2, Colors.white,
      () => _refresh());
  }

}
