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
      {Key? key, required this.flightStop, required this.isLeft})
      : super(key: key);

  @override
  FlightStopCardState createState() => FlightStopCardState();
}

class FlightStopCardState extends State<FlightStopCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  //카드 크기 애니메이션
  late Animation<double> _cardSizeAnimation;
  //텍스트 위치 애니메이션
  late Animation<double> _durationPositionAnimation;
  late Animation<double> _airportsPositionAnimation;
  late Animation<double> _datePositionAnimation;
  late Animation<double> _pricePositionAnimation;
  late Animation<double> _fromToPositionAnimation;
  //연결선 애니메이션
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    //애니메이션 추가
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));
    _cardSizeAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.0, 0.9, curve: new ElasticOutCurve(0.8)));
    _durationPositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.05, 0.95, curve: new ElasticOutCurve(0.95)));
    _airportsPositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.1, 1.0, curve: new ElasticOutCurve(0.95)));
    _datePositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.1, 0.8, curve: new ElasticOutCurve(0.95)));
    _pricePositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.0, 0.9, curve: new ElasticOutCurve(0.95)));
    _fromToPositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.1, 0.95, curve: new ElasticOutCurve(0.95)));
    _lineAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.0, 0.2, curve: Curves.linear));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  //애니메이션 실행
  void runAnimation() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FlightStopCard.height,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => new Stack(
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
      ),
    );
  }

  //최대 가로 길이
  double get maxWidth {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    //제약 조건 생성(renderBox.constraints = 가장)
    BoxConstraints? constraints = renderBox?.constraints;
    double maxWidth = constraints?.maxWidth ?? 0.0;
    return maxWidth;
  }

  //올라온 지 얼마나 됬는지 알려주는 지연 시간
  Positioned buildDurationText() {
    //애니메이션의 현재값
    double animationValue = _durationPositionAnimation.value;
    return Positioned(
      //수직 위치 애니메이션
      top: getMarginTop(animationValue),
      //수평 위치 애니메이션
      right: getMarginRight(animationValue),
      child: Text(
        widget.flightStop.duration,
        style: new TextStyle(
          fontSize: 10.0 * animationValue,
          color: Colors.grey,
        ),
      ),
    );
  }

  //공항 이름
  Positioned buildAirportNamesText() {
    double animationValue = _airportsPositionAnimation.value;
    return Positioned(
      top: getMarginTop(animationValue),
      left: getMarginLeft(animationValue),
      child: Text(
        '${widget.flightStop.from} \u00B7 ${widget.flightStop.to}',
        style: new TextStyle(
          fontSize: 14.0 * animationValue,
          color: Colors.grey,
        ),
      ),
    );
  }

  //날짜
  Positioned buildDateText() {
    double animationValue = _datePositionAnimation.value;
    return Positioned(
      left: getMarginLeft(animationValue),
      child: Text(
        widget.flightStop.date,
        style: new TextStyle(
          fontSize: 14.0 * animationValue,
          color: Colors.grey,
        ),
      ),
    );
  }

  //가격
  Positioned buildPriceText() {
    double animationValue = _pricePositionAnimation.value;
    return Positioned(
      right: getMarginRight(animationValue),
      child: Text(
        widget.flightStop.price,
        style: new TextStyle(
          fontSize: 16.0 * animationValue,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //이동하는 시간
  Positioned buildFromToTimeText() {
    double animationValue = _fromToPositionAnimation.value;
    return Positioned(
      left: getMarginLeft(animationValue),
      bottom: getMarginBottom(animationValue),
      child: Text(
        widget.flightStop.fromToTime,
        style: new TextStyle(
          fontSize: 12.0 * animationValue,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  //점과 연결된 선
  Widget buildLine() {
    double animationValue = _lineAnimation.value;
    double maxLength = maxWidth - FlightStopCard.width;
    return Align(
        alignment: widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          height: 2.0,
          //가로 선 애니메이션
          width: maxLength * animationValue,
          color: Color.fromARGB(255, 200, 200, 200),
        ));
  }

  //카드 생성
  Positioned buildCard() {
    double animationValue = _cardSizeAnimation.value;
    double minOuterMargin = 8.0;
    double outerMargin = minOuterMargin + (1 - animationValue) * maxWidth;
    return Positioned(
      //카드를 어느 쪽에 생성할 지(생성 안하는 방향은 null처리)
      right: widget.isLeft ? null : outerMargin,
      left: widget.isLeft ? outerMargin : null,
      //크기 애니메이션
      child: Transform.scale(
        scale: animationValue,
        child: Container(
          width: 140.0,
          height: 80.0,
          child: new Card(
            color: Colors.grey.shade100,
          ),
        ),
      ),
    );
  }

  //아래쪽 마진
  double getMarginBottom(double animationValue) {
    double minBottomMargin = 8.0;
    double bottomMargin =
        minBottomMargin + (1 - animationValue) * minBottomMargin;
    return bottomMargin;
  }

  //위쪽 마진
  double getMarginTop(double animationValue) {
    double minMarginTop = 8.0;
    double marginTop =
        minMarginTop + (1 - animationValue) * FlightStopCard.height * 0.5;
    return marginTop;
  }

  //왼쪽 마진
  double getMarginLeft(double animationValue) {
    return getMarginHorizontal(animationValue, true);
  }

  //오른쪽 마진
  double getMarginRight(double animationValue) {
    return getMarginHorizontal(animationValue, false);
  }

  //가로 마진
  double getMarginHorizontal(double animationValue, bool isTextLeft) {
    //카드를 왼쪽에 생성
    if (isTextLeft == widget.isLeft) {
      double minHorizontalMargin = 16.0;
      double maxHorizontalMargin = maxWidth - minHorizontalMargin;
      double horizontalMargin =
          minHorizontalMargin + (1 - animationValue) * maxHorizontalMargin;
      return horizontalMargin;
    }
    //카드를 오른쪽에 생성
    else {
      double maxHorizontalMargin = maxWidth - FlightStopCard.width;
      double horizontalMargin = animationValue * maxHorizontalMargin;
      return horizontalMargin;
    }
  }
}
