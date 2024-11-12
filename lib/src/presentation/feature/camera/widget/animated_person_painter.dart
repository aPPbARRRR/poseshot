import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../model/person.dart';
import 'package:poseshot/src/model/body_point_extension.dart';

class AnimatedPersonPainter extends StatefulWidget {
  const AnimatedPersonPainter({
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
  State<AnimatedPersonPainter> createState() => _AnimatedPersonPainterState();
}

class _AnimatedPersonPainterState extends State<AnimatedPersonPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

// nose, lefteye, righteye, leftear, rightear, leftshoulder, rightshoulder, leftelbow, rightelbow, leftwrist, rightwrist, lefthip, righthip, leftknee, rightknee, leftankle, rightankle
  Animation<Offset>? _nose;
  Animation<Offset>? _leftEye;
  Animation<Offset>? _rightEye;
  Animation<Offset>? _leftShoulder;
  Animation<Offset>? _rightShoulder;
  Animation<Offset>? _leftHip;
  Animation<Offset>? _rightHip;
  Animation<Offset>? _leftKnee;
  Animation<Offset>? _rightKnee;
  Animation<Offset>? _leftAnkle;
  Animation<Offset>? _rightAnkle;
  Animation<Offset>? _leftWrist;
  Animation<Offset>? _rightWrist;
  Animation<Offset>? _leftElbow;
  Animation<Offset>? _rightElbow;

  late Offset? curNose;
  late Offset? curLeftEye;
  late Offset? curRightEye;
  late Offset? curLeftShoulder;
  late Offset? curRightShoulder;
  late Offset? curLeftHip;
  late Offset? curRightHip;
  late Offset? curLeftKnee;
  late Offset? curRightKnee;
  late Offset? curLeftAnkle;
  late Offset? curRightAnkle;
  late Offset? curLeftWrist;
  late Offset? curRightWrist;
  late Offset? curLeftElbow;
  late Offset? curRightElbow;

  Offset? endNose;
  Offset? endLeftEye;
  Offset? endRightEye;
  Offset? endLeftShoulder;
  Offset? endRightShoulder;
  Offset? endLeftHip;
  Offset? endRightHip;
  Offset? endLeftKnee;
  Offset? endRightKnee;
  Offset? endLeftAnkle;
  Offset? endRightAnkle;
  Offset? endLeftWrist;
  Offset? endRightWrist;
  Offset? endLeftElbow;
  Offset? endRightElbow;

  @override
  void initState() {
    super.initState();

    curNose = widget.person.nose
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curLeftEye = widget.person.lefteye
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightEye = widget.person.righteye
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curLeftShoulder = widget.person.leftshoulder
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightShoulder = widget.person.rightshoulder
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
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
      curve: Curves.easeOut,
    );

    _controller.addListener(() {
      setState(() {
        curNose = _nose?.value;
        curLeftEye = _leftEye?.value;
        curRightEye = _rightEye?.value;
        curLeftShoulder = _leftShoulder?.value;
        curRightShoulder = _rightShoulder?.value;
        curLeftHip = _leftHip?.value;
        curRightHip = _rightHip?.value;
        curLeftKnee = _leftKnee?.value;
        curRightKnee = _rightKnee?.value;
        curLeftAnkle = _leftAnkle?.value;
        curRightAnkle = _rightAnkle?.value;
        curLeftWrist = _leftWrist?.value;
        curRightWrist = _rightWrist?.value;
        curLeftElbow = _leftElbow?.value;
        curRightElbow = _rightElbow?.value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedPersonPainter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.person.boundingBox != widget.person.boundingBox) {
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
      painter: PersonPainter(
        nose: curNose,
        leftEye: curLeftEye,
        rightEye: curRightEye,
        leftShoulder: curLeftShoulder,
        rightShoulder: curRightShoulder,
        leftHip: curLeftHip,
        rightHip: curRightHip,
        leftKnee: curLeftKnee,
        rightKnee: curRightKnee,
        leftAnkle: curLeftAnkle,
        rightAnkle: curRightAnkle,
        leftWrist: curLeftWrist,
        rightWrist: curRightWrist,
        leftElbow: curLeftElbow,
        rightElbow: curRightElbow,
        colorIndex: widget.colorIndex,
      ),
    );
  }
}

class PersonPainter extends CustomPainter {
  PersonPainter(
      {required this.nose,
      required this.leftEye,
      required this.rightEye,
      required this.leftShoulder,
      required this.rightShoulder,
      required this.leftHip,
      required this.rightHip,
      required this.leftKnee,
      required this.rightKnee,
      required this.leftAnkle,
      required this.rightAnkle,
      required this.leftWrist,
      required this.rightWrist,
      required this.leftElbow,
      required this.rightElbow,
      required this.colorIndex});

  final Offset? nose;
  final Offset? leftEye;
  final Offset? rightEye;
  final Offset? leftShoulder;
  final Offset? rightShoulder;
  final Offset? leftHip;
  final Offset? rightHip;
  final Offset? leftKnee;
  final Offset? rightKnee;
  final Offset? leftAnkle;
  final Offset? rightAnkle;
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
    final facePath = Path();
    if (leftEye != null && rightEye != null) {
      facePath.moveTo(rightEye!.dx, rightEye!.dy);
      facePath.arcToPoint(leftEye!, radius: const Radius.circular(120));
      if (nose != null) {
        facePath.arcToPoint(nose!, radius: const Radius.circular(120));
        facePath.arcToPoint(rightEye!, radius: const Radius.circular(120));
      }
    }

    final bodyPath = Path();
    if (leftShoulder != null && rightShoulder != null) {
      bodyPath.moveTo(leftShoulder!.dx, leftShoulder!.dy);
      bodyPath.arcToPoint(rightShoulder!, radius: const Radius.circular(360));
      if (leftHip != null && rightHip != null) {
        bodyPath.arcToPoint(rightHip!, radius: const Radius.circular(150));
        bodyPath.arcToPoint(leftHip!, radius: const Radius.circular(100));
        bodyPath.arcToPoint(leftShoulder!, radius: const Radius.circular(150));
      }
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

    canvas.drawPath(facePath, paint);
    canvas.drawPath(bodyPath, paint);
    canvas.drawPath(leftArmPath, paint);
    canvas.drawPath(rightArmPath, paint);
    canvas.drawPath(leftLegPath, paint);
    canvas.drawPath(rightLegPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
