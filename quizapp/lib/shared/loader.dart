import 'dart:math';

import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> animation_rotation;
  late Animation<double> animation_Radius_in;
  late Animation<double> animation_Radius_out;

  final double idistance = 60;

  double distance = 0;

  // move the listener logic here
  void _listener() {
    if (mounted) {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          distance = animation_Radius_in.value * idistance;
        } else if (controller.value >= 0.0 && controller.value <= 0.25) {
          distance = animation_Radius_out.value * idistance;
        }
      });
    }
  }

  // get rid of the listener and controller
  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation_rotation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animation_Radius_in = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeInOut),
      ),
    );
    animation_Radius_out = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOut),
      ),
    );

    controller.addListener(_listener);

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Center(
        child: RotationTransition(
          turns: animation_rotation,
          child: Stack(
            children: [
              const Dot(
                color: Colors.white,
                radius: 50,
              ),
              Transform.translate(
                offset: Offset(
                  distance * cos(pi / 4),
                  distance * sin(pi / 4),
                ),
                child: const Dot(
                  color: Colors.green,
                  radius: 15,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  distance * cos(2 * pi / 4),
                  distance * sin(2 * pi / 4),
                ),
                child: const Dot(
                  color: Colors.cyan,
                  radius: 15,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  distance * cos(3 * pi / 4),
                  distance * sin(3 * pi / 4),
                ),
                child: const Dot(
                  color: Colors.purple,
                  radius: 15,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  distance * cos(4 * pi / 4),
                  distance * sin(4 * pi / 4),
                ),
                child: Dot(
                  color: Colors.blue.shade600,
                  radius: 15,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  distance * cos(5 * pi / 4),
                  distance * sin(5 * pi / 4),
                ),
                child: const Dot(
                  color: Colors.pink,
                  radius: 15,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  distance * cos(6 * pi / 4),
                  distance * sin(6 * pi / 4),
                ),
                child: const Dot(
                  color: Colors.yellow,
                  radius: 15,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  distance * cos(7 * pi / 4),
                  distance * sin(7 * pi / 4),
                ),
                child: Dot(
                  color: Colors.amber.shade800,
                  radius: 15,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  distance * cos(8 * pi / 4),
                  distance * sin(8 * pi / 4),
                ),
                child: const Dot(
                  color: Colors.red,
                  radius: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final Color color;
  final double radius;
  const Dot({super.key, required this.color, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
