import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_application_tblet/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();

  List<List<dynamic>> savedData = [];
  //final List<List<dynamic>> data = [
  //  ['John', 25, 'USA'],
  //  ['Emily', 30, 'Canada'],
  //  ['David', 28, 'Australia'],
  //  ['Sophia', 27, 'France'],
  //];

  List<List<dynamic>> data = []; //ButtonIndex,ButtonName,SearchWard,Potion
  //  ["1,HiHi jets", "HiHi jets", 1665],
  //  ["King&Prince", 100, 1801],
  //  ["johnnys", 0, 0],
  //];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('data');
    if (encodedData != null) {
      List<dynamic> decodedData = json.decode(encodedData);
      setState(() {
        //data = json.decode(encodedData);
        data = [decodedData.cast<dynamic>()];
      });
      print(data);
    } else {
      print("Your search Keyword not registered");
    }
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(data);
    await prefs.setString('data', encodedData);
  }

  Future<void> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove data for the 'data' key.
    await prefs.remove('data');
  }

  void handleButtonPress(int buttonIndex) {
    print('Button $buttonIndex was pressed');
    // ここにボタンが押されたときの処理を追加する
  }

  handleButtonLongPress(buttonIndex) {
    //ButtonName and SearchWard 登録
    print('Button $buttonIndex was Longpressed');
    // ここにボタンが押されたときの処理を追加する
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Button $buttonIndex was Longpressed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(hintText: 'ButtonName'),
              ),
              TextField(
                controller: _textEditingController2,
                decoration: const InputDecoration(hintText: 'SearchWard'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                String enteredText = _textEditingController.text;
                String enteredText2 = _textEditingController2.text;
                // TODO: 入力されたテキストの処理
                print('ButtonName: $enteredText');
                print('Entered Text 2: $enteredText2');

                setState(() {
                  List<dynamic> newData = [
                    buttonIndex,
                    enteredText,
                    enteredText2
                  ];
                  data.add(newData);
                });
                saveData(); // データを保存
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
        title: Text('Data List Example'),
        /*
            actions: [
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  saveData();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  removeData();
                },
              ),
            ],
            */
      ),
      body: Center(
        child: Column(
          children: List.generate(2, (rowIndex) {
            return Row(
              children: List.generate(5, (colIndex) {
                final buttonIndex = rowIndex * 5 + colIndex + 1;

                return Padding(
                  padding: EdgeInsets.all(8.0), // ボタンの配置間隔を調整
                  child: SizedBox(
                    width: 100, // ボタンの幅を指定
                    height: 50, // ボタンの高さを指定
                    child: ElevatedButton(
                      onPressed: () {
                        // ボタンが押されたときの処理
                        handleButtonPress(buttonIndex);
                      },
                      onLongPress: () {
                        // 長押し時の処理
                        handleButtonLongPress(buttonIndex);
                      },
                      child: Text('Button ${rowIndex * 5 + colIndex + 1}'),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}
