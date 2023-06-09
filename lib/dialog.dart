import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  //List<List<dynamic>> data = [];
  Future<List<List<dynamic>>>? data;
  /*
   List<List<dynamic>> data = [
    [1, 1, 2],
    [1, 2, 3],
  ];
  */
  //List<List<dynamic>> data=[];
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    data = loadData();
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

 Future<List<List<dynamic>>> loadData1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('data');
    if (encodedData != null) {
      return List<List<dynamic>>.from(json.decode(encodedData));
    } else {
      return [];
    }
  }








  Future<List<List<dynamic>>> loadData2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('data');
    if (encodedData != null) {
      List<dynamic> decodedData = json.decode(encodedData);
      
      //List<dynamic> decodedData = List<dynamic>.from(
      //  encodedData.substring(1, encodedData.length - 1).split(', '),
      //);
      List<List<dynamic>> data = decodedData.cast<List<dynamic>>();
      return data;
    } else {
      return [];
    }
  }

  Future<void> loadData3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('data');
    if (encodedData != null) {
       //setState(() {
       // data = List<List<dynamic>>.from(json.decode(encodedData));
      //});
        //data = decodedData.cast<List<dynamic>>();
      };
    //}
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', data.toString());
  }

  /*
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('data');
    if (encodedData != null) {
      List<dynamic> decodedData = json.decode(encodedData);
      setState(() {
        //data = json.decode(encodedData);
        data = decodedData.cast<List<dynamic>>();
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
  */

  Future<void> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove data for the 'data' key.
    await prefs.remove('data');
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
                  //data.add(newData);
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
          title: const Text('Data List Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                saveData();
              },
            ),
          ],
        ),
        body: Center(
            child: FutureBuilder<List<List<dynamic>>>(
                future: loadData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  List<List<dynamic>> stockDataList = snapshot.data!;
                  var stdstock = stockDataList;
                  //var anystock = stockDataList.sublist(2);
                  // stockDataList の表示
                  //for (var stockData in stockDataList) {
                    //print(stockDataList[0][0]);
                    //print(stockDataList[1][2]);
                   
                    //print(stockData);
                  //}
                  return Stack(children: <Widget>[
                    Container(
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
                                          //print(data[0][0]);
                                        });
                                      },
                                      onLongPress: () {
                                        // 長押し時の処理
                                        handleButtonLongPress(1);
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
                                      child: Text(
                                          data == null ? "uknone" : 'Button 2'),
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
                                          removeData();
                                        });
                                      },
                                      child: const Text('removeData 5'),
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
                            ]))
                  ]);
                })));
  }
}

void main() {
  runApp(MyApp());
}
