import 'package:flutter/material.dart';

//App Bar Widget
class AirAsiaBar extends StatelessWidget {
  //앱바의 높이는 매게 변수로(앱바의 높이가 변하기 때문에)
  final double? height;

  const AirAsiaBar({Key? key, this.height}) : super(key: key);

  //모든 뷰가 앱바 위에 그려지므로 Stack을 사용
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
              //그라데이션 추가
              gradient: new LinearGradient(
                  //위쪽 중앙에서 시작해서
                  begin: Alignment.topCenter,
                  //아래쪽 중앙에 끝
                  end: Alignment.bottomCenter,
                  //색깔은 빨간색과 #e64c85
                  colors: [Colors.red, const Color(0xffe64c85)])),
          //App Bar 높이
          height: height,
        ),
        new AppBar(
          //AppBar의 배경을 투명하게
          backgroundColor: Colors.transparent,
          //AppBar를 배치할 z좌표(가장 밑에)
          elevation: 0.0,
          //title을 중앙으로
          centerTitle: true,
          title: new Text('AirAsia',
              style: TextStyle(
                  fontFamily: 'AppTitleFont', fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
