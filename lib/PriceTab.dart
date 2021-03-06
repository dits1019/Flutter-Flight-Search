import 'package:flight_search_ex/AnimatedDot.dart';
import 'package:flight_search_ex/FlightStop.dart';
import 'package:flight_search_ex/FlightStopCard.dart';
import 'package:flight_search_ex/TicketsPage.dart';
import 'package:flutter/material.dart';

class PriceTab extends StatefulWidget {
  final double? height;
  final VoidCallback? onPlaneFlightStart;

  const PriceTab({Key? key, this.height, this.onPlaneFlightStart})
      : super(key: key);

  @override
  _PriceTabState createState() => _PriceTabState();
}

//AnimationController를 만들 때는
class _PriceTabState extends State<PriceTab> with TickerProviderStateMixin {
  //비행기 아이콘 크기 조정 애니메이션
  late AnimationController _planeSizeAnimationController;
  late Animation _planeSizeAnimation;

  //비행기 아이콘 이동 애니메이션
  late AnimationController _planeTravelController;
  late Animation _planeTravelAnimation;

  //항공편 카드 애니메이션
  late AnimationController _fabAnimationController;
  late Animation _fabAnimation;

  //점 애니메이션
  late AnimationController _dotsAnimationController;
  //애니메이션이 담겨져있는 배열
  List<Animation<double>> _dotPositions = [];

  //기본 비행기 아이콘 아래쪽 패딩
  final double _initialPlanePaddingBottom = 16.0;
  //비행기 아이콘의 최소 위쪽 패딩
  final double _minPlanePaddingTop = 16.0;

  //항공편 카드의 내용이 들어간 리스트
  final List<FlightStop> _flightStops = [
    FlightStop("JFK", "ORY", "JUN 05", "6h 25m", "\$851", "9:26 am - 3:43 pm"),
    FlightStop("MRG", "FTB", "JUN 20", "6h 25m", "\$532", "9:26 am - 3:43 pm"),
    FlightStop("ERT", "TVS", "JUN 20", "6h 25m", "\$718", "9:26 am - 3:43 pm"),
    FlightStop("KKR", "RTY", "JUN 20", "6h 25m", "\$663", "9:26 am - 3:43 pm"),
  ];

  //카드의 key들이 있는 리스트
  final List<GlobalKey<FlightStopCardState>> _stopKeys = [];

  //비행기 아이콘의 위쪽 패딩(애니메이션 후 아이콘이 위로 가기 때문에)
  double get _planeTopPadding =>
      _minPlanePaddingTop +
      (1 - _planeTravelAnimation.value) * _maxPlaneTopPadding;

  //비행기 아이콘 최대 위쪽 패딩
  double get _maxPlaneTopPadding =>
      widget.height! -
      _minPlanePaddingTop -
      _initialPlanePaddingBottom -
      _planeSize;

  //비행기 크기
  double get _planeSize => _planeSizeAnimation.value;

  final double _cardHeight = 80.0;

  //위젯이 생성될 때 처음으로 호출
  @override
  void initState() {
    super.initState();
    _initSizeAnimations();
    _initPlaneTravelAnimations();
    _initDotAnimationController();
    _initDotAnimations();
    _initFabAnimationController();
    //foreach로 키 리스트에 키 추가
    _flightStops
        .forEach((stop) => _stopKeys.add(new GlobalKey<FlightStopCardState>()));
    _planeSizeAnimationController.forward();
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    _planeTravelController.dispose();
    _dotsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[_buildPlane()]
          ..addAll(_flightStops.map(_buildStopCard))
          ..addAll(_flightStops.map(_mapFlightStopToDot))
          ..add(_buildFab()),
      ),
    );
  }

  //비행기 아이콘

  //애니메이션이 추가된 비행기 아이콘
  Widget _buildPlane() {
    return AnimatedBuilder(
      animation: _planeTravelAnimation,
      child: Column(
        children: <Widget>[
          AnimatedPlaneIcon(animation: _planeSizeAnimation as Animation<double>),
          //비행기가 지나간 자리에 남는 선
          Container(
            width: 2.0,
            height: _flightStops.length * _cardHeight * 0.8,
            color: Color.fromARGB(255, 200, 200, 200),
          )
        ],
      ),
      //애니메이션 후 위치 유지
      builder: (context, child) =>
          Positioned(top: _planeTopPadding, child: child!),
    );
  }

  //아이콘 크기 조정 애니메이션(아이콘이 작아짐)
  _initSizeAnimations() {
    _planeSizeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 340),
      vsync: this,
    )..addStatusListener((status) {
        //크기가 작아지는 애니메이션이 끝난 후
        if (status == AnimationStatus.completed) {
          //0.5초 후 이동 애니메이션 시작
          Future.delayed(Duration(milliseconds: 500), () {
            // widget?.onPlaneFlightStart();
            //애니메이션 처음으로
            _planeTravelController.forward();
          });
          Future.delayed(Duration(milliseconds: 700), () {
            //애니메이션 처음으로
            _dotsAnimationController.forward();
          });
        }
      });
    _planeSizeAnimation =
        //60에서 시작해서 36에서 끝남
        Tween<double>(begin: 60.0, end: 36.0).animate(CurvedAnimation(
      parent: _planeSizeAnimationController,
      curve: Curves.easeOut,
    ));
  }

  //아이콘 이동 애니메이션
  _initPlaneTravelAnimations() {
    _planeTravelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    //애니메이션에 curve 추가
    _planeTravelAnimation = CurvedAnimation(
      parent: _planeTravelController,
      curve: Curves.fastOutSlowIn,
    );
  }

  //점 설정
  Widget _mapFlightStopToDot(stop) {
    //list에서 stop을 찾고 그 자릿값을 index에 넣음
    int index = _flightStops.indexOf(stop);
    //index가 0이거나 마지막이면 true
    bool isStartOrEnd = index == 0 || index == _flightStops.length - 1;
    //구분을 위해 중간과 양 끝 색깔을 다르게 함
    Color color = isStartOrEnd ? Colors.red : Colors.green;
    return AnimatedDot(
      //애니메이션 배열에 있는 애니메이션을 차례대로 부여
      animation: _dotPositions[index],
      color: color,
    );
  }

  //점 이동 애니메이션
  void _initDotAnimations() {
    //점들 간에 간격
    final double slideDurationInterval = 0.4;
    //점들 간에 애니메이션 속도 간격(차례대로 올라오게 하기 위해)
    final double slideDelayInterval = 0.2;
    //시작했을 때 위쪽 마진(화면 맨아래)
    double? startingMarginTop = widget.height;
    //최소 위쪽 마진
    double minMarginTop =
        _minPlanePaddingTop + _planeSize + 0.5 * (0.8 * _cardHeight);

    for (int i = 0; i < _flightStops.length; i++) {
      //curve를 위한 변수
      final start = slideDelayInterval * i;
      final end = start + slideDurationInterval;

      //마지막 위쪽 마진
      double finalMarginTop = minMarginTop + i * (0.8 * _cardHeight);

      Animation<double> animation = new Tween(
        //startingMarginTop에서 finalMarginTop까지 움직임
        begin: startingMarginTop,
        end: finalMarginTop,
      ).animate(
        //애니메이션에 curve 추가
        new CurvedAnimation(
          parent: _dotsAnimationController,
          //interval로 curve 설정
          curve: new Interval(start, end, curve: Curves.easeOut),
        ),
      );
      //애니메이션을 배열에 추가
      _dotPositions.add(animation);
    }
  }

  //점 애니메이션 컨트롤러
  void _initDotAnimationController() {
    _dotsAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500))
      ..addStatusListener((status) {
        //항공편 카드 애니메이션이 끝난 후
        if (status == AnimationStatus.completed) {
          //체크 버튼 애니메이션 실행
          _animateFlightStopCards().then((_) => _animateFab());
        }
      });
  }

  //항공편 카드 생성
  Widget _buildStopCard(FlightStop stop) {
    //자릿값
    int index = _flightStops.indexOf(stop);
    //위쪽 마진
    double topMargin = _dotPositions[index].value -
        0.5 * (FlightStopCard.height - AnimatedDot.size);
    bool isLeft = index.isOdd;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: topMargin),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //각 방향에 카드 생성
            isLeft ? Container() : Expanded(child: Container()),
            Expanded(
              child: FlightStopCard(
                //key 추가
                key: _stopKeys[index],
                flightStop: stop,
                isLeft: isLeft,
              ),
            ),
            !isLeft ? Container() : Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  //체크표시 버튼
  Widget _buildFab() {
    return Positioned(
      bottom: 16.0,
      child: ScaleTransition(
        scale: _fabAnimation as Animation<double>,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          //버튼 클릭 시 티켓 페이지로 이동
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TicketsPage()));
          },
          child: Icon(Icons.check, size: 36.0),
        ),
      ),
    );
  }

  //항공편 카드 애니메이션(Future로 비동기 처리)
  Future _animateFlightStopCards() async {
    //항공편 카드의 키 리스트(_stopKeys)에서 각각의 값을 가지고 애니메이션 수행
    return Future.forEach(_stopKeys, (GlobalKey<FlightStopCardState> stopKey) {
      //시간 간격을 두고 애니메이션 실행
      return new Future.delayed(Duration(milliseconds: 250), () {
        stopKey.currentState!.runAnimation();
      });
    });
  }

  //체크 버튼 애니메이션 컨트롤러
  void _initFabAnimationController() {
    _fabAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    _fabAnimation = new CurvedAnimation(
        parent: _fabAnimationController, curve: Curves.easeOut);
  }

  //체크 버튼 애니메이션 실행
  _animateFab() {
    _fabAnimationController.forward();
  }
}

//애니메이션이 추가된 비행기 아이콘(크기 애니메이션)
class AnimatedPlaneIcon extends AnimatedWidget {
  //animation을 받아오기
  AnimatedPlaneIcon({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable as Animation<double>;
    return Icon(
      Icons.airplanemode_active,
      color: Colors.red,
      size: animation.value,
    );
  }
}
