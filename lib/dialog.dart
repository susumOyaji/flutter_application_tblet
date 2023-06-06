import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<dynamic>> data = [];

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Data List Example',
        home: Scaffold(
            appBar: AppBar(
              title:const Text('Data List Example'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    saveData();
                  },
                ),
              ],
            ),
            body: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.grey.shade800,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 56, 50, 50),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 800,
                        height: 50,
                        color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // ボタンが押された時の処理
                                setState(() {
                                  // TODO: ボタン1の処理
                                });
                              },
                              child: const Text('Button 1'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // ボタンが押された時の処理
                                setState(() {
                                  // TODO: ボタン2の処理
                                });
                              },
                              child: const Text('Button 2'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // ボタンが押された時の処理
                                setState(() {
                                  // TODO: ボタン3の処理
                                });
                              },
                              child: const Text('Button 3'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // ボタンが押された時の処理
                                setState(() {
                                  // TODO: ボタン3の処理
                                });
                              },
                              child: const Text('Button 4'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // ボタンが押された時の処理
                                setState(() {
                                  // TODO: ボタン3の処理
                                });
                              },
                              child: const Text('Button 5'),
                            ),
                            Container(
                              width: 150,
                              height: 50,
                              alignment: Alignment.center,
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: const InputDecoration(
                                  //hintText: '検索ワードを入力してください',
                                  labelText: 'Search',
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onSubmitted: (String value) async {
                                  //final results = await searchQiita("value");
                                  //setState(() => articles = results);
                                },
                              ),
                            )
                            // 検索ボックス
                            //Padding(
                            //padding: EdgeInsets.all(16.0),
                            //child: TextField(
                            //  onChanged: filterData,
                            //  decoration: InputDecoration(
                            //    labelText: 'Search',
                            //    prefixIcon: Icon(Icons.search),
                            //  ),
                            //),
                            //),
                          ],
                        ),
                      ),
                      Container(
                        width: 500,
                        height: 30,
                        color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // ボタンが押された時の処理
                                setState(() {
                                  //returnMap = _fetchStockTv("HiHi jets");
                                });
                              },
                              child: const Text('Hi 1'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // ボタンが押された時の処理
                                setState(() {
                                  //returnMap = _fetchStockTv("King&Prince");
                                });
                              },
                              child: const Text('KP 1'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // ボタンが押された時の処理
                                setState(() {
                                  //returnMap = _fetchStockTv("永瀬廉");
                                });
                              },
                              child: const Text('NA 1'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // ボタンが押された時の処理
                                setState(() {
                                  //returnMap = _fetchStockTv(idoldata[0][0]);
                                });
                              },
                              child: const Text('Hi 1'),
                            ),
                          ],
                        ),
                      ),
                    ]))));
  }
}

void main() {
  runApp(MyApp());
}
