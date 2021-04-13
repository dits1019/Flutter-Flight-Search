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
  //티켓에 내용이 들어가 있는 리스트
  List<FlightStopTicket> stops = [
    new FlightStopTicket("Sahara", "SHE", "Macao", "MAC", "SE2341"),
    new FlightStopTicket("Macao", "MAC", "Cape Verde", "CAP", "KU2342"),
    new FlightStopTicket("Cape Verde", "CAP", "Ireland", "IRE", "KR3452"),
    new FlightStopTicket("Ireland", "IRE", "Sahara", "SHE", "MR4321"),
  ];

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
  Iterable<Widget> _buildTickets() {
    return stops.map((stop) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: TicketCard(stop: stop),
      );
    });
  }

  //지문 버튼
  _buildFab() {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).pop(),
      child: new Icon(Icons.fingerprint),
    );
  }
}
