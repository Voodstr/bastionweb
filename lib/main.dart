import 'package:bastionweb/datalogic.dart';
import 'package:bastionweb/widgets/fields/clockwidget.dart';
import 'package:bastionweb/widgets/persons.dart';
import 'package:bastionweb/widgets/requeslist.dart';
import 'package:bastionweb/widgets/request.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
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
  ThemeData appTheme = ThemeData(brightness: Brightness.light,
      colorSchemeSeed: Colors.indigo,
      fontFamily: GoogleFonts.adventPro().fontFamily);

  @override
  void initState() {
    super.initState();
  }

  void changeTheme(Brightness brightness, Color seedColor, String fontFamily) {
    setState(() {
      appTheme = ThemeData(
          brightness: brightness,
          textTheme: appTheme.textTheme
              .apply(fontFamily: GoogleFonts.getFont(fontFamily).fontFamily),
          colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: brightness),
          primarySwatch: getMaterialColor(seedColor));
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
              changeTheme: (brightness, seedColor, fontFamily) =>
                  changeTheme(brightness, seedColor, fontFamily),
            )));
  }

  MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
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

  final void Function(Brightness brightness, Color seedColor, String fontFamily)
      changeTheme;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  bool _isAuthorized = false;
  int _selectedWindow = 1;

  Color currentColor = Colors.transparent;
  PickerFont selectedFont = PickerFont(
      fontFamily: GoogleFonts.adventPro().fontFamily?.split("_").first ?? "");

  final minSizeForDrawer = 1300;

  @override
  Widget build(BuildContext mainWidgetContext) {
    currentColor == Colors.transparent
        ? currentColor = Theme.of(mainWidgetContext).colorScheme.primary
        : {};
    selectedFont.fontFamily == ''
        ? selectedFont = PickerFont(
            fontFamily: Theme.of(mainWidgetContext)
                    .textTheme
                    .bodyMedium
                    ?.fontFamily
                    ?.split("_")
                    .first ??
                "")
        : {};
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
            backgroundColor: Colors.transparent,
            drawer: MediaQuery.of(context).size.width <= minSizeForDrawer
                ? Drawer(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(10))),
                    backgroundColor: Theme.of(mainWidgetContext)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                              Theme.of(mainWidgetContext)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                              Theme.of(mainWidgetContext)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.5),
                            ])),
                        child: Column(
                          // Important: Remove any padding from the ListView.
                          //padding: EdgeInsets.zero,
                          children: [
                            DrawerHeader(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Theme.of(mainWidgetContext)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                                Theme.of(mainWidgetContext)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.5),
                              ])),
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
                                  selectedColor: Theme.of(mainWidgetContext)
                                      .colorScheme
                                      .onSecondary
                                      .withOpacity(0.9),
                                  selectedTileColor: Theme.of(mainWidgetContext)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.9),
                                  hoverColor: Theme.of(mainWidgetContext)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.9),
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
                                hoverColor: Theme.of(mainWidgetContext)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.9),
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
                                title: Text(
                                  'Версия 0.15',
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
                    onPressed: () => showDialog(
                        context: mainWidgetContext,
                        barrierDismissible: false,
                        builder: (BuildContext themeSetupContext) {
                          var currentDarkMode =
                              Theme.of(themeSetupContext).brightness ==
                                      Brightness.light
                                  ? true
                                  : false;
                          return Dialog(
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.dark_mode),
                                          onPressed: () => widget.changeTheme(
                                              currentDarkMode
                                                  ? Brightness.dark
                                                  : Brightness.light,
                                              currentColor,
                                              selectedFont.fontFamily),
                                        ),
                                        MaterialPicker(
                                            pickerColor: currentColor,
                                            onColorChanged: (color) =>
                                                changeColor(color)),
                                        Container(
                                            padding: const EdgeInsets.all(8),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context:
                                                          themeSetupContext,
                                                      builder: (BuildContext
                                                          fontSetupContext) {
                                                        return Dialog(
                                                            child: Container(
                                                                constraints:
                                                                    BoxConstraints.loose(
                                                                        const Size(
                                                                            400,
                                                                            500)),
                                                                child:
                                                                    FontPicker(
                                                                  onFontChanged:
                                                                      (PickerFont
                                                                              font) =>
                                                                          {
                                                                    selectedFont =
                                                                        font
                                                                  },
                                                                )));
                                                      });
                                                },
                                                child: const Text(
                                                    "Изменить шрифт"))),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: ElevatedButton(
                                                    onPressed: () =>
                                                        widget.changeTheme(
                                                            Theme.of(
                                                                    themeSetupContext)
                                                                .brightness,
                                                            currentColor,
                                                            selectedFont
                                                                .fontFamily),
                                                    child: const Text(
                                                        "Применить"))),
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: ElevatedButton(
                                                    onPressed: () => Navigator.of(
                                                            themeSetupContext)
                                                        .pop(),
                                                    child:
                                                        const Text("Закрыть")))
                                          ],
                                        )
                                      ])));
                        }),
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
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                    Theme.of(mainWidgetContext)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    Theme.of(mainWidgetContext)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.5),
                                  ])),
                              child: Column(
                                // Important: Remove any padding from the ListView.
                                //padding: EdgeInsets.zero,
                                children: [
                                  DrawerHeader(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                      Theme.of(mainWidgetContext)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                      Theme.of(mainWidgetContext)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.5),
                                    ])),
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
                                        selectedColor:
                                            Theme.of(mainWidgetContext)
                                                .colorScheme
                                                .onSecondary
                                                .withOpacity(0.9),
                                        selectedTileColor:
                                            Theme.of(mainWidgetContext)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.9),
                                        hoverColor: Theme.of(mainWidgetContext)
                                            .colorScheme
                                            .onPrimary
                                            .withOpacity(0.9),
                                        leading: mainViewList[
                                                mainViewList.indexOf(e)]
                                            .icon,
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
                                      hoverColor: Theme.of(mainWidgetContext)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.9),
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
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                    Theme.of(mainWidgetContext)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    Theme.of(mainWidgetContext)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.5),
                                  ])),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [ Text("Документация: ${mainViewList[_selectedWindow].title}")
                                ],
                              ))),
                    ],
                  )
                : mainViewList[_selectedWindow].widget,
          )
        : Scaffold(
            backgroundColor: Colors.transparent,
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
                      child: ElevatedButton(
                          onPressed: () => {
                                login(loginTextController.text,
                                    pwdTextController.text, mainWidgetContext)
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

  void changeColor(Color color) {
    setState(() {
      currentColor = color;
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
