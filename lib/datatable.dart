import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String>? savedData = [];
  //final List<List<dynamic>> data = [
  //  ['John', 25, 'USA'],
  //  ['Emily', 30, 'Canada'],
  //  ['David', 28, 'Australia'],
  //  ['Sophia', 27, 'France'],
  //];

  List<List<dynamic>> data = [];
  //  ["HiHi jets", 200, 1665],
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
    savedData = prefs.getStringList('data');

    if (savedData != null) {
      setState(() {
        data.clear();
        for (var item in savedData!) {
          data.add(item.split(','));
        }
      });
    } else {
      print("Your search Keyword not registered");
    }
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //List<String> savedData = [];
    for (var item in data) {
      savedData!.add(item.join(','));
    }
    await prefs.setStringList('data', savedData!);
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
    print('Button $buttonIndex was Longpressed');
    // ここにボタンが押されたときの処理を追加する
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data List Example',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Data List Example'),
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
          ),
          body: Column(
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
          )),
    );
  }
}

void main() {
  runApp(MyApp());
}
