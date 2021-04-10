import 'package:flutter/material.dart';

class PriceTab extends StatefulWidget {
  final double height;

  const PriceTab({Key key, this.height}) : super(key: key);

  @override
  _PriceTabState createState() => _PriceTabState();
}

//AnimationController를 만들 때는
class _PriceTabState extends State<PriceTab> with TickerProviderStateMixin {
  //비행기 아이콘 크기 조정 애니메이션
  AnimationController _planeSizeAnimationController;
  Animation _planeSizeAnimation;

  //비행기 아이콘 이동 애니메이션
  AnimationController _planeTravelController;
  Animation _planeTravelAnimation;

  //기본 비행기 아이콘 아래쪽 패딩
  final double _initialPlanePaddingBottom = 16.0;
  //비행기 아이콘의 최소 위쪽 패딩
  final double _minPlanePaddingTop = 16.0;

  //비행기 아이콘의 위쪽 패딩(애니메이션 후 아이콘이 위로 가기 때문에)
  double get _planeTopPadding =>
      _minPlanePaddingTop +
      (1 - _planeTravelAnimation.value) * _maxPlaneTopPadding;

  //비행기 아이콘 최대 위쪽 패딩
  double get _maxPlaneTopPadding =>
      widget.height - _initialPlanePaddingBottom - _planeSize;

  //비행기 크기
  double get _planeSize => _planeSizeAnimation.value;

  @override
  void initState() {
    super.initState();
    _initSizeAnimations();
    _initPlaneTravelAnimations();
    //forward : 앞으로 진행 <=> reverse
    _planeSizeAnimationController.forward();
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[_buildPlane()],
      ),
    );
  }

  Widget _buildPlane() {
    return AnimatedBuilder(
      animation: _planeTravelAnimation,
      child: Column(
        children: <Widget>[
          AnimatedPlaneIcon(animation: _planeSizeAnimation),
          //비행기가 지나간 자리에 남는 선
          Container(
            width: 2.0,
            height: 240.0,
            color: Color.fromARGB(255, 200, 200, 200),
          )
        ],
      ),
      //애니메이션 후 위치 유지
      builder: (context, child) =>
          Positioned(top: _planeTopPadding, child: child),
    );
  }

  //비행기 아이콘
  Widget _buildPlaneIcon() {
    return Icon(
      Icons.airplanemode_active,
      color: Colors.red,
      size: _planeSize,
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
          Future.delayed(Duration(milliseconds: 500),
              () => _planeTravelController.forward());
        }
      });
    _planeSizeAnimation =
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
}

//애니메이션이 추가된 비행기 아이콘(크기 애니메이션)
class AnimatedPlaneIcon extends AnimatedWidget {
  //animation을 받아오기
  AnimatedPlaneIcon({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    return Icon(
      Icons.airplanemode_active,
      color: Colors.red,
      size: animation.value,
    );
  }
}
