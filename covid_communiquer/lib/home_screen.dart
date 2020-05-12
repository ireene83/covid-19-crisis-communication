import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covid_communiquer/bloc/authentication_bloc.dart';


class HomeScreen extends StatefulWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override 
  _HomeScreen createState() => new _HomeScreen(name: name);
}

class _HomeScreen extends State<HomeScreen> {
  final String name;
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  _HomeScreen(
    {@ required this.name}
  );

  Widget _buildTextComposer () {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).accentColor
      ),
      child: new Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: "Send a message",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 6.0
            ),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          )
        ],
      ),
    );
  }

  void response(query) async {
    
    ChatMessage message = ChatMessage(
      text: "Sample Response",
      name: "Bot",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage (
      text: text,
      name: this.name,
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    response(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 2.0,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final String name;
  final bool type;

  ChatMessage({this.text, this.name, this.type});

  List<Widget> otherMessage (context) {
    return <Widget>[
      Container(
        margin: EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          child: Text('B'),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.name,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            Container(
              margin: EdgeInsets.only(),
              child: Text(text),
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> myMessage (context) {
    return <Widget> [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              this.name,
              style: Theme.of(context).textTheme.subhead,
            ),
            Container(
              margin: EdgeInsets.only(
                top: 5.0
              ),
              child: Text(text),
            )
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          child: Text(
            this.name[0],
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      )
    ];
  }

  @override
  Widget build (BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}