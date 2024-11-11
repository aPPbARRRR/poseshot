import 'package:flutter/material.dart';
import 'package:poseshot/src/model/object_bounding_box_extension.dart';

import '../../../../model/person.dart';

class AnimatedBodyboundaryPainter extends StatefulWidget {
  const AnimatedBodyboundaryPainter({
    super.key,
    required this.person,
    required this.widgetWidth,
    required this.widgetHeight,
  });

  final Person person;
  final double widgetWidth;
  final double widgetHeight;

  @override
  State<AnimatedBodyboundaryPainter> createState() =>
      _AnimatedBodyboundaryPainterState();
}

class _AnimatedBodyboundaryPainterState
    extends State<AnimatedBodyboundaryPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? _leftTop;
  Animation<Offset>? _rightBottom;

  late Offset? curLeftTop;
  late Offset? curRightBottom;

  Offset? endLeftTop;
  Offset? endRightBottom;
  @override
  void initState() {
    super.initState();

    curLeftTop = widget.person.boundingBox
        .minBoundaryPointOffset(widget.widgetWidth, widget.widgetHeight);
    curRightBottom = widget.person.boundingBox
        .maxBoundaryPointOffset(widget.widgetWidth, widget.widgetHeight);

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 64));
    _controller.addListener(() {
      setState(() {
        curLeftTop = _leftTop?.value;
        curRightBottom = _rightBottom?.value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedBodyboundaryPainter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.person.boundingBox != widget.person.boundingBox) {
      _leftTop = Tween<Offset>(
              begin: curLeftTop,
              end: widget.person.boundingBox.minBoundaryPointOffset(
                  widget.widgetWidth, widget.widgetHeight))
          .animate(_controller);

      _rightBottom = Tween<Offset>(
              begin: curRightBottom,
              end: widget.person.boundingBox.maxBoundaryPointOffset(
                  widget.widgetWidth, widget.widgetHeight))
          .animate(_controller);

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
      painter: RectanglePainter(
        startOffset: curLeftTop ?? Offset.zero,
        endOffset: curRightBottom ?? Offset.zero,
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final Offset startOffset;
  final Offset endOffset;

  RectanglePainter({required this.startOffset, required this.endOffset});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 두 Offset으로 사각형 정의
    Rect rect = Rect.fromPoints(startOffset, endOffset);

    // 사각형 그리기
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Offset이 변경될 때마다 다시 그리기
  }
}
