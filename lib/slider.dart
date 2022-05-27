// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:slider/utils.dart';
import 'dart:math' as math;

class CircularSlider extends StatefulWidget {
  const CircularSlider({Key? key}) : super(key: key);

  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  Offset _currentDragOffset = Offset.zero;

  double currentAngle = 0;

  final double startAngle = toRadian(90);

  final double totalAngle = toRadian(360);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size canvasSize = Size(size.width, size.width - 35);
    Offset center = canvasSize.center(Offset.zero);
    Offset knobPos = toPolar(
        center - Offset(size.width * 0.085, -size.height * 0.107),
        currentAngle + startAngle,
        135);
    return Stack(
      children: [
        CustomPaint(
          child: Container(),
          painter:
              SliderPainter(startAngle: startAngle, currentAngle: currentAngle),
        ),
        Center(
          child: Text(
            (currentAngle * 16).toStringAsFixed(0),
            style: const TextStyle(fontSize: 50),
          ),
        ),
        Positioned(
            left: knobPos.dx,
            top: knobPos.dy,
            child: GestureDetector(
              child: const _Knob(),
              onPanStart: (details) {
                RenderBox getBox = context.findRenderObject() as RenderBox;
                _currentDragOffset =
                    getBox.globalToLocal(details.globalPosition);
              },
              onPanUpdate: (details) {
                var previousOffset = _currentDragOffset;
                _currentDragOffset += details.delta;
                var angle = currentAngle +
                    (toangle(_currentDragOffset, center) -
                        toangle(previousOffset, center));
                currentAngle = normalizeAngle(angle);
                setState(() {});
              },
            ))
      ],
    );
  }
}

class SliderPainter extends CustomPainter {
  final double startAngle;
  final double currentAngle;

  SliderPainter({required this.startAngle, required this.currentAngle});
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = size.center(Offset.zero);

    Rect rect = Rect.fromCircle(center: center, radius: 135);
    var rainbowPaint = Paint()
      ..shader = SweepGradient(colors: colors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.06
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.height * 0.06,
    );

    canvas.drawArc(rect, startAngle, currentAngle, false, rainbowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _Knob extends StatelessWidget {
  const _Knob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff0b1623),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
    );
  }
}
