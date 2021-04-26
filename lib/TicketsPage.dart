import 'package:flight_search_ex/AppBar.dart';
import 'package:flight_search_ex/FlightStopTicket.dart';
import 'package:flight_search_ex/TicketCard.dart';
import 'package:flutter/material.dart';

//티켓들이 있는 페이지
class TicketsPage extends StatefulWidget {
  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage>
    with TickerProviderStateMixin {
  //애니메이션 컨트롤러
  late AnimationController cardEntranceAnimationController;
  //티켓 애니메이션
  late List<Animation> ticketAnimations;
  //지문 버튼 애니메이션
  late Animation fabAnimation;

  //티켓에 내용이 들어가 있는 리스트
  List<FlightStopTicket> stops = [
    new FlightStopTicket("Sahara", "SHE", "Macao", "MAC", "SE2341"),
    new FlightStopTicket("Macao", "MAC", "Cape Verde", "CAP", "KU2342"),
    new FlightStopTicket("Cape Verde", "CAP", "Ireland", "IRE", "KR3452"),
    new FlightStopTicket("Ireland", "IRE", "Sahara", "SHE", "MR4321"),
  ];

  //페이지가 시작함과 동시에 애니메이션 실행
  @override
  void initState() {
    super.initState();
    cardEntranceAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );
    ticketAnimations = stops.map((stop) {
      //stops의 내용 순서
      int index = stops.indexOf(stop);
      //curve 시작점
      double start = index * 0.1;
      //동작 시간
      double duration = 0.6;
      //curve 끝점
      double end = duration + start;
      //800부터 시작해 0.0까지 동작
      return new Tween<double>(begin: 800.0, end: 0.0).animate(
          new CurvedAnimation(
              parent: cardEntranceAnimationController,
              curve: new Interval(start, end, curve: Curves.decelerate)));
    }).toList(); //리스트로 형변환
    fabAnimation = new CurvedAnimation(
        parent: cardEntranceAnimationController,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate));
    //애니메이션 시작
    cardEntranceAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          AirAsiaBar(
            height: 180.0,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 64.0,
            child: SingleChildScrollView(
              child: new Column(
                children: _buildTickets().toList(),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //티켓 생성
  //Iterable은 반복이 가능한 집단을 말함(list, ,array등)
  Iterable<Widget> _buildTickets() {
    return stops.map((stop) {
      //stops의 내용 순서
      int index = stops.indexOf(stop);
      return AnimatedBuilder(
        animation: cardEntranceAnimationController,
        child: Padding(
          //수직과 수평으로만 패딩 추가
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: TicketCard(stop: stop),
        ),
        builder: (context, child) => new Transform.translate(
          //offset은 Transform을 통해 자식을 변환하는 위젯을 생성
          //0.0 ~ ticketAnimations[index].value까지 이동
          offset: Offset(0.0, ticketAnimations[index].value),
          child: child,
        ),
      );
    });
  }

  //지문 버튼
  _buildFab() {
    return ScaleTransition(
      scale: fabAnimation as Animation<double>,
      child: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => Navigator.of(context).pop(),
        child: new Icon(
          Icons.fingerprint,
        ),
      ),
    );
  }
}
