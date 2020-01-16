import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';

const String RANDOM_USER_ENDPOINT = 'https://randomuser.me/api/?results=100&nat=us&inc=gender,name,nat,picture';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('People Name Generator'),
        ),
        body: Center(
          child: RandomWords(),
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  Future<List<User>> _users;
  final _biggerTitle = const TextStyle(fontSize: 20.0);
  final _biggerSubtitle = const TextStyle(fontSize: 16.0);

  Future<List<User>> fetchUsers() async {
    final response =
    await http.get(RANDOM_USER_ENDPOINT);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      List responseData = json.decode(response.body)['results'];
      return responseData.map((user) => User.fromJson(user)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    _users = fetchUsers();
  }

  Widget _buildRow(User user) {
    return ListTile(
      leading: Image.network(user.photo),
      title: Text(
        user.name,
        style: _biggerTitle,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Gender: ${user.gender}",
            style: _biggerSubtitle,
          ),
          Text(
            "Nat: ${user.nat}",
            style: _biggerSubtitle,
          )
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
//    return ListView.builder(
//        padding: const EdgeInsets.all(16.0),
//        itemCount: _suggestions.length,
//        itemBuilder: /*1*/ (context, i) {
//          if (i.isOdd) return Divider();
//
//          return _buildRow(_suggestions[i]);
//        });

    return FutureBuilder<List<User>>(
      future: _users,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data.length,
              itemBuilder: /*1*/ (ctx, i) {
                if (i.isOdd) return Divider();

                return _buildRow(snapshot.data[i]);
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}
