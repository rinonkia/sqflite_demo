import 'package:flutter/material.dart';
import 'package:sqflite_demo/db/input_text_repository.dart';
import 'package:sqflite_demo/model/input_text.dart';

void main() {
  runApp(MyApp());
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
                  builder: (BuildContext context) => ListPage(),
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

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: InputTextRepository.getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Text('loading...');
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("Text List")),
      body: futureBuilder,
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<InputText> inputTextList = snapshot.data;
    return new ListView.builder(
      itemCount: inputTextList.length,
      itemBuilder: (BuildContext context, int index) {
        InputText inputText = inputTextList[index];
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(inputText.getBody),
              subtitle: Text(inputText.getUpdatedAt.toString()),
              onTap: () {
                final draftBody = inputText.getBody;
                InputTextRepository.delete(inputText.getId);
                Navigator.of(context).pop(draftBody);
              },
              onLongPress: () => showDialog(
                context: context,
                builder: (context) {
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
                          setState(() {
                            InputTextRepository.delete(inputText.id);
                            print('deleted');
                            Navigator.of(context).pop();
                          });
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
                },
              ),
            ),
            Divider(height: 1.0),
          ],
        );
      },
    );
  }
}

class EditTextPage extends StatefulWidget {
  EditTextPage({Key key, this.inputText}) : super(key: key);

  final InputText inputText;
  @override
  _EditTextPageState createState() => _EditTextPageState();
}

class _EditTextPageState extends State<EditTextPage> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.inputText.getBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("edit text page")),
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
              onPressed: () => {
                InputTextRepository.update(
                  id: widget.inputText.getId,
                  text: _textController.text,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
