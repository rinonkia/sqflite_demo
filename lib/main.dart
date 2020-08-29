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
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqflte'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => ListPage()),
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'input',
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('送信'),
              onPressed: () => {
                InputTextRepository.create(_textController.text),
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
              onTap: () => {},
              onLongPress: () => showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    backgroundColor: Colors.grey,
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context),
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
