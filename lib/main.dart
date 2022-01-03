import 'package:bom_reading_tracker/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'accordian.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const MyApp myApp = MyApp();

//var books = List<String>.generate(15, (index) => "book${index + 1}");
const bookFontSize = 25.0;

var books = [
  Book((c) => AppLocalizations.of(c)!.book1, 22),
  Book((c) => AppLocalizations.of(c)!.book2, 33),
  Book((c) => AppLocalizations.of(c)!.book3, 7),
  Book((c) => AppLocalizations.of(c)!.book4, 1),
  Book((c) => AppLocalizations.of(c)!.book5, 1),
  Book((c) => AppLocalizations.of(c)!.book6, 1),
  Book((c) => AppLocalizations.of(c)!.book7, 1),
  Book((c) => AppLocalizations.of(c)!.book8, 29),
  Book((c) => AppLocalizations.of(c)!.book9, 63),
  Book((c) => AppLocalizations.of(c)!.book10, 16),
  Book((c) => AppLocalizations.of(c)!.book11, 30),
  Book((c) => AppLocalizations.of(c)!.book12, 1),
  Book((c) => AppLocalizations.of(c)!.book13, 9),
  Book((c) => AppLocalizations.of(c)!.book14, 15),
  Book((c) => AppLocalizations.of(c)!.book15, 10),
];

void main() {
  runApp(myApp);
}

class Chapter {
  bool read = false;
  int number;

  Chapter(this.number);
}

class Book extends StatefulWidget {
  final Function title;
  final List<Chapter> chapters = [];

  Book(this.title, int chapterCount, {Key? key}) : super(key: key) {
    chapters.addAll(List.generate(chapterCount, (index) => Chapter(index + 1)));
  }

  @override
  _BookState createState() => _BookState();

  static _BookState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BookState>();
}

class _BookState extends State<Book> {
  @override
  Widget build(BuildContext context) {
    //print(widget.title);
    // String s = "${widget.chapters}";
    List<Widget> children = widget.chapters.map(newChapterButton).toList();
    return Accordion(
        widget.title(context),
        Wrap(
          children: children,
        ));
  }

  ElevatedButton newChapterButton(chapter) {
    Chapter chap = chapter;
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            chapter.read = !chapter.read;
          });
        },
        style: ButtonStyle(
          fixedSize: getSize(),
          overlayColor: getColor(null, Colors.grey, Colors.green),
          backgroundColor: getColor(chapter, Colors.grey, Colors.greenAccent),
          shape: getShape(),
          // padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 1.0)
        ),
        icon: Icon(
            chapter.read ? Icons.check_box : Icons.check_box_outline_blank,
            size: 12.0),
        label: Text("${chapter.number}", style: TextStyle(fontSize: 12)));
  }

  MaterialStateProperty<Color> getColor(Chapter? chapter, Color c1, Color c2) {
    final getColor = (Set<MaterialState> states) {
      if ((chapter != null && chapter.read) ||
          states.contains(MaterialState.pressed)) {
        return c2;
      } else {
        return c1;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }

  getShape() {
    final getShape = (Set<MaterialState> states) => CircleBorder();
    return MaterialStateProperty.resolveWith(getShape);
  }

  getSize() {
    final getSize = (Set<MaterialState> states) => Size(55.0, 55.0);
    return MaterialStateProperty.resolveWith(getSize);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  String localeName = 'es';

  void setLocaleName(String name) {
    setState(() {
      localeName = name;
    });
  }

  void toggleLocaleName() {
    if (localeName == 'es') {
      setLocaleName('en');
    } else {
      setLocaleName('es');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(localeName),
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      title: 'RISE 2022',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyPages(title: "appTitle"),
    );
  }
}

class MyPages extends StatefulWidget {
  const MyPages({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyPages> createState() => _MyPagesState();
}

class _MyPagesState extends State<MyPages> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Container(
      color: Colors.green,
      child: Center(child: ReadingProgress()),
      constraints: BoxConstraints.expand(),
    ),
    Container(
      color: Colors.green,
      child: Center(child: Text("you just have to build them and...")),
      constraints: BoxConstraints.expand(),
    ),
    Container(
      color: Colors.green,
      child: Center(child: Text("put them in the _widgetOption list")),
      constraints: BoxConstraints.expand(),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.public),
            onPressed: () {
              setState(() {
                MyApp.of(context)!.toggleLocaleName();
              });
            },
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            title: Text("Reading Progress"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), title: Text("Personal Progress")),
          BottomNavigationBarItem(
              icon: Icon(Icons.multiline_chart), title: Text("Ward Progress")),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ReadingProgress extends StatelessWidget {
  const ReadingProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
          //padding: const EdgeInsets.all(8),
          children: books),
    );
  }
}
