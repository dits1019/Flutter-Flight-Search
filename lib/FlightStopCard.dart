import 'package:flight_search_ex/FlightStop.dart';
import 'package:flutter/material.dart';

//항공편 안내 카드
class FlightStopCard extends StatefulWidget {
  final FlightStop flightStop;
  //카드가 어느 쪽에 생성될 지
  final bool isLeft;
  static const double height = 80.0;
  static const double width = 140.0;

  const FlightStopCard(
      {Key key, @required this.flightStop, @required this.isLeft})
      : super(key: key);

  @override
  FlightStopCardState createState() => FlightStopCardState();
}

class FlightStopCardState extends State<FlightStopCard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: FlightStopCard.height,
      child: new Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          buildLine(),
          buildCard(),
          buildDurationText(),
          buildAirportNamesText(),
          buildDateText(),
          buildPriceText(),
          buildFromToTimeText(),
        ],
      ),
    );
  }

  //최대 가로 길이
  double get maxWidth {
    RenderBox renderBox = context.findRenderObject();
    //제약 조건 생성(renderBox.constraints = 가장)
    BoxConstraints constraints = renderBox?.constraints;
    double maxWidth = constraints?.maxWidth ?? 0.0;
    return maxWidth;
  }

  //올라온 지 얼마나 됬는지 알려주는 지연 시간
  Positioned buildDurationText() {
    return Positioned(
      top: getMarginTop(),
      right: getMarginRight(),
      child: Text(
        widget.flightStop.duration,
        style: new TextStyle(
          fontSize: 10.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  //공항 이름
  Positioned buildAirportNamesText() {
    return Positioned(
      top: getMarginTop(),
      left: getMarginLeft(),
      child: Text(
        "${widget.flightStop.from} \u00B7 ${widget.flightStop.to}",
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  //날짜
  Positioned buildDateText() {
    return Positioned(
      left: getMarginLeft(),
      child: Text(
        "${widget.flightStop.date}",
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  //가격
  Positioned buildPriceText() {
    return Positioned(
      right: getMarginRight(),
      child: Text(
        "${widget.flightStop.price}",
        style: new TextStyle(
            fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  //이동하는 시간
  Positioned buildFromToTimeText() {
    return Positioned(
      left: getMarginLeft(),
      bottom: getMarginBottom(),
      child: Text(
        "${widget.flightStop.fromToTime}",
        style: new TextStyle(
            fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.w500),
      ),
    );
  }

  //점과 연결된 선
  Widget buildLine() {
    double maxLength = maxWidth - FlightStopCard.width;
    return Align(
        alignment: widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          height: 2.0,
          width: maxLength,
          color: Color.fromARGB(255, 200, 200, 200),
        ));
  }

  //카드 생성
  Positioned buildCard() {
    double outerMargin = 8.0;
    return Positioned(
      //카드를 어느 쪽에 생성할 지(생성 안하는 방향은 null처리)
      right: widget.isLeft ? null : outerMargin,
      left: widget.isLeft ? outerMargin : null,
      child: Container(
        width: 140.0,
        height: 80.0,
        child: new Card(
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  //아래쪽 마진
  double getMarginBottom() {
    double minBottomMargin = 8.0;
    return minBottomMargin;
  }

  //위쪽 마진
  double getMarginTop() {
    double minMarginTop = 8.0;
    return minMarginTop;
  }

  //왼쪽 마진
  double getMarginLeft() {
    return getMarginHorizontal(true);
  }

  //오른쪽 마진
  double getMarginRight() {
    return getMarginHorizontal(false);
  }

  //가로 마진
  double getMarginHorizontal(bool isTextLeft) {
    //카드를 왼쪽에 생성
    if (isTextLeft == widget.isLeft) {
      double minHorizontalMargin = 16.0;
      return minHorizontalMargin;
    }
    //카드를 오른쪽에 생성
    else {
      double maxHorizontalMargin = maxWidth - FlightStopCard.width;
      return maxHorizontalMargin;
    }
  }
}
