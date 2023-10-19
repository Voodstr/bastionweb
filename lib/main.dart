import 'package:bastionweb/datalogic.dart';
import 'package:bastionweb/widgets/persons.dart';
import 'package:bastionweb/widgets/requeslist.dart';
import 'package:bastionweb/widgets/request.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BastionWeb(
    dataLogic: DataLogic(),
  ));
}

class BastionWeb extends StatefulWidget {
  const BastionWeb({super.key, required this.dataLogic});

  final DataLogic dataLogic;

  @override
  State<BastionWeb> createState() => _BastionWebState();
}

class _BastionWebState extends State<BastionWeb> {
  bool _isDarkTheme = false;
  String pathToAppBackground = "resources/dark_background.png";

  @override
  void initState() {
    super.initState();
  }

  void changeTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      _isDarkTheme
          ? pathToAppBackground = "resources/background.png"
          : pathToAppBackground = "resources/dark_background.png";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bastion Web Demo',
      theme: _isDarkTheme
          ? ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.orange, brightness: Brightness.light),
              useMaterial3: true,
            )
          : ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepOrange, brightness: Brightness.dark),
              useMaterial3: true,
            ),
      home: Stack(children: <Widget>[
        Image.asset(
          path(pathToAppBackground),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        MainWidget(
          title: 'Bastion Web',
          dataLogic: widget.dataLogic,
          changeTheme: changeTheme,
        )
      ]),
    );
  }

  String path(str) {
    return kIsWeb ? 'assets/$str' : str;
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget(
      {super.key,
      required this.title,
      required this.dataLogic,
      required this.changeTheme});

  final String title;
  final DataLogic dataLogic;

  final void Function() changeTheme;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  bool _isAuthorized = false;
  int _selectedWindow = 1;

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

  List<MainView> mainViewList = [];
  List<String> mainViewLabels = [];

  @override
  void initState() {
    mainViewList = [
      MainView("Список персон", PersonsWidget(dataLogic: widget.dataLogic),
          const Icon(Icons.person)),
      MainView(
          "Cоздание заявки", const RequestWidget(), const Icon(Icons.request_page)),
      MainView("Просмотр заявок", const RequestListWidget(), const Icon(Icons.list))
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loginTextController = TextEditingController();
    var pwdTextController = TextEditingController();

    return _isAuthorized
        ? Scaffold(
            backgroundColor: Colors.transparent,
            drawer: Drawer(
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                child: Column(
                  // Important: Remove any padding from the ListView.
                  //padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).canvasColor.withOpacity(0.8)),
                      child: const FittedBox(fit:BoxFit.fill,child:Text('Bastion')),
                    ),
                    ...mainViewList.map(
                      (e) => ListTile(
                          leading: mainViewList[mainViewList.indexOf(e)].icon,
                          title: Text(
                            mainViewList[mainViewList.indexOf(e)].title,
                            textScaleFactor: 1.2,
                          ),
                          onTap: () => {
                                Navigator.pop(context),
                                _onDrawerChange(mainViewList.indexOf(e))
                              }),
                    ),
                    ListTile(
                        leading: const Icon(Icons.login),
                        title: const Text(
                          'Сменить пользователя',
                          textScaleFactor: 1.2,
                        ),
                        onTap: () => {Navigator.pop(context), reLogin()}),
                    const Spacer(),
                    const ListTile(
                        leading: Icon(Icons.info_outline), title: Text('Версия 0.15')),
                  ],
                )),
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: widget.changeTheme,
                    icon: const Icon(Icons.dark_mode)),
              ],
              title: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
            ),
            body: mainViewList[_selectedWindow].widget,
          )
        : Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Card(
                color: Theme.of(context).cardColor.withOpacity(0.5),
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
                          decoration:
                              const InputDecoration(hintText: "Введите логин"),
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
                          obscureText: true,
                          controller: pwdTextController,
                          onEditingComplete: () => {
                            login(loginTextController.text,
                                pwdTextController.text, context)
                          },
                          decoration:
                              const InputDecoration(hintText: "Введите пароль"),
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
          );
  }

  showError(String text, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Ошибка: $text")));
  }

  _onDrawerChange(int index) {
    setState(() {
      _selectedWindow = index;
    });
  }
}

class MainView {
  MainView(this.title, this.widget, this.icon);

  final String title;
  final Widget widget;
  final Icon icon;
}
