import 'dart:io';

import 'package:bastionweb/datalogic.dart';
import 'package:bastionweb/widgets/fields/clockwidget.dart';
import 'package:bastionweb/widgets/persons.dart';
import 'package:bastionweb/widgets/requeslist.dart';
import 'package:bastionweb/widgets/request.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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
  ThemeData appTheme = ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.blue,
      fontFamily: GoogleFonts.robotoSlab().fontFamily);

  @override
  void initState() {
    super.initState();
  }

  void changeTheme(Brightness brightness) {
    setState(() {
      appTheme = ThemeData(brightness: brightness);
    });
  }

  @override
  Widget build(BuildContext appContext) {
    return MaterialApp(
        title: 'Бастион web',
        theme: appTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru'), // Русский
        ],
        home: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  appTheme.colorScheme.primary,
                  appTheme.colorScheme.secondary,
                ],
                //stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
                tileMode: TileMode.repeated,
              ),
            ),
            child: MainWidget(
                title: 'Бастион web',
                dataLogic: widget.dataLogic,
                changeTheme: (brightness) => changeTheme(brightness))));
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

  final void Function(Brightness brightness) changeTheme;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  bool _isAuthorized = false;
  int _selectedWindow = 1;

  final minSizeForDrawer = 1300;

  @override
  Widget build(BuildContext mainWidgetContext) {
    List<MainView> mainViewList = [
      MainView("Список персон", PersonsWidget(dataLogic: widget.dataLogic),
          const Icon(Icons.person)),
      MainView("Cоздание заявки", const RequestWidget(),
          const Icon(Icons.request_page)),
      MainView(
          "Просмотр заявок", const RequestListWidget(), const Icon(Icons.list))
    ];
    var loginTextController = TextEditingController();
    var pwdTextController = TextEditingController();
    return _isAuthorized
        ? Scaffold(
            drawer: MediaQuery.of(context).size.width <= minSizeForDrawer
                ? Drawer(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(10))),
                    child: Container(
                        child: Column(
                          // Important: Remove any padding from the ListView.
                          //padding: EdgeInsets.zero,
                          children: [
                            DrawerHeader(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Бастион',
                                      style: Theme.of(mainWidgetContext)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const ClockWidget()
                                  ]),
                            ),
                            ...mainViewList.map(
                              (e) => ListTile(
                                  leading: mainViewList[mainViewList.indexOf(e)]
                                      .icon,
                                  title: Text(
                                    mainViewList[mainViewList.indexOf(e)].title,
                                    style: Theme.of(mainWidgetContext)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  onTap: () => {
                                        Navigator.pop(mainWidgetContext),
                                        _onDrawerChange(mainViewList.indexOf(e))
                                      }),
                            ),
                            ListTile(
                                leading: const Icon(Icons.login),
                                title: Text(
                                  'Сменить пользователя',
                                  style: Theme.of(mainWidgetContext)
                                      .textTheme
                                      .titleMedium,
                                ),
                                onTap: () => {
                                      Navigator.pop(mainWidgetContext),
                                      reLogin()
                                    }),
                            const Spacer(),
                            ListTile(
                                leading: const Icon(Icons.info_outline),
                                title: Text(Platform.version,
                                  style: Theme.of(mainWidgetContext)
                                      .textTheme
                                      .titleSmall,
                                )),
                          ],
                        )))
                : null,
            appBar: AppBar(
              backgroundColor: Theme.of(mainWidgetContext)
                  .colorScheme
                  .primary
                  .withOpacity(0.5),
              actions: [
                IconButton(
                    onPressed: () => widget.changeTheme(
                        Theme.of(context).brightness == Brightness.dark
                            ? Brightness.light
                            : Brightness.dark),
                    icon: const Icon(Icons.dark_mode)),
              ],
              title: Text(
                widget.title,
                style: Theme.of(mainWidgetContext).textTheme.titleLarge,
              ),
              centerTitle: true,
            ),
            body: MediaQuery.of(context).size.width > minSizeForDrawer
                ? Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Container(
                              child: Column(
                                // Important: Remove any padding from the ListView.
                                //padding: EdgeInsets.zero,
                                children: [
                                  DrawerHeader(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                              flex: 1,
                                              child: Text(
                                                'Бастион',
                                                style:
                                                    Theme.of(mainWidgetContext)
                                                        .textTheme
                                                        .titleLarge,
                                              )),
                                          const Flexible(
                                              flex: 1, child: ClockWidget())
                                        ]),
                                  ),
                                  ...mainViewList.map(
                                    (e) => ListTile(
                                        title: Text(
                                          mainViewList[mainViewList.indexOf(e)]
                                              .title,
                                          style: Theme.of(mainWidgetContext)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        onTap: () => {
                                              _onDrawerChange(
                                                  mainViewList.indexOf(e))
                                            }),
                                  ),
                                  ListTile(
                                      leading: const Icon(Icons.login),
                                      title: Text(
                                        'Сменить пользователя',
                                        style: Theme.of(mainWidgetContext)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      onTap: () => {reLogin()}),
                                  const Spacer(),
                                  ListTile(
                                      leading: const Icon(Icons.info_outline),
                                      title: Text(
                                        'Версия 0.15',
                                        style: Theme.of(mainWidgetContext)
                                            .textTheme
                                            .titleSmall,
                                      )),
                                ],
                              ))),
                      Flexible(
                          flex: 5,
                          child: Container(
                              alignment: Alignment.topCenter,
                              child: mainViewList[_selectedWindow].widget)),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "Документация: ${mainViewList[_selectedWindow].title}")
                                ],
                              ))),
                    ],
                  )
                : mainViewList[_selectedWindow].widget,
          )
        : Scaffold(
            body: Center(
              child: Card(
                color: Theme.of(mainWidgetContext).cardColor.withOpacity(0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Авторизация",
                          style: Theme.of(mainWidgetContext)
                              .textTheme
                              .headlineMedium,
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: TextField(
                          controller: loginTextController,
                          decoration:
                              const InputDecoration(hintText: "Введите логин"),
                          onEditingComplete: () => {
                            login(loginTextController.text,
                                    pwdTextController.text, mainWidgetContext)
                                .then((value) => null)
                          },
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: TextField(
                          obscureText: true,
                          controller: pwdTextController,
                          onEditingComplete: () => {
                            login(loginTextController.text,
                                pwdTextController.text, mainWidgetContext)
                          },
                          decoration:
                              const InputDecoration(hintText: "Введите пароль"),
                        )),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: FilledButton(
                          onPressed: () => {
                                login(loginTextController.text,
                                    pwdTextController.text, mainWidgetContext)
                              },
                          child: const Text(
                            "Вход",
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
  }

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
        .catchError((e) => showError(e.toString(), context));
  }

  void reLogin() {
    setState(() {
      _isAuthorized = false;
      widget.dataLogic.logout();
    });
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
