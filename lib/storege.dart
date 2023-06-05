import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<dynamic>> dataList = [];

   static List<List<dynamic>> idoldata = [
    ["HiHi jets", 200, 1665],
    ["King&Prince", 100, 1801],
    ["johnnys", 0, 0],
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList('data');

    if (data != null) {
      setState(() {
        dataList = data.map((list) => List<dynamic>.from(idoldata[0][0])).toList();
      });
    }
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<List<String>> serializedData = dataList.map((list) => list.map((item) => item.toString()).toList()).toList();
    await prefs.setStringList('data', serializedData.map((list) => list.join(',')).toList());
  }

  void addData() {
    setState(() {
      dataList.add(['Item 1', 'Item 2', 'Item 3']);
    });
    saveData();
  }

  void removeData() {
    setState(() {
      dataList.removeLast();
    });
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPreferences Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: addData,
              child: Text('Add Data'),
            ),
            ElevatedButton(
              onPressed: removeData,
              child: Text('Remove Data'),
            ),
            DataTable(
              columns: List<DataColumn>.generate(
                dataList.isNotEmpty ? dataList[0].length : 0,
                (index) => DataColumn(label: Text('Column ${index + 1}')),
              ),
              rows: List<DataRow>.generate(
                dataList.length,
                (index) => DataRow(
                  cells: List<DataCell>.generate(
                    dataList[index].length,
                    (cellIndex) => DataCell(Text(dataList[index][cellIndex].toString())),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
