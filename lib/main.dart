import 'package:bastionweb/datalogic.dart';
import 'package:bastionweb/widgets/request.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BastionWeb());
}

class BastionWeb extends StatelessWidget {
  const BastionWeb({super.key});

  @override
  Widget build(BuildContext context) {
    DataLogic dataLogic = DataLogic();
    return MaterialApp(
      title: 'Bastion Web Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: MainWidget(
        title: 'Bastion Web',
        dataLogic: dataLogic,
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key, required this.title, required this.dataLogic});

  final String title;
  final DataLogic dataLogic;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  bool _isAuthorized = false;

  var loginTextController = TextEditingController();
  var pwdTextController = TextEditingController();

  login(String login, String pwd, BuildContext context) {
    widget.dataLogic
        .login(login, pwd)
        .then((value) => {
              value
                  ? setState(() {
                      _isAuthorized = value;
                    })
                  : showError("Введены неверные данные", context)
            })
        .catchError((e) {
      showError(e.toString(), context);
    });
  }

  void reLogin() {
    setState(() {
      _isAuthorized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(
        "resources/background.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      _isAuthorized
          ? Scaffold(
              backgroundColor: Colors.transparent,
              drawer: Drawer(
                  backgroundColor: const Color.fromRGBO(255, 255, 255, 100.0),
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 110, 64, 100.0)),
                        child: Text('Bastion'),
                      ),
                      ListTile(
                          leading: const Icon(Icons.login),
                          title: const Text(
                            'Сменить пользователя',
                            textScaleFactor: 1.2,
                          ),
                          onTap: () => {Navigator.pop(context), reLogin()}),
                    ],
                  )),
              appBar: AppBar(
                backgroundColor: const Color.fromRGBO(255, 110, 64, 150.0),
                title: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              body: RequestsWidget(
                dataLogic: widget.dataLogic,
              ),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Card(
                  color: const Color.fromRGBO(255, 255, 255, 170.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "Авторизация",
                            textScaleFactor: 2.0,
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: TextField(
                            controller: loginTextController,
                            decoration: const InputDecoration(
                                hintText: "Введите логин"),
                            onEditingComplete: () => {
                              login(loginTextController.text,
                                      pwdTextController.text, context)
                                  .then((value) => null)
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: TextField(
                            controller: pwdTextController,
                            onEditingComplete: () => {
                              login(loginTextController.text,
                                      pwdTextController.text, context)
                                  .then((value) => null)
                            },
                            decoration: const InputDecoration(
                                hintText: "Введите пароль"),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                            onPressed: () => {
                                  login(loginTextController.text,
                                      pwdTextController.text, context)
                                },
                            child: const Text(
                              "Вход",
                              textScaleFactor: 1.5,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            )
    ]);
  }

  showError(String text, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Ошибка: $text")));
  }
}
