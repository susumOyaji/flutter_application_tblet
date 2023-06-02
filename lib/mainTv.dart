import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/http.dart';
//import 'package:html/parser.dart' as html;
import 'package:html/parser.dart' as parser;
//import 'dart:io';

void main() async {
  //main99();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //title: 'Stock Data',
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final formatter = NumberFormat('#,###');
  EdgeInsets stdmargin =
      const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0);

  Future<List<Map<String, dynamic>>>? returnMap;

  //String marktprice = "";
  //String inVestment = "";
  //String profit = "";
  //String marktpolarity = "";

  static List<List<dynamic>> idoldata = [
    ["HiHi jets", 200, 1665],
    ["King&Prince", 100, 1801],
    ["johnnys", 0, 0],
  ];

  Future<String> _fetchStd(String code) async {
    final url = code; //'https://finance.yahoo.co.jp/quote/$code.T';
    const backendUrl = 'http://localhost:3000'; // バックエンドのURL

    final uri = Uri.parse(backendUrl); // バックエンドのURLをURIオブジェクトに変換
    final response = await http.get(uri.replace(queryParameters: {'url': url}));
    if (response.statusCode == 200) {
      //print(response.body); // レスポンスのボディを出力
      return response.body; // レスポンスのボディを返す
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchStockTv(String idol) async {
    int count = 11;
    List<Map<String, dynamic>> dataList = [];

    String originalString = idol;
    String encodedString = Uri.encodeComponent(
        originalString); //URL内に特殊文字や予約語（＆等）が含まれる場合にエンコードする、その文字を安全に表現するための方法
    // テレビ番組のスケジュールを取得するURLを設定します。
    final url =
        'https://www.tvkingdom.jp/schedulesBySearch.action?stationPlatformId=0&condition.keyword=$encodedString&submit=%E6%A4%9C%E7%B4%A2'; //←ここに表示させたいURLを入力する
    //https://bangumi.org/search?q=HiHi+jets&area_code=23
    // URLから応答を取得します。
    //final tvresponse = await _fetchStd(url);
    //final tvbody = parser.parse(tvresponse);
    final uri = Uri.parse(url); // バックエンドのURLをURIオブジェクトに変換

    final tvresponse = await http.get(uri);

    final tvbody = parser.parse(tvresponse.body);

    final tvspanElements = tvbody.querySelectorAll('h2').toList();
    if (tvspanElements.length < count) {
      count = (tvspanElements.length) - 1;
    }

    final limitedElements = tvspanElements.sublist(0, count); // 最初のcount要素のみを取得

    final tvspanTexts =
        tvspanElements.map((spanElement) => spanElement.text).toList();

    String? nextText;
    String trimmedText;

    List<String> codeArray = [];
    int index = 0; // カウンタ変数

    for (final element in limitedElements) {
      final nextElement = element.nextElementSibling;
      if (nextElement != null) {
        nextText = nextElement.text;
        trimmedText = nextText.replaceAll('\n', '');
        codeArray = trimmedText.split(' ');

        Map<String, dynamic> mapString = {
          "Title": tvspanTexts[index],
          "Date": codeArray[0],
          "Day": codeArray[1],
          "StartTime": codeArray[2],
          "From": codeArray[3], // spanTexts[29],
          "EndTime": codeArray[4],
          "Airtime": codeArray[16],
          "Channels": codeArray[26],
          "Channels2": codeArray[27]
        };
        // オブジェクトをリストに追加
        dataList.add(mapString);
        index++; // インクリメント
      }
    }

    return dataList;
  }

  @override
  void initState() {
    super.initState();
    //_data = _fetchStockData();
    //_data = _fetchStockTv();
    returnMap = _fetchStockTv(idoldata[0][0]);
  }

  void _refreshData() {
    setState(() {
      print("_refreshData");
      returnMap = _fetchStockTv("HiHi jets");
    });
  }

  Container stackmarketView(String msg) => Container(
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
      child: Row(
        children: [
          ElevatedButton(
            style: const ButtonStyle(
              alignment: Alignment.centerLeft, // ボタン名を中央に配置
            ),
            onPressed: () {
              // ボタンが押された時の処理
              setState(() {
                returnMap = _fetchStockTv(idoldata[0][0]);
              });
            },
            child: const Text('Hi 1'),
          ),
          ElevatedButton(
            onPressed: () {
              // ボタンが押された時の処理
              setState(() {
                returnMap = _fetchStockTv(idoldata[1][0]);
              });
            },
            child: const Text('K&P 2'),
          ),
          ElevatedButton(
            onPressed: () {
              // ボタンが押された時の処理
              setState(() {
                returnMap = _fetchStockTv(idoldata[2][0]);
              });
            },
            child: const Text('Button 3'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(100, 50),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              "Reshio",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            onPressed: () => _refreshData(), //_opneUrl(),
          ),
          // 右端のアイコン
          // 追加のボタンをここに追記
        ],
      ));

  ListView listView(dynamic anystock) => ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: anystock.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.grey.shade800,
                  ],
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(children: <Widget>[
                Expanded(
                  flex: 0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //padding: const EdgeInsets.symmetric(
                      //    horizontal: 0, vertical: 0),
                      fixedSize: const Size(10, 10),
                      backgroundColor: Colors.purple, //ボタンの背景色
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      //runCommand();
                      //_asyncEditDialog(context, index);
                    },
                    onLongPress: () {
                      //alertDialog(index);
                    },
                    child: Text(index.toString(),
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontFamily: 'NotoSansJP',
                        )),
                  ),
                ),

                //SizedBox(width: 15.0,),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anystock[index]["Title"],
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          fontFamily: 'NoteSansJP',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            anystock[index]["Date"],
                            style: const TextStyle(
                                fontFamily: 'NotoSansJP',
                                fontSize: 15.0,
                                color: Colors.blue),
                          ),
                          Text(
                            anystock[index]["Day"],
                            style: const TextStyle(
                                fontFamily: 'NotoSansJP',
                                fontSize: 15.0,
                                color: Colors.blue),
                          ),
                          Text(
                            anystock[index]["StartTime"],
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.yellow),
                          ),
                          Text(
                            anystock[index]["From"],
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.yellow),
                          ),
                          Text(
                            anystock[index]["EndTime"],
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.yellow),
                          ),
                          Text(
                            anystock[index]["Airtime"],
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.orange),
                          ),
                          Text(
                            anystock[index]["Channels"],
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.red),
                          ),
                          Text(
                            anystock[index]["Channels2"],
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.orange),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //SizedBox(width: 50.0,),
              ])),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: returnMap,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            List<Map<String, dynamic>> stockDataList = snapshot.data!;
            return Stack(
              children: <Widget>[
                Container(
                  width: 800,
                  height: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
                  ),
                  child: Column(children: <Widget>[
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: stdmargin,
                      width: 750,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: stackmarketView("stdstock"),
                    ),
                    Container(
                      margin: stdmargin,
                      width: 750,
                      height: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: listView(stockDataList),
                    ),
                  ]),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
