import 'package:flight_search_ex/AppBar.dart';
import 'package:flight_search_ex/ContentCard.dart';
import 'package:flight_search_ex/RoundedButton.dart';
import 'package:flutter/material.dart';

// Main Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        AirAsiaBar(height: 210.0),
        //Stack 안에서  Positioned를 이용해 위치 설정
        //Positioned.fill을 써서 Stack안을 채움
        Positioned.fill(
          child: Padding(
            padding: new EdgeInsets.only(
                //MediaQuery로 반응형으로 만듬
                top: MediaQuery.of(context).padding.top + 40.0),
            child: new Column(
              children: <Widget>[
                _buildButtonRow(),
                Expanded(child: ContentCard()),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

Widget _buildButtonRow() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: <Widget>[
        new RoundedButton(text: 'ONE WAY', selected: false),
        new RoundedButton(text: 'ROUND', selected: false),
        new RoundedButton(text: 'MULTICITY', selected: true)
      ],
    ),
  );
}
