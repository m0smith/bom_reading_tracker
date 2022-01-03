import 'dart:convert';
import 'dart:io';
// import 'package:bom_reading_tracker/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'accordion.dart';
import 'personal_progress.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const MyApp myApp = MyApp();

//var books = List<String>.generate(15, (index) => "book${index + 1}");
const bookFontSize = 25.0;
final totalChapters =
    books.map((b) => b.chapters.length).reduce((acc, el) => acc + el);

var books = [
  Book('0', (c) => AppLocalizations.of(c)!.book1, 22),
  Book('1', (c) => AppLocalizations.of(c)!.book2, 33),
  Book('2', (c) => AppLocalizations.of(c)!.book3, 7),
  Book('3', (c) => AppLocalizations.of(c)!.book4, 1),
  Book('4', (c) => AppLocalizations.of(c)!.book5, 1),
  Book('5', (c) => AppLocalizations.of(c)!.book6, 1),
  Book('6', (c) => AppLocalizations.of(c)!.book7, 1),
  Book('7', (c) => AppLocalizations.of(c)!.book8, 29),
  Book('8', (c) => AppLocalizations.of(c)!.book9, 63),
  Book('9', (c) => AppLocalizations.of(c)!.book10, 16),
  Book('A', (c) => AppLocalizations.of(c)!.book11, 30),
  Book('B', (c) => AppLocalizations.of(c)!.book12, 1),
  Book('C', (c) => AppLocalizations.of(c)!.book13, 9),
  Book('D', (c) => AppLocalizations.of(c)!.book14, 15),
  Book('E', (c) => AppLocalizations.of(c)!.book15, 10),
];

void main() {
  runApp(myApp);
}

class UserChapter {
  String chapterId;
  bool read = false;
  DateTime lastUpdate;

  UserChapter(this.chapterId, this.read, this.lastUpdate);

  UserChapter.fromJson(Map<String, dynamic> json)
      : chapterId = json['chapterId'],
        read = json['read'],
        lastUpdate = DateTime.parse(json['lastUpdate']);

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'read': read,
        'lastUpdate': lastUpdate.toIso8601String(),
      };

  @override
  String toString() {
    return 'UserChapter{chapterId: $chapterId, read: $read, lastUpdate: $lastUpdate}';
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/user_progress.json');
}

Future<File> saveToLocalStorage(obj) async {
  //print("Saving $obj");
  String json = jsonEncode(obj);
  final file = await _localFile;

  // Write the file
  return file.writeAsString(json);

}

Future<Map<String,UserChapter>> readFromLocalStorage() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    var m = jsonDecode(contents);
    var m2 = m.map((k, v) => MapEntry<String, UserChapter>(k, UserChapter.fromJson(v)));
    final Map<String,UserChapter> rtnval = Map<String, UserChapter>.from(m2);
    return rtnval;
  } catch (e) {
    // If encountering an error, return {}
    return {};
  }
}

class Chapter {
  int number;
  Book book;
  String id;

  Chapter(this.book, this.number) : id = "${book.id}-$number";
}

class Book extends StatefulWidget {
  final String id;
  final Function title;
  final List<Chapter> chapters = [];

  Book(this.id, this.title, int chapterCount, {Key? key}) : super(key: key) {
    chapters.addAll(
        List.generate(chapterCount, (index) => Chapter(this, index + 1)));
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
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            MyApp.of(context)!.toggleChapterRead(chapter);

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
            MyApp.of(context)!.wasRead(chapter) ? Icons.check_box : Icons.check_box_outline_blank,
            size: 12.0),
        label: Text("${chapter.number}", style: const TextStyle(fontSize: 12)));
  }

  MaterialStateProperty<Color> getColor(Chapter? chapter, Color c1, Color c2) {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (MyApp.of(context)!.wasRead(chapter) || states.contains(MaterialState.pressed)) {
        return c2;
      } else {
        return c1;
      }
    });
  }

  getShape() {
    return MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) => const CircleBorder());
  }

  getSize() {
    return MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) => const Size(55.0, 55.0));
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
  String localeName = Intl.defaultLocale ?? 'en';
  final Map<String, UserChapter> _userProgress = <String, UserChapter>{};

  @override
  void initState() {
    super.initState();
    readFromLocalStorage().then((m) {
      //print(m);
      setState(() {
        _userProgress.clear();
        _userProgress.addAll(m);
      });
    });
  }

  void setLocaleName(String name) {
    setState(() {
      localeName = name;
    });
  }

  void toggleLocaleName() {
    if (localeName == 'en') {
      setLocaleName('es');
    } else {
      setLocaleName('en');
    }
  }

  Locale getLocale(){
    return Locale(localeName);
  }

  bool wasRead(Chapter? chapter) {
    if (chapter == null) return false;
    UserChapter? uc = _userProgress[chapter.id];
    if (uc != null) {
      return uc.read;
    } else {
      return false;
    }
  }
  Chapter toggleChapterRead(Chapter chapter)
  {
    UserChapter? uc = _userProgress[chapter.id];
    if (uc == null) {
    _userProgress.addAll(
    {chapter.id: UserChapter(chapter.id, true, DateTime.now())});
    } else {
      uc.read = ! uc.read;
    }
    saveToLocalStorage(_userProgress);
    return chapter;
  }
  int computeChaptersRead() {
    return _userProgress.values.where((element) => element.read).length;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: getLocale(),
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
  int _chaptersRead = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _chaptersRead = MyApp.of(context)!.computeChaptersRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Container(
        color: Colors.green,
        child: const Center(child: ReadingProgress()),
        constraints: const BoxConstraints.expand(),
      ),
      Container(
        color: Colors.white,
        child:
            Center(child: PersonalProgressChart(totalChapters, _chaptersRead)),
        constraints: const BoxConstraints.expand(),
      ),
      Container(
        color: Colors.green,
        child: const Center(child: Text("put them in the _widgetOption list")),
        constraints: const BoxConstraints.expand(),
      )
    ];
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.check),
            label: AppLocalizations.of(context)!.reading_progress,
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.pie_chart),
              label: AppLocalizations.of(context)!.personal_progress),
          BottomNavigationBarItem(
              icon: const Icon(Icons.multiline_chart),
              label: AppLocalizations.of(context)!.ward_progress),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[600],
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
