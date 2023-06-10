import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Stock Data',
      theme: ThemeData(
        canvasColor: const Color.fromARGB(255, 10, 10, 10), // ベースカラーを変更する
      ),
      home: const _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyHomePage> {
  List<String> buttonNames =
      List.generate(10, (index) => 'Button ${index + 1}');
  bool isNameChanged = false;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  late List<Map<String, dynamic>> newData;

  List<Map<String, dynamic>> dataList = [
    {'Id': 1, 'DisplayWord': 'HiHi jets', 'SearchWord': 'HiHijets'},
    {'Id': 2, 'DisplayWord': 'HiHi jets', 'SearchWord': 'HiHijets'},
    {'Id': 3, 'DisplayWord': 'HiHi jets', 'SearchWord': 'HiHijets'},
  ];

  @override
  void initState() {
    super.initState();
    //saveData();
    loadData();
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(dataList);
    await prefs.setString('dataList', encodedData);
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('dataList');
    if (encodedData != null) {
      List<dynamic> decodedData = jsonDecode(encodedData);

      setState(() {
        dataList = decodedData.cast<Map<String, dynamic>>();
      });
    }
  }

  void addData1() {
    setState(() {
      dataList.add({'name': 'New Person', 'age': 20});
      saveData();
    });
  }

  Future<void> addData(Map<String, dynamic> newData) async {
    //List<List<dynamic>> data = await loadData();

    // IDの重複チェック
    bool isDuplicateId = false;
    int newId = newData["Id"] as int;
    for (Map<String, dynamic> existingData in dataList) {
      int existingId = existingData["Id"] as int;
      if (existingId == newId) {
        isDuplicateId = true;
        break;
      }
    }

    if (!isDuplicateId) {
      // 新しいデータを追加
      dataList.add(newData);

      // IDで昇順ソート
      dataList.sort((a, b) => (a["Id"] as int).compareTo(b["Id"] as int));

      await saveData();
      print('Data added and sorted successfully.');
    } else {
      print(
          'Data with the same ID already exists. Duplicate registration prevented.');
    }
  }

  void removeData(int index) {
    setState(() {
      dataList.removeAt(index);
      saveData();
    });
  }

  Future<void> deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove data for the 'data' key.
    await prefs.remove('dataList');
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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                String enteredText = _textEditingController.text;
                String enteredText2 = _textEditingController2.text;
                // TODO: 入力されたテキストの処理
                print('ButtonName: $enteredText');
                print('Entered Text 2: $enteredText2');

                setState(() {
                  newData = [
                    {
                      'Id': 1,
                      'DisplayWord': 'HiHi jets',
                      'SearchWord': 'HiHijets'
                    },
                  ];

                  //data.add(newData);
                });
                saveData(); // データを保存
                //addData([buttonIndex, enteredText,  enteredText2]);
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
    return MaterialApp(
      title: 'Shared Preferences Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shared Preferences Example'),
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0), // 余白を追加する場合は適宜調整してください
                child: Column(
                  children: List.generate(2, (rowIndex) {
                    return Row(
                      children: List.generate(5, (columnIndex) {
                        final index = rowIndex * 5 + columnIndex;
                        return Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              handleButtonLongPress(index);
                              /*
                                    setState(() {
                                      if (isNameChanged &&
                                          index < data.length) {
                                        // 新たな名前に変更
                                        buttonNames[index] = data[index][1];
                                      } else {
                                        // 初期値に戻す
                                        buttonNames[index] =
                                            'Button ${index + 1}';
                                      }
                                      isNameChanged =
                                          !isNameChanged; // true to false or false to true
                                    });
                                    */
                            },
                            child: Text(dataList.length > index
                                ? dataList[index]["DisplayWord"]
                                : buttonNames[index]),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
              const Text('Load Data:'),
              for (var item in dataList) Text(item.toString()),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    addData({
                      "Id": dataList.length + 1,
                      'DisplayWord': 'Text 1',
                      'SearchWord': 'Text 2'
                    });
                  });
                },
                child: const Text('Add Data'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    deleteData();
                    //removeData(data.length);
                  });
                },
                child: const Text('Remove All Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
