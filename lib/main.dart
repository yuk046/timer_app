import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timer_app/add_page.dart';
import 'firebase_options.dart';
import 'package:timer_app/user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '誕生日リスト'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<User> users = [];

  @override
  void initState(){
    super.initState();

    _fetcFirebaseData();
  }

  void _fetcFirebaseData() async{
    final db = FirebaseFirestore.instance;

    final event = await db.collection("users").get();
    final docs = event.docs;
    final users = docs.map((doc) => User.fromFirestore(doc)).toList();

    setState(() {
        // thisはグローバル
        this.users = users;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: users
        .map((user) => ListTile(
          title: Text(user.first),
          subtitle: Text(user.last),
          trailing: Text(user.born.toString()),

          onTap:(){
            showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Year"),
          content: Container(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
            
              selectedDate: DateTime(int.parse(user.born)),
              onChanged: (DateTime dateTime) {            
                FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.id)
                      .update({
                        'born': dateTime.year
                        });
                Navigator.pop(context);

                _fetcFirebaseData();
            
              },
            ),
          ),
        );
      },
    );
          },

          onLongPress: () async{
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("削除"),
                    content: Text("このリストデータを削除しますか？"),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text("OK"),
                        onPressed: () async {
                          final db = FirebaseFirestore.instance;
                          await db.collection("users").doc(user.id).delete();
                          _fetcFirebaseData();
                          Navigator.pop(context); // ダイアログを閉じる
                        },
                      ),
                    ],
                  );
                },
              );
            _fetcFirebaseData();
          },
          )).toList(),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddPage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _goToAddPage()async{
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPage()),
    );
    _fetcFirebaseData();
  }
}
