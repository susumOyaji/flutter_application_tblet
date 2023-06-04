import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchKeyword = '';

  void search() {
    // 検索処理を実行する
    print('Search keyword: $searchKeyword');
    // TODO: 検索結果の更新などの処理を追加する
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search App'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  search();
                },
                child: const Text('検索'),
              ),
              ElevatedButton(
                onPressed: () {
                  search();
                },
                child: const Text('検索'),
              ),
              ElevatedButton(
                onPressed: () {
                  search();
                },
                child: const Text('検索'),
              ),
              ElevatedButton(
                onPressed: () {
                  search();
                },
                child: const Text('検索'),
              ),
              ElevatedButton(
                onPressed: () {
                  search();
                },
                child: const Text('検索'),
              ),
              //Expanded(
                //child:
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
                ),
              //),
            ],
          ),
          Expanded(
            child: Container(
                // 検索結果などのコンテンツを表示するコンテナ
                // TODO: コンテンツの表示を実装する

                ),
          ),
        ],
      ),
    );
  }
}
