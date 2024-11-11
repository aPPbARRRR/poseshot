import 'package:flutter/material.dart';

import '../../../../model/person.dart';
import 'package:poseshot/src/model/body_point_extension.dart';

class AnimatedBodyPainter extends StatefulWidget {
  const AnimatedBodyPainter({
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
  State<AnimatedBodyPainter> createState() => _AnimatedBodyPainterState();
}

class _AnimatedBodyPainterState extends State<AnimatedBodyPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Animation<Offset>? _leftShoulder;
  Animation<Offset>? _rightShoulder;
  Animation<Offset>? _leftHip;
  Animation<Offset>? _rightHip;

  late Offset? curLeftShoulder;
  late Offset? curRightShoulder;
  late Offset? curLeftHip;
  late Offset? curRightHip;

  Offset? endLeftShoulder;
  Offset? endRightShoulder;
  Offset? endLeftHip;
  Offset? endRightHip;

  @override
  void initState() {
    super.initState();

    curLeftShoulder = widget.person.leftshoulder
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightShoulder = widget.person.rightshoulder
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curLeftHip = widget.person.lefthip
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightHip = widget.person.righthip
        ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.addListener(() {
      setState(() {
        curLeftShoulder = _leftShoulder?.value;
        curRightShoulder = _rightShoulder?.value;
        curLeftHip = _leftHip?.value;
        curRightHip = _rightHip?.value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedBodyPainter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.person.leftshoulder != widget.person.leftshoulder ||
        oldWidget.person.rightshoulder != widget.person.rightshoulder ||
        oldWidget.person.lefthip != widget.person.lefthip ||
        oldWidget.person.righthip != widget.person.righthip) {
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
      painter: Painter(
        // leftShoulder: widget.person.leftshoulder
        //     ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight),
        // rightShoulder: widget.person.rightshoulder
        //     ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight),
        // leftHip: widget.person.lefthip
        //     ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight),
        // rightHip: widget.person.righthip
        //     ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight),
        leftShoulder: curLeftShoulder,
        rightShoulder: curRightShoulder,
        leftHip: curLeftHip,
        rightHip: curRightHip,
        colorIndex: widget.colorIndex,
      ),
    );
  }
}

class Painter extends CustomPainter {
  Painter(
      {required this.leftShoulder,
      required this.rightShoulder,
      required this.leftHip,
      required this.rightHip,
      required this.colorIndex});

  final Offset? leftShoulder;
  final Offset? rightShoulder;
  final Offset? leftHip;
  final Offset? rightHip;
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

    // final facePath = Path();
    // if (leftEye != null && rightEye != null) {
    //   facePath.moveTo(rightEye!.dx, rightEye!.dy);
    //   facePath.arcToPoint(leftEye!, radius: const Radius.circular(120));
    //   if (nose != null) {
    //     facePath.arcToPoint(nose!, radius: const Radius.circular(120));
    //     facePath.arcToPoint(rightEye!, radius: const Radius.circular(120));
    //   }
    // }
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

    // canvas.drawPath(facePath, paint);
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}





// import 'package:flutter/material.dart';

// import '../../../../model/person.dart';
// import 'package:poseshot/src/model/body_point_extension.dart';

// class AnimatedBodyPainter extends StatefulWidget {
//   const AnimatedBodyPainter({
//     super.key,
//     required this.person,
//     required this.widgetWidth,
//     required this.widgetHeight,
//     required this.colorIndex,
//   });

//   final Person person;
//   final double widgetWidth;
//   final double widgetHeight;
//   final int colorIndex;

//   @override
//   State<AnimatedBodyPainter> createState() => _AnimatedBodyPainterState();
// }

// class _AnimatedBodyPainterState extends State<AnimatedBodyPainter>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   Animation<Offset>? _nose;
//   Animation<Offset>? _leftEye;
//   Animation<Offset>? _rightEye;
//   Animation<Offset>? _leftShoulder;
//   Animation<Offset>? _rightShoulder;
//   Animation<Offset>? _leftHip;
//   Animation<Offset>? _rightHip;

//   late Offset? curNose;
//   late Offset? curLeftEye;
//   late Offset? curRightEye;
//   late Offset? curLeftShoulder;
//   late Offset? curRightShoulder;
//   late Offset? curLeftHip;
//   late Offset? curRightHip;

//   Offset? endNose;
//   Offset? endLeftEye;
//   Offset? endRightEye;
//   Offset? endLeftShoulder;
//   Offset? endRightShoulder;
//   Offset? endLeftHip;
//   Offset? endRightHip;

//   @override
//   void initState() {
//     super.initState();

//     curNose = widget.person.nose
//         ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
//     curLeftEye = widget.person.lefteye
//         ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
//     curRightEye = widget.person.righteye
//         ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);

//     curLeftShoulder = widget.person.leftshoulder
//         ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
//     curRightShoulder = widget.person.rightshoulder
//         ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
//     curLeftHip = widget.person.lefthip
//         ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);
//     curRightHip = widget.person.righthip
//         ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight);

//     _controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 300));

//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut, // 원하는 Curve를 설정할 수 있습니다.
//     );

//     _controller.addListener(() {
//       setState(() {
//         curNose = _nose?.value;
//         curLeftEye = _leftEye?.value;
//         curRightEye = _rightEye?.value;
//         curLeftShoulder = _leftShoulder?.value;
//         curRightShoulder = _rightShoulder?.value;
//         curLeftHip = _leftHip?.value;
//         curRightHip = _rightHip?.value;
//       });
//     });
//   }

//   @override
//   void didUpdateWidget(covariant AnimatedBodyPainter oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.person.nose != widget.person.nose) {
//       _nose = Tween<Offset>(
//               begin: curNose,
//               end: widget.person.nose
//                   ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
//           .animate(_animation);

//       _leftEye = Tween<Offset>(
//               begin: curLeftEye,
//               end: widget.person.lefteye
//                   ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
//           .animate(_animation);

//       _rightEye = Tween<Offset>(
//               begin: curRightEye,
//               end: widget.person.righteye
//                   ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
//           .animate(_animation);

//       _leftShoulder = Tween<Offset>(
//               begin: curLeftShoulder,
//               end: widget.person.leftshoulder
//                   ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
//           .animate(_animation);

//       _rightShoulder = Tween<Offset>(
//               begin: curRightShoulder,
//               end: widget.person.rightshoulder
//                   ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
//           .animate(_animation);

//       _leftHip = Tween<Offset>(
//               begin: curLeftHip,
//               end: widget.person.lefthip
//                   ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
//           .animate(_animation);

//       _rightHip = Tween<Offset>(
//               begin: curRightHip,
//               end: widget.person.righthip
//                   ?.bodyPointOffset(widget.widgetWidth, widget.widgetHeight))
//           .animate(_animation);

//       _controller.reset();
//       _controller.forward();
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: Painter(
//         nose: curNose,
//         leftEye: curLeftEye,
//         rightEye: curRightEye,
//         leftShoulder: curLeftShoulder,
//         rightShoulder: curRightShoulder,
//         leftHip: curLeftHip,
//         rightHip: curRightHip,
//         colorIndex: widget.colorIndex,
//       ),
//     );
//   }
// }

// class Painter extends CustomPainter {
//   Painter(
//       {required this.nose,
//       required this.leftEye,
//       required this.rightEye,
//       required this.leftShoulder,
//       required this.rightShoulder,
//       required this.leftHip,
//       required this.rightHip,
//       required this.colorIndex});

//   final Offset? nose;
//   final Offset? leftEye;
//   final Offset? rightEye;
//   final Offset? leftShoulder;
//   final Offset? rightShoulder;
//   final Offset? leftHip;
//   final Offset? rightHip;
//   final int colorIndex;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke;

//     switch (colorIndex) {
//       case 0:
//         paint.color = Colors.red;
//         break;
//       case 1:
//         paint.color = Colors.blue;
//         break;
//       case 2:
//         paint.color = Colors.green;
//         break;
//       case 3:
//         paint.color = Colors.yellow;
//         break;
//       case 4:
//         paint.color = Colors.purple;
//         break;
//       case 5:
//         paint.color = Colors.orange;
//         break;
//     }

//     // final facePath = Path();
//     // if (leftEye != null && rightEye != null) {
//     //   facePath.moveTo(rightEye!.dx, rightEye!.dy);
//     //   facePath.arcToPoint(leftEye!, radius: const Radius.circular(120));
//     //   if (nose != null) {
//     //     facePath.arcToPoint(nose!, radius: const Radius.circular(120));
//     //     facePath.arcToPoint(rightEye!, radius: const Radius.circular(120));
//     //   }
//     // }
//     final bodyPath = Path();
//     if (leftShoulder != null && rightShoulder != null) {
//       bodyPath.moveTo(leftShoulder!.dx, leftShoulder!.dy);
//       bodyPath.arcToPoint(rightShoulder!, radius: const Radius.circular(360));
//       if (leftHip != null && rightHip != null) {
//         bodyPath.arcToPoint(rightHip!, radius: const Radius.circular(150));
//         bodyPath.arcToPoint(leftHip!, radius: const Radius.circular(100));
//         bodyPath.arcToPoint(leftShoulder!, radius: const Radius.circular(150));
//       }
//     }

//     // canvas.drawPath(facePath, paint);
//     canvas.drawPath(bodyPath, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
