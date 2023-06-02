//import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:html/parser.dart' as parser;

void main() async {
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
  final formatter = NumberFormat('#,###');
  EdgeInsets stdmargin =
      const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0);

  Future<List<Map<String, dynamic>>>? returnMap;

  static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 100, 1801],
    ["3436", 0, 0],
  ];

  Future<List<Map<String, dynamic>>> webfetch() async {
    List<Map<String, dynamic>> dataList = [];
    const djiurl = 'https://finance.yahoo.co.jp/quote/%5EDJI';
    //final djiresponse = await _fetchStd(djiurl);

    final uri = Uri.parse(djiurl); // バックエンドのURLをURIオブジェクトに変換
    final djiresponse = await http.get(uri);
    final djibody = parser.parse(djiresponse.body);

    final djispanElements = djibody.querySelectorAll('span');
    final djispanTexts =
        djispanElements.map((spanElement) => spanElement.text).toList();

    String djifirstChar = djispanTexts[23].substring(0, 1);
    String djipolarity = djifirstChar == '-' ? '-' : '+';

    Map<String, dynamic> djimapString = {
      "Code": "^DJI",
      "Name": "^DJI",
      "Price": djispanTexts[18],
      "Reshio": djispanTexts[25],
      "Percent": djispanTexts[28],
      "Polarity": djipolarity,
      "Banefits": "Unused",
      "Evaluation": "Unused"
    };
    // オブジェクトをリストに追加
    dataList.add(djimapString);

    const nkurl = 'https://finance.yahoo.co.jp/quote/998407.O';

    //final nkresponse = await _fetchStd(nkurl);
    final nkuri = Uri.parse(nkurl); // バックエンドのURLをURIオブジェクトに変換
    final nkresponse = await http.get(nkuri);
    final nkbody = parser.parse(nkresponse.body);

    final nkspanElements = nkbody.querySelectorAll('span');
    final nkspanTexts =
        nkspanElements.map((spanElement) => spanElement.text).toList();

    String nkfirstChar = nkspanTexts[23].substring(0, 1);
    String nkpolarity = nkfirstChar == '-' ? '-' : '+';

    Map<String, dynamic> nkmapString = {
      "Code": "NIKKEI",
      "Name": "NIKKEI",
      "Price": nkspanTexts[18],
      "Reshio": nkspanTexts[25],
      "Percent": nkspanTexts[28],
      "Polarity": nkpolarity,
      "Banefits": "Unused",
      "Evaluation": "Unused"
    };
    // オブジェクトをリストに追加
    dataList.add(nkmapString);

    for (int i = 0; i < data.length; i++) {
      final anyurl = 'https://finance.yahoo.co.jp/quote/${data[i][0]}.T';
      //final bodyresponse = await _fetchStd(url);

      final anyuri = Uri.parse(anyurl); // バックエンドのURLをURIオブジェクトに変換
      final anyresponse = await http.get(anyuri);

      final body = parser.parse(anyresponse.body);
      final h1Elements = body.querySelectorAll('h1');
      final h1Texts = h1Elements.map((h1Element) => h1Element.text).toList();

      final spanElements = body.querySelectorAll('span');
      final spanTexts =
          spanElements.map((spanElement) => spanElement.text).toList();

      // <dd>タグの3階層下にある<span>タグを検出 Reshio
      final ddTags = body.querySelectorAll('dd');
      final ddElements = ddTags.map((ddElement) => ddElement.text).toList();
      int delimiterIndex = ddElements[0].indexOf("(");
      final ddElement = ddElements[0].substring(0, delimiterIndex);

      String anyfirstChar = spanTexts[29].substring(0, 1);
      String anypolarity = anyfirstChar == '-' ? '-' : '+';

      int intHolding = data[i][1];

      int intPrice = spanTexts[21] == '---'
          ? 0
          : int.parse(spanTexts[21].replaceAll(',', ''));

      num banefits = intPrice - data[i][2];
      String bBanefits = formatter.format(banefits); //banefits.toString();

      int evaluation = intHolding * intPrice;
      String eEvaluation =
          formatter.format(evaluation); //evaluation.toString();

      Map<String, dynamic> mapString = {
        "Code": spanTexts[24],
        "Name": h1Texts[1],
        "Price": spanTexts[21],
        "Reshio": ddElement, // spanTexts[29],
        "Percent": spanTexts[31],
        "Polarity": anypolarity,
        "Banefits": bBanefits,
        "Evaluation": eEvaluation
      };

      // オブジェクトをリストに追加
      dataList.add(mapString);
      //print(dataList);
    }
    return dataList;
  }

  Map<String, String> getAsset(List<Map<String, dynamic>> anystock) {
    num intinvestment = 0; //投資額
    int intEvaluation = 0;
    final formatter = NumberFormat('#,###');

    for (var i = 0; i < anystock.length; i++) {
      intinvestment = intinvestment + (data[i][1] * data[i][2]);
    }

    String investment = formatter.format(intinvestment);

    for (int i = 0; i < anystock.length; i++) {
      intEvaluation = intEvaluation +
          int.parse(anystock[i]['Evaluation']!.replaceAll(',', ''));
    }
    String evaluation = formatter.format(intEvaluation);
    String profit = formatter.format(intEvaluation - intinvestment);
    String polarity = (intEvaluation - intinvestment) >= 0 ? "+" : "-";

    Map<String, String> mapString = {
      "Market": evaluation,
      "Invest": investment,
      "Profit": profit,
      "Polarity": polarity,
    };

    return mapString;
  }

  @override
  void initState() {
    super.initState();

    returnMap = webfetch();
  }

  void _refreshData() {
    setState(() {
      print("_refreshData");
      returnMap = webfetch();
    });
  }

  Container stackmarketView(stdstock) => Container(
      padding: const EdgeInsets.only(top: 10.0),
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
      child: Row(children: [
        const Icon(
          Icons.trending_up,
          size: 60,
          color: Colors.grey,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: <Widget>[
              CircleAvatar(
                maxRadius: 5.0,
                backgroundColor:
                    stdstock[0]['Polarity'] == '+' ? Colors.red : Colors.green,
              ),
              const Text(
                "Dow Price: \$ ",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w900,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${stdstock[0]['Price']}',
                      style: const TextStyle(
                        fontSize: 15.0, //fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w900,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            children: <Widget>[
              const SizedBox(width: 10),
              const Text(
                "          The day before ratio: \$ ",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w900,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${stdstock[0]['Reshio'] + "   " + stdstock[0]["Percent"]}',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: stdstock[0]["Polarity"] == '+'
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(height: 10),

          Row(
            children: <Widget>[
              CircleAvatar(
                maxRadius: 5.0,
                backgroundColor:
                    stdstock[1]["Polarity"] == '+' ? Colors.red : Colors.green,
              ),
              const Text(
                "Nikkey Price: ￥ ",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w900,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${stdstock[1]["Price"]}',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w900,
                        color: Colors.blueAccent, //fontWeight: FontWeight.bold,
                      ),
                      //style: TextStyle(fontSize: 12.0,//fontWeight: FontWeight.bold,
                      //),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(children: <Widget>[
            const SizedBox(width: 10),
            const Text(
              "          The day before ratio: ￥ ",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w900,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${stdstock[1]["Reshio"] + "  " + stdstock[1]["Percent"]}',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: stdstock[1]["Polarity"] == '+'
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ]),
      ]));

  Container stackAssetView(asset) => Container(
      padding: const EdgeInsets.only(top: 5.0),
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
      child: Row(children: [
        const Icon(
          Icons.currency_yen,
          size: 60,
          color: Colors.grey,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(
                text: 'Market capitalization',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 5.0,
                  backgroundColor: asset["Polarity"] == "+"
                      ? Colors.orange
                      : Colors.green, //Colors.green,
                ),
                const Text(
                  "Market price: ", //"Gain or loss",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${asset["Market"]}',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: asset["Polarity"] == "+"
                              ? Colors.orange
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                const Text(
                  "Profit(Gains)", //"Gain or loss", //"Market price",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "￥",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      TextSpan(
                        text: '${asset["Profit"]}',
                        style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Investment",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "￥",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      TextSpan(
                        text: '${asset["Invest"]}',
                        style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ]));

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
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      fixedSize: const Size(50, 50),
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
                    child: Text("${anystock[index]['Code']}",
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontFamily: 'NotoSansJP',
                        )),
                  ),
                ),

                //  ]
                // ),

                //SizedBox(width: 15.0,),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${anystock[index]["Name"]}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                          //fontFamily: 'NoteSansJP',
                          //fontWeight: FontWeight.bold,
                        ),
                        strutStyle: const StrutStyle(
                          fontSize: 10.0,
                          height: 1.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Market: ${anystock[index]["Price"]}",
                              style: const TextStyle(
                                  fontFamily: 'NotoSansJP',
                                  fontSize: 17.0,
                                  color: Colors.blue),
                              textAlign: TextAlign.left),
                          Text(
                            "Benefits: ${anystock[index]["Banefits"]}",
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: Colors.yellow),
                          ),
                        ],
                      ),
                      Text(
                        "Evaluation: ${anystock[index]["Evaluation"]}",
                        style: const TextStyle(
                            fontFamily: 'NoteSansJP',
                            //fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.orange),
                      ),
                    ],
                  ),
                ),
                //SizedBox(width: 50.0,),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, right: 0.0, bottom: 0.0, left: 0.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 50),
                        backgroundColor: anystock[index]["Polarity"] == '+'
                            ? Colors.red
                            : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        anystock[index]["Reshio"],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onPressed: () => _refreshData(), //_opneUrl(),
                    ), // 右端のアイコン
                  ),
                ),
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

            var stdstock = stockDataList;
            var anystock = stockDataList.sublist(2);
            var asset = getAsset(anystock);
            return Stack(
              children: <Widget>[
                Container(
                  width: 650,
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
                      width: 500,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: stackmarketView(stdstock),
                    ),
                    Container(
                      margin: stdmargin,
                      width: 500,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: stackAssetView(asset),
                    ),
                    Container(
                      margin: stdmargin,
                      width: 500,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: listView(anystock),
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
