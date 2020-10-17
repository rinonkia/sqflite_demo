import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_demo/db/input_text_repository.dart';
import 'package:sqflite_demo/model/input_text.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TextData()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqflte'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () async {
              var draft = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => TextListScreen(),
                ),
              );
              if (draft != null) {
                setState(() => _textController.text = draft);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            TextFormField(
              controller: _textController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter text';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                filled: true,
                labelText: 'input',
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('送信'),
              onPressed: () {
                InputTextRepository.create(_textController.text);
                _textController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TextListScreen extends StatelessWidget {
  const TextListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('AAAAAAA');
    return Scaffold(
      appBar: AppBar(title: Text("Text List")),
      body: TextList(),
    );
  }
}

class TextList extends StatelessWidget {
  const TextList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('IIIIIIIII');
    return ListView.builder(
      itemCount: InputTextRepository.getCount(),
      itemBuilder: (BuildContext context, int index) {
        print('UUUUUUUU');
        return FutureProvider<InputText>(
          create: (context) => InputTextRepository.getAll().then((value) => value[index]),
          initialData: null,
          child: Consumer<InputText>(builder: (context, value, child) => _testList(context)),
        );
      }
    );
  }

  Widget _testList(BuildContext context) {
    final inputText = Provider.of<InputText>(context);
    return ListTile(
      title: Text(inputText.getBody),
      onTap: () {
        final draftBody = inputText.getBody;
        InputTextRepository.delete(inputText.getId);
        Navigator.of(context).pop(draftBody);
      },
      onLongPress: () =>
        showDialog(context: context, builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.grey,
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  final draftBody = inputText.getBody;
                  InputTextRepository.delete(inputText.getId);
                  // MyHomePageにtextを持っていく（力技っぽい）
                  Navigator.of(context).pop(draftBody);
                  Navigator.of(context).pop(draftBody);
                },
                child: Text(
                  "編集する",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {

                  InputTextRepository.delete(inputText.id);
                  print('deleted');
                  Navigator.of(context).pop();
                },
                child: Text(
                  "削除する",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

class TextData with ChangeNotifier {
  final _texts = <InputText>[];

  List<InputText> get texts => _texts;

  int get textsCount => _texts.length;


  InputText getText(int index) {
    return _texts[index];
  }

  void removeText(int index) {
    _texts.removeAt(index);
    notifyListeners();
  }
}
