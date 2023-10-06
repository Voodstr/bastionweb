import 'dart:io';
import 'dart:js';

import 'package:bastionweb/datalogic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key,required this.dataLogic});
  final DataLogic dataLogic;

  @override
  Widget build(BuildContext context) {
    var loginTextController = TextEditingController();
    var pwdTextController = TextEditingController();
    return Scaffold(body: Center(child: Column(children: [
      const Flexible(child: Text("Авторизация")),
      Flexible(child: TextField(controller: loginTextController,decoration: const InputDecoration(hintText: "Введите логин"),)),
      Flexible(child: TextField(controller: pwdTextController,decoration: const InputDecoration(hintText: "Введите пароль"),)),
      Row(children: [
        ElevatedButton(onPressed: () => {login(loginTextController.text, pwdTextController.text)}, child: const Text("Вход")),
        ElevatedButton(onPressed: () => {exit(0)}, child: const Text("Отмена"))
      ],)
    ],),));
  }

  Future<void> login(String login, String pwd) async {
    await dataLogic.login(login,pwd)? {}:{};
  }

}