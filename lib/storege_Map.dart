import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}






class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> dataList = [
    {'Id': 1, 'DisplayWord': 'HiHi jets','SearchWord':'HiHijets'},
    {'Id': 2, 'DisplayWord': 'HiHi jets','SearchWord':'HiHijets'},
    {'Id': 3, 'DisplayWord': 'HiHi jets','SearchWord':'HiHijets'},
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
    await prefs.setString('data', encodedData);
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('data');
    if (encodedData != null) {
      List<dynamic> decodedData = jsonDecode(encodedData);
      setState(() {
        dataList = decodedData.cast<Map<String, dynamic>>();
      });
    }
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  //handleButtonLongPress(index);
                  /*  
                  setState(() {
                    if (isNameChanged && index < data.length) {
                      // 新たな名前に変更
                      buttonNames[index] = data[index][1];
                    } else {
                      // 初期値に戻す
                      buttonNames[index] = 'Button ${index + 1}';
                    }
                    isNameChanged =
                        !isNameChanged; // true to false or false to true
                  });
                  */
                },
                child: Text('buttonNames[index]'),
              ),
              const Text('Load Data:'),
              for (var item in dataList) Text(item.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
