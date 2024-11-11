import 'package:flutter/material.dart';

import '../../../../model/person.dart';
import 'package:poseshot/src/model/body_point_extension.dart';

class AnimatedFacePainter extends StatefulWidget {
  const AnimatedFacePainter({
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
  State<AnimatedFacePainter> createState() => _AnimatedFacePainterState();
}

class _AnimatedFacePainterState extends State<AnimatedFacePainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Animation<Offset>? _nose;
  Animation<Offset>? _leftEye;
  Animation<Offset>? _rightEye;

  late Offset? curNose;
  late Offset? curLeftEye;
  late Offset? curRightEye;

  Offset? endNose;
  Offset? endLeftEye;
  Offset? endRightEye;

  @override
  void initState() {
    super.initState();

    curNose = widget.person.nose
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curLeftEye = widget.person.lefteye
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightEye = widget.person.righteye
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // 원하는 Curve를 설정할 수 있습니다.
    );

    _controller.addListener(() {
      setState(() {
        curNose = _nose?.value;
        curLeftEye = _leftEye?.value;
        curRightEye = _rightEye?.value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedFacePainter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.person.nose != widget.person.nose ||
        oldWidget.person.lefteye != widget.person.lefteye ||
        oldWidget.person.righteye != widget.person.righteye) {
      if (widget.person.nose != null) {
        _nose = Tween<Offset>(
                begin: curNose ??
                    widget.person.nose?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.nose
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.lefteye != null) {
        _leftEye = Tween<Offset>(
                begin: curLeftEye ??
                    widget.person.lefteye?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.lefteye
                    ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
            .animate(_animation);
      }

      if (widget.person.righteye != null) {
        _rightEye = Tween<Offset>(
                begin: curRightEye ??
                    widget.person.righteye?.bodyPointOffset(
                        widget.widgetWidth, widget.widgetHeight),
                end: widget.person.righteye
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
      painter: FacePainter(
        // nose: widget.person.nose
        //     ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight),
        // leftEye: widget.person.lefteye
        //     ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight),
        // rightEye: widget.person.righteye
        //     ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight),
        nose: curNose,
        leftEye: curLeftEye,
        rightEye: curRightEye,
        colorIndex: widget.colorIndex,
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  FacePainter(
      {required this.nose,
      required this.leftEye,
      required this.rightEye,
      required this.colorIndex});

  final Offset? nose;
  final Offset? leftEye;
  final Offset? rightEye;

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

    final facePath = Path();
    if (leftEye != null && rightEye != null) {
      facePath.moveTo(rightEye!.dx, rightEye!.dy);
      facePath.arcToPoint(leftEye!, radius: const Radius.circular(120));
      if (nose != null) {
        facePath.arcToPoint(nose!, radius: const Radius.circular(120));
        facePath.arcToPoint(rightEye!, radius: const Radius.circular(120));
      }
    }
    // final bodyPath = Path();
    // if (leftShoulder != null && rightShoulder != null) {
    //   bodyPath.moveTo(leftShoulder!.dx, leftShoulder!.dy);
    //   bodyPath.arcToPoint(rightShoulder!, radius: const Radius.circular(360));
    //   if (leftHip != null && rightHip != null) {
    //     bodyPath.arcToPoint(rightHip!, radius: const Radius.circular(150));
    //     bodyPath.arcToPoint(leftHip!, radius: const Radius.circular(100));
    //     bodyPath.arcToPoint(leftShoulder!, radius: const Radius.circular(150));
    //   }
    // }

    canvas.drawPath(facePath, paint);
    // canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
