import 'dart:ui';

import 'package:flight_search_ex/MultiCityInput.dart';
import 'package:flight_search_ex/PriceTab.dart';
import 'package:flutter/material.dart';

//카드
class ContentCard extends StatefulWidget {
  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool showInput = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: DefaultTabController(
        length: 3,
        child: new LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Column(
            children: <Widget>[
              _buildTabBar(),
              _buildContentContainer(viewportConstraints)
            ],
          );
        }),
      ),
    );
  }

  //TabBar
  Widget _buildTabBar({bool showFirstOption}) {
    return Stack(
      children: <Widget>[
        new Positioned.fill(
          top: null,
          child: new Container(
            height: 2.0,
            color: new Color(0xffeeeeee),
          ),
        ),
        new TabBar(
          tabs: [Tab(text: "Flight"), Tab(text: "Train"), Tab(text: 'Bus')],
          labelColor: Colors.black,
          //선택되지 않은 라베의 색깔
          unselectedLabelColor: Colors.grey,
          //아래선(indicator) 색깔
          indicatorColor: Colors.red,
        )
      ],
    );
  }

//Content
  Widget _buildContentContainer(BoxConstraints viewportConstraints) {
    return Expanded(
      child: SingleChildScrollView(
        //자식에게 제약을 걸어줌
        child: new ConstrainedBox(
          constraints: new BoxConstraints(
            //최소 높이 설정
            minHeight: viewportConstraints.maxHeight - 48.0,
          ),
          //자식의 고유 높이에 맞게 자식 크기를 조정
          child: new IntrinsicHeight(
            //화면 전환
            child: showInput
                ? _buildMulticityTab()
                : PriceTab(height: viewportConstraints.maxHeight - 48.0),
          ),
        ),
      ),
    );
  }

//Tab 아래 Content
  Widget _buildMulticityTab() {
    return Column(
      children: <Widget>[
        MulticityInput(),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            //클릭 시 showInput을 false로
            onPressed: () => setState(() => showInput = false),
            child: Icon(
              Icons.timeline,
              size: 36.0,
            ),
          ),
        ),
      ],
    );
  }
}
