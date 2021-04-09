import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final bool selected;
  final GestureTapCallback onTap;

  const RoundedButton({Key key, this.text, this.selected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //선택했을 때와 하지 않았을 때의 backgroundColor와 textColor
    Color backgroundColor = selected ? Colors.white : Colors.transparent;
    Color textColor = selected ? Colors.red : Colors.white;

    //공간을 모두 차지하게 함
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: new InkWell(
          onTap: onTap,
          child: new Container(
            height: 36.0,
            decoration: new BoxDecoration(
                //Button BackgroundColor
                color: backgroundColor,
                //Button Border
                border: new Border.all(color: Colors.white, width: 1.0),
                //Button 모서리 둥글게
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Center(
              child: new Text(
                text,
                style: new TextStyle(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
