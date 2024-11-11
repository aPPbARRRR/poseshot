import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../model/person.dart';
import 'package:poseshot/src/model/body_point_extension.dart';

class AnimatedLegsPainter extends StatefulWidget {
  const AnimatedLegsPainter({
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
  State<AnimatedLegsPainter> createState() => _AnimatedLegsPainterState();
}

class _AnimatedLegsPainterState extends State<AnimatedLegsPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

// nose, lefteye, righteye, leftear, rightear, leftshoulder, rightshoulder, leftelbow, rightelbow, leftwrist, rightwrist, lefthip, righthip, leftknee, rightknee, leftankle, rightankle

  Animation<Offset>? _leftHip;
  Animation<Offset>? _rightHip;
  Animation<Offset>? _leftKnee;
  Animation<Offset>? _rightKnee;
  Animation<Offset>? _leftAnkle;
  Animation<Offset>? _rightAnkle;

  late Offset? curLeftHip;
  late Offset? curRightHip;
  late Offset? curLeftKnee;
  late Offset? curRightKnee;
  late Offset? curLeftAnkle;
  late Offset? curRightAnkle;

  Offset? endLeftHip;
  Offset? endRightHip;
  Offset? endLeftKnee;
  Offset? endRightKnee;
  Offset? endLeftAnkle;
  Offset? endRightAnkle;

  @override
  void initState() {
    super.initState();

    curLeftHip = widget.person.lefthip
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightHip = widget.person.righthip
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curLeftKnee = widget.person.leftknee
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightKnee = widget.person.rightknee
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curLeftAnkle = widget.person.leftankle
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightAnkle = widget.person.rightankle
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // 원하는 Curve를 설정할 수 있습니다.
    );

    _controller.addListener(() {
      setState(() {
        curLeftHip = _leftHip?.value;
        curRightHip = _rightHip?.value;
        curLeftKnee = _leftKnee?.value;
        curRightKnee = _rightKnee?.value;
        curLeftAnkle = _leftAnkle?.value;
        curRightAnkle = _rightAnkle?.value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedLegsPainter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.person.boundingBox != widget.person.boundingBox) {
      if (widget.person.lefthip != null) {
        _leftHip = Tween<Offset>(
                begin: curLeftHip ??
                    widget.person.lefthip?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.lefthip
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.righthip != null) {
        _rightHip = Tween<Offset>(
                begin: curRightHip ??
                    widget.person.righthip?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.righthip
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.leftknee != null) {
        _leftKnee = Tween<Offset>(
                begin: curLeftKnee ??
                    widget.person.leftknee?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.leftknee
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.rightknee != null) {
        _rightKnee = Tween<Offset>(
                begin: curRightKnee ??
                    widget.person.rightknee?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.rightknee
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.leftankle != null) {
        _leftAnkle = Tween<Offset>(
                begin: curLeftAnkle ??
                    widget.person.leftankle?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.leftankle
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.rightankle != null) {
        _rightAnkle = Tween<Offset>(
                begin: curRightAnkle ??
                    widget.person.rightankle?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.rightankle
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
      painter: LegsPainter(
        leftHip: curLeftHip,
        rightHip: curRightHip,
        leftKnee: curLeftKnee,
        rightKnee: curRightKnee,
        leftAnkle: curLeftAnkle,
        rightAnkle: curRightAnkle,
        colorIndex: widget.colorIndex,
      ),
    );
  }
}

class LegsPainter extends CustomPainter {
  LegsPainter(
      {required this.leftHip,
      required this.rightHip,
      required this.leftKnee,
      required this.rightKnee,
      required this.leftAnkle,
      required this.rightAnkle,
      required this.colorIndex});

  final Offset? leftHip;
  final Offset? rightHip;
  final Offset? leftKnee;
  final Offset? rightKnee;
  final Offset? leftAnkle;
  final Offset? rightAnkle;

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

    final leftLegPath = Path();
    if (leftHip != null && leftKnee != null) {
      leftLegPath.moveTo(leftHip!.dx, leftHip!.dy);
      leftLegPath.arcToPoint(leftKnee!, radius: const Radius.circular(100));
      if (leftAnkle != null) {
        leftLegPath.arcToPoint(leftAnkle!, radius: const Radius.circular(100));
      }
    }

    final rightLegPath = Path();
    if (rightHip != null && rightKnee != null) {
      rightLegPath.moveTo(rightHip!.dx, rightHip!.dy);
      rightLegPath.arcToPoint(rightKnee!, radius: const Radius.circular(100));
      if (rightAnkle != null) {
        rightLegPath.arcToPoint(rightAnkle!,
            radius: const Radius.circular(100));
      }
    }

    canvas.drawPath(leftLegPath, paint);
    canvas.drawPath(rightLegPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
