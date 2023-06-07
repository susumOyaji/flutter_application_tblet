import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  @override
  void initState() {
    super.initState();
    //deleteData();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared Preferences Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shared Preferences Example'),
        ),
        body: FutureBuilder<List<List<dynamic>>>(
          future: loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<List<dynamic>> data = snapshot.data!;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            addData([data.length + 1, 'Text 1', 'Text 2']);
                          },
                          child:
                              Text(data[0][1] == "" ? 'Button 1' : data[0][1]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addData([data.length + 1, 'Text 1', 'Text 2']);
                          },
                          child: Text(data[1][1] == "" ? 'Button 2' : data[1][1]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addData([data.length + 1, 'Text 1', 'Text 2']);
                          },
                          child: Text(data[3][1] == "" ? 'Button 3' : data[3][1]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addData([data.length + 1, 'Text 1', 'Text 2']);
                          },
                          child: const Text('Button 3'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addData([data.length + 1, 'Text 1', 'Text 2']);
                          },
                          child: const Text('Button 4'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addData([data.length + 1, 'Text 1', 'Text 2']);
                          },
                          child: const Text('Button 5'),
                        ),
                      ],
                    ),
                    const Text('Saved Data:'),
                    for (var item in data) Text(item.toString()),
                    ElevatedButton(
                      onPressed: () {
                        addData([data.length + 1, 'Text 1', 'Text 2']);
                      },
                      child: const Text('Add Data'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        removeData(data.length);
                      },
                      child: const Text('Remove Last Data'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<List<dynamic>>> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('data');
    if (encodedData != null) {
      List<dynamic> decodedData = json.decode(encodedData);
      if (decodedData is List &&
          decodedData.isNotEmpty &&
          decodedData.first is List) {
        return List<List<dynamic>>.from(decodedData);
      }
    }
    return [];
  }

  Future<void> saveData(List<List<dynamic>> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(data);
    await prefs.setString('data', encodedData);
  }

  Future<void> addData1(List<dynamic> newData) async {
    List<List<dynamic>> data = await loadData();
    data.add(newData);
    await saveData(data);
  }

  Future<void> addData(List<dynamic> newData) async {
    List<List<dynamic>> data = await loadData();

    // IDの重複チェック
    bool isDuplicateId = false;
    int newId = newData[0] as int;
    for (List<dynamic> existingData in data) {
      int existingId = existingData[0] as int;
      if (existingId == newId) {
        isDuplicateId = true;
        break;
      }
    }

    if (!isDuplicateId) {
      // 新しいデータを追加
      data.add(newData);

      // IDで昇順ソート
      data.sort((a, b) => (a[0] as int).compareTo(b[0] as int));

      await saveData(data);
      print('Data added and sorted successfully.');
    } else {
      print(
          'Data with the same ID already exists. Duplicate registration prevented.');
    }
  }

  Future<void> removeData(int index) async {
    List<List<dynamic>> data = await loadData();
    if (index >= 0 && index < data.length) {
      data.removeAt(index);
      await saveData(data);
    }
  }

  Future<void> deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove data for the 'data' key.
    await prefs.remove('data');
  }
}
