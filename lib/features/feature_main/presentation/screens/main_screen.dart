import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/utils/constant.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late double _bottom = 370;
  late double _left = 150;
  late int _screenHeight;
  late int _screenWidth;
  late String direction;
  int index = 0;
  bool first = true;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        Timer.periodic(
          const Duration(milliseconds: 300),
          (timer) {
            if (direction == 'up' && _bottom <= _screenHeight - 120) {
              _bottom += 2;

              setState(() {});
              if (_bottom == _screenHeight - 120) {
                direction = 'bottom';
              }
            }
            if (direction == 'bottom' && _bottom >= 0) {
              _bottom -= 2;
              setState(() {});
              if (_bottom == 0) {
                direction = 'up';
                setState(() {});
              }
            }

            if (direction == 'left' && _left <= _screenWidth - 80) {
              _left += 2;

              setState(() {});
              if (_left == _screenWidth - 80) {
                direction = 'right';
              }
            }
            if (direction == 'right' && _left >= 0) {
              _left -= 2;

              setState(() {});
              if (_left == 0) {
                direction = 'left';
              }
            }
          },
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height.toInt().isEven
        ? MediaQuery.of(context).size.height.toInt()
        : MediaQuery.of(context).size.height.toInt() - 1;

    _screenWidth = MediaQuery.of(context).size.width.toInt().isEven
        ? MediaQuery.of(context).size.width.toInt()
        : MediaQuery.of(context).size.width.toInt() - 1;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(backGroungImage),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: _bottom,
                left: _left,
                child: _card(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          direction = 'left';

          controller.forward();

          first = false;
          setState(() {});
        } else if (details.primaryVelocity! < 0) {
          direction = 'right';
          setState(() {});
          controller.forward();
          first = false;
        }
      },
      onVerticalDragEnd: ((details) {
        if (details.primaryVelocity! > 0) {
          direction = 'bottom';
          setState(() {});
          controller.forward();
          first = false;
        } else if (details.primaryVelocity! < 0) {
          direction = 'up';
          setState(() {});
          controller.forward();
          first = false;
        }
      }),
      onTap: () {
        var rng = Random();
        index = rng.nextInt(photoUrl.length);

        setState(() {});
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 182, 25, 25),
              borderRadius: BorderRadius.circular(32),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(photoUrl[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
