import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../model/person.dart';
import 'package:poseshot/src/model/body_point_extension.dart';

class AnimatedArmsPainter extends StatefulWidget {
  const AnimatedArmsPainter({
    super.key,
    required this.person,
    required this.widgetWidth,
    required this.widgetHeight,
    required this.colorIndex,
  });

  final Person person;
  final double widgetWidth;
  final double widgetHeight;
  final int colorIndex;

  @override
  State<AnimatedArmsPainter> createState() => _AnimatedArmsPainterState();
}

class _AnimatedArmsPainterState extends State<AnimatedArmsPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

// nose, lefteye, righteye, leftear, rightear, leftshoulder, rightshoulder, leftelbow, rightelbow, leftwrist, rightwrist, lefthip, righthip, leftknee, rightknee, leftankle, rightankle

  Animation<Offset>? _leftShoulder;
  Animation<Offset>? _rightShoulder;
  Animation<Offset>? _leftWrist;
  Animation<Offset>? _rightWrist;
  Animation<Offset>? _leftElbow;
  Animation<Offset>? _rightElbow;

  late Offset? curLeftShoulder;
  late Offset? curRightShoulder;
  late Offset? curLeftWrist;
  late Offset? curRightWrist;
  late Offset? curLeftElbow;
  late Offset? curRightElbow;

  Offset? endLeftShoulder;
  Offset? endRightShoulder;
  Offset? endLeftWrist;
  Offset? endRightWrist;
  Offset? endLeftElbow;
  Offset? endRightElbow;

  @override
  void initState() {
    super.initState();

    curLeftShoulder = widget.person.leftshoulder
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightShoulder = widget.person.rightshoulder
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);

    curLeftWrist = widget.person.leftwrist
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightWrist = widget.person.rightwrist
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curLeftElbow = widget.person.leftelbow
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightElbow = widget.person.rightelbow
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // 원하는 Curve를 설정할 수 있습니다.
    );

    _controller.addListener(() {
      setState(() {
        curLeftShoulder = _leftShoulder?.value;
        curRightShoulder = _rightShoulder?.value;

        curLeftWrist = _leftWrist?.value;
        curRightWrist = _rightWrist?.value;
        curLeftElbow = _leftElbow?.value;
        curRightElbow = _rightElbow?.value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedArmsPainter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.person.boundingBox != widget.person.boundingBox) {
      if (widget.person.leftshoulder != null) {
        _leftShoulder = Tween<Offset>(
                begin: curLeftShoulder ??
                    widget.person.leftshoulder?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.leftshoulder
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }
      if (widget.person.rightshoulder != null) {
        _rightShoulder = Tween<Offset>(
                begin: curRightShoulder ??
                    widget.person.rightshoulder?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.rightshoulder
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.leftwrist != null) {
        _leftWrist = Tween<Offset>(
                begin: curLeftWrist ??
                    widget.person.leftwrist?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.leftwrist
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.rightwrist != null) {
        _rightWrist = Tween<Offset>(
                begin: curRightWrist ??
                    widget.person.rightwrist?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.rightwrist
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.leftelbow != null) {
        _leftElbow = Tween<Offset>(
                begin: curLeftElbow ??
                    widget.person.leftelbow?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.leftelbow
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.rightelbow != null) {
        _rightElbow = Tween<Offset>(
                begin: curRightElbow ??
                    widget.person.rightelbow?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.rightelbow
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ArmsPainter(
        leftShoulder: curLeftShoulder,
        rightShoulder: curRightShoulder,
        leftWrist: curLeftWrist,
        rightWrist: curRightWrist,
        leftElbow: curLeftElbow,
        rightElbow: curRightElbow,
        colorIndex: widget.colorIndex,
      ),
    );
  }
}

class ArmsPainter extends CustomPainter {
  ArmsPainter(
      {required this.leftShoulder,
      required this.rightShoulder,
      required this.leftWrist,
      required this.rightWrist,
      required this.leftElbow,
      required this.rightElbow,
      required this.colorIndex});

  final Offset? leftShoulder;
  final Offset? rightShoulder;

  final Offset? leftWrist;
  final Offset? rightWrist;
  final Offset? leftElbow;
  final Offset? rightElbow;

  final int colorIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    switch (colorIndex) {
      // case 10까지 색 배정
      case 0:
        paint.color = Colors.red;
        break;
      case 1:
        paint.color = Colors.blue;
        break;
      case 2:
        paint.color = Colors.green;
        break;
      case 3:
        paint.color = Colors.yellow;
        break;
      case 4:
        paint.color = Colors.purple;
        break;
      case 5:
        paint.color = Colors.orange;
        break;
      case 6:
        paint.color = Colors.pink;
        break;
      case 7:
        paint.color = Colors.teal;
        break;
      case 8:
        paint.color = Colors.indigo;
        break;
      case 9:
        paint.color = Colors.amber;
        break;
      case 10:
        paint.color = Colors.cyan;
        break;
    }

    final leftArmPath = Path();
    if (leftShoulder != null && leftElbow != null) {
      leftArmPath.moveTo(leftShoulder!.dx, leftShoulder!.dy);
      leftArmPath.arcToPoint(leftElbow!, radius: const Radius.circular(100));
      if (leftWrist != null) {
        leftArmPath.arcToPoint(leftWrist!, radius: const Radius.circular(100));
      }
    }

    final rightArmPath = Path();
    if (rightShoulder != null && rightElbow != null) {
      rightArmPath.moveTo(rightShoulder!.dx, rightShoulder!.dy);
      rightArmPath.arcToPoint(rightElbow!, radius: const Radius.circular(100));
      if (rightWrist != null) {
        rightArmPath.arcToPoint(rightWrist!,
            radius: const Radius.circular(100));
      }
    }

    canvas.drawPath(leftArmPath, paint);
    canvas.drawPath(rightArmPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
