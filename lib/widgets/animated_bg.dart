import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sparkl_task/const/color.const.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  AnimatedBackgroundState createState() => AnimatedBackgroundState();
}

class AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Offset> _bubblePositions = [];
  List<Offset> _bubbleDirections = [];
  final Random random = Random();

  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController for the floating effect.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;

      // Set random positions and directions for the bubbles
      _bubblePositions = List.generate(2, (index) {
        return Offset(
          random.nextDouble() * (screenWidth - 100), // Keeping in bounds
          random.nextDouble() * (screenHeight - 100), // Keeping in bounds
        );
      });

      // Random directions for each bubble
      _bubbleDirections = List.generate(2, (index) {
        return Offset(
          random.nextDouble() * 2 - 1, // Random horizontal direction (-1 to 1)
          random.nextDouble() * 2 - 1, // Random vertical direction (-1 to 1)
        );
      });

      // Add listener to update the positions of the bubbles
      _controller.addListener(() {
        setState(() {
          _bubblePositions = _bubblePositions.asMap().entries.map((entry) {
            int i = entry.key;
            Offset position = entry.value;
            Offset direction = _bubbleDirections[i];

            // New position
            double newX = position.dx + direction.dx * 2; // Speed factor
            double newY = position.dy + direction.dy * 2;

            // Reverse direction if bubble hits the boundary
            if (newX <= 0 || newX >= screenWidth - 100) {
              _bubbleDirections[i] = Offset(-direction.dx, direction.dy);
            }
            if (newY <= 0 || newY >= screenHeight - 100) {
              _bubbleDirections[i] = Offset(direction.dx, -direction.dy);
            }

            // Update the bubble's position
            return Offset(
              newX.clamp(0, screenWidth - 100),
              newY.clamp(0, screenHeight - 100),
            );
          }).toList();
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightYellow,
      body: Stack(
        children: [
          if (_bubblePositions.isNotEmpty)
            AnimatedPositioned(
              left: _bubblePositions[0].dx,
              top: _bubblePositions[0].dy,
              duration: const Duration(seconds: 5),
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.blueGreen,
                ),
              ),
            ),
          if (_bubblePositions.isNotEmpty)
            AnimatedPositioned(
              left: _bubblePositions[1].dx,
              top: _bubblePositions[1].dy,
              duration: const Duration(seconds: 5),
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.darkYellow,
                ),
              ),
            ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
