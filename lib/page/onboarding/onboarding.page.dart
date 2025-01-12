import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sparkl_task/const/color.const.dart';
import 'package:sparkl_task/gen/assets.gen.dart';
import 'package:sparkl_task/main.dart';
import 'package:sparkl_task/widgets/animated_bg.dart';
import 'package:sparkl_task/widgets/feature_circle.widget.dart';
import 'package:sprung/sprung.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late VideoPlayerController _teacherVideoController;

  // Controller for camera access
  late CameraController controller;

  late final AnimationController controller1;
  late final AnimationController controller2;
  late final AnimationController controller3;
  late final AnimationController controller4;

  // sparkl logo animation
  late Animation<Offset> logoPosition;
  late Animation<double> logoSize;

  // Description text animation of 3 pages
  late Animation<Offset> textPosition;
  late Animation<Offset> page2TextPosition;
  late Animation<Offset> page3TextPosition;

  // Animation of different icons of 1st page
  late Animation<Offset> leftIconsPosition;
  late Animation<Offset> rightIconsPosition;

  // Animation for student video
  late Animation<Offset> studentCirclePosition;
  late Animation<double> studentCircleSize;

  // Animation for teacher video
  late Animation<Offset> teacherVideoPosition;

  // Animation to hide lottie
  late Animation<double> fadeAnimation;

  // Stacked card animation
  late Animation<Offset> card1Position;
  late Animation<Offset> card2Position;
  late Animation<Offset> card3Position;
  late Animation<Offset> card4Position;

  // Chat bubble animation
  late Animation<double> bubbleSize;

  // current onboarding step page
  int page = 1;

  bool isCameraAvailable = false;

  // Set card stack values to default for forward after reverse animations
  void setStackCardAnmation() {
    card1Position =
        Tween<Offset>(begin: const Offset(3.3, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: controller1,
        curve: Interval(0, 1, curve: Sprung.underDamped),
      ),
    );
    card2Position =
        Tween<Offset>(begin: const Offset(2.2, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: controller1,
        curve: Interval(0, 1, curve: Sprung.underDamped),
      ),
    );
    card3Position =
        Tween<Offset>(begin: const Offset(1.1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: controller1,
        curve: Interval(0, 1, curve: Sprung.underDamped),
      ),
    );
    card4Position =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: controller1,
        curve: Interval(0, 1, curve: Sprung.underDamped),
      ),
    );
  }

  @override
  void initState() {
    // Initialise animation controllers
    controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    logoPosition =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-0.28, 0))
            .animate(
      CurvedAnimation(
        parent: controller1,
        curve: Interval(0, 1, curve: Sprung.underDamped),
      ),
    );
    logoSize = Tween<double>(begin: 1, end: 0.7).animate(controller1);

    textPosition =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-4, 0))
            .animate(controller1);
    page2TextPosition =
        Tween<Offset>(begin: const Offset(4.4, 0), end: const Offset(0.1, 0))
            .animate(controller1);
    page3TextPosition =
        Tween<Offset>(begin: const Offset(4.4, 0), end: const Offset(0.1, 0))
            .animate(controller2);

    leftIconsPosition =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-4, 0))
            .animate(controller1);
    rightIconsPosition =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(4, 0))
            .animate(controller1);

    studentCirclePosition =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 2))
            .animate(controller1);
    studentCircleSize = Tween<double>(begin: 1, end: 0.35).animate(controller1);
    fadeAnimation = Tween<double>(begin: 1, end: 0).animate(controller1);

    teacherVideoPosition =
        Tween<Offset>(begin: const Offset(0, -10), end: const Offset(0, -1.6))
            .animate(controller1);

    bubbleSize = Tween<double>(begin: 0.0, end: 1).animate(controller2);

    setStackCardAnmation();

    _teacherVideoController = VideoPlayerController.asset(
      Assets.teachervideo,
    );
    _teacherVideoController.initialize().then((_) {
      _teacherVideoController.setLooping(true);
      // _teacherVideoController.play();
      _teacherVideoController.setVolume(0);
      setState(() {});
    });

    _videoController = VideoPlayerController.asset(
      Assets.studentvideo,
    );
    _videoController.initialize().then((_) {
      _videoController.setLooping(true);
      _videoController.setVolume(0);
      setState(() {});
    });

    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().whenComplete(() {
      setState(() {
        isCameraAvailable = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            isCameraAvailable = false;
            _videoController.play();
            setState(() {});
            break;
          default:
            isCameraAvailable = false;
            break;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _teacherVideoController.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.046,
                    child: SlideTransition(
                      position: logoPosition,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: logoSize,
                          builder: (context, child) {
                            return Assets.sparklLogo.image(
                              width:
                                  (MediaQuery.of(context).size.width * 0.48) *
                                      logoSize.value,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Stack(
                    children: [
                      Center(
                        child: SlideTransition(
                          position: textPosition,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Learning Made\nPersonal",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins"),
                              ),
                              Text(
                                "A Program designed just for YOU!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Poppins"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Page 2 Text
                      SlideTransition(
                        position: page2TextPosition,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1-on-1 Live classes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins"),
                            ),
                            Text(
                              "Learning customised for every student",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Poppins"),
                            ),
                          ],
                        ),
                      ),
                      SlideTransition(
                        position: page3TextPosition,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Doubt resolution\nwith teachers",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      FadeTransition(
                        opacity: fadeAnimation,
                        child: Lottie.asset(Assets.sparklShapeShiftLottie,
                            width: width, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 20.0,
                        left: 30,
                        child: AnimatedBuilder(
                            animation: bubbleSize,
                            builder: (context, child) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                width: controller2.value == 0 ? 0 : width * 0.6,
                                height: controller2.value == 0 ? 0 : 90,
                                child: Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: const Offset(-3, 3))
                                  ]),
                                  child: BubbleSpecialThree(
                                    text:
                                        'Do you want to go over how to apply the quadratic formula?',
                                    color: AppColor.yellowChatColor,
                                    tail: true,
                                    isSender: false,
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16 * (controller2.value)),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Positioned(
                        top: 200.0,
                        right: 30,
                        child: AnimatedBuilder(
                            animation: controller3,
                            builder: (context, child) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                width: controller3.value == 0 ? 0 : width * 0.7,
                                height: controller3.value == 0 ? 0 : 70,
                                child: Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 12,
                                        spreadRadius: 4,
                                        offset: const Offset(-1, 3))
                                  ]),
                                  child: BubbleSpecialThree(
                                    text:
                                        "Yes, I'm confused about when to use it.",
                                    color: Colors.white,
                                    tail: true,
                                    isSender: true,
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16 * controller3.value),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 30,
                        child: AnimatedBuilder(
                            animation: controller4,
                            builder: (context, child) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                width: controller4.value == 0 ? 0 : width * 0.7,
                                height: controller4.value == 0 ? 0 : 120,
                                child: Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 3))
                                  ]),
                                  child: BubbleSpecialThree(
                                    text: """You use it when the
equation is in the form ax? +
bx + c = 0. Let me show you
a quick example to clarify.""",
                                    color: AppColor.yellowChatColor,
                                    tail: true,
                                    isSender: false,
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16 * controller4.value),
                                  ),
                                ),
                              );
                            }),
                      ),
                      AnimatedBuilder(
                          animation: teacherVideoPosition,
                          builder: (context, child) {
                            if (controller2.isCompleted) {
                              return Positioned(
                                left: 30,
                                bottom: 100,
                                child: SizedBox(
                                  width: width * 0.1,
                                  height: width * 0.1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width: height *
                                            _teacherVideoController
                                                .value.aspectRatio,
                                        height: height * 1,
                                        child: _teacherVideoController
                                                .value.isInitialized
                                            ? VideoPlayer(
                                                _teacherVideoController)
                                            : Container(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                      SlideTransition(
                        position: teacherVideoPosition,
                        child: AnimatedBuilder(
                            animation: teacherVideoPosition,
                            builder: (context, child) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                width:
                                    page == 3 ? (width * 0.1) : (width * 0.44),
                                height:
                                    page == 3 ? (width * 0.1) : width * 0.25,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      page == 3 ? 100 : 15.0),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: height *
                                          _teacherVideoController
                                              .value.aspectRatio,
                                      height: height * 1,
                                      child: _teacherVideoController
                                              .value.isInitialized
                                          ? VideoPlayer(_teacherVideoController)
                                          : Container(),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      for (int i = 0; i < 4; i++)
                        SlideTransition(
                          position: [
                            card1Position,
                            card2Position,
                            card3Position,
                            card4Position
                          ][i],
                          child: Padding(
                            padding: EdgeInsets.only(top: (53.0 * i)),
                            child: Assets.stackCard
                                .image(width: width - ((4 - i) * 25.0)),
                          ),
                        ),
                      SlideTransition(
                        position: studentCirclePosition,
                        child: AnimatedBuilder(
                            animation: studentCircleSize,
                            builder: (context, child) {
                              return Container(
                                width:
                                    (width * 0.645) * studentCircleSize.value,
                                height:
                                    (width * 0.645) * studentCircleSize.value,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: height *
                                          (isCameraAvailable
                                              ? controller.value.aspectRatio
                                              : _videoController
                                                  .value.aspectRatio),
                                      height:
                                          isCameraAvailable ? null : height * 1,
                                      child: isCameraAvailable
                                          ? CameraPreview(controller)
                                          : _videoController.value.isInitialized
                                              ? VideoPlayer(_videoController)
                                              : Container(),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      FadeTransition(
                        opacity: fadeAnimation,
                        child: Container(
                          width: width * 0.735,
                          height: width * 0.735,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: AppColor.orange2,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                          left: 60,
                          top: 60,
                          child: FeatureCircleWidget(
                              position: leftIconsPosition,
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                width: 65.0,
                                height: 65.0,
                                child: Assets.blueBook.image(width: 30.0),
                              ))),
                      Positioned(
                          right: 20,
                          top: 80,
                          child: FeatureCircleWidget(
                            position: rightIconsPosition,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10.0),
                              child: Text(
                                "Holistic well-being",
                                style: TextStyle(
                                    fontFamily: "BRUSH",
                                    letterSpacing: 0.9,
                                    fontSize: 17.0),
                              ),
                            ),
                          )),
                      Positioned(
                          left: 40,
                          bottom: 160.0,
                          child: FeatureCircleWidget(
                              position: leftIconsPosition,
                              child: Container(
                                padding: const EdgeInsets.all(7.0),
                                width: 43.0,
                                height: 43.0,
                                child:
                                    Assets.preReadSelected.image(width: 30.0),
                              ))),
                      Positioned(
                          right: 30,
                          bottom: 100,
                          child: FeatureCircleWidget(
                            position: rightIconsPosition,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10.0),
                              child: Text(
                                "Personalised",
                                style: TextStyle(
                                    fontFamily: "BRUSH",
                                    letterSpacing: 0.8,
                                    fontSize: 17.0),
                              ),
                            ),
                          )),
                      Positioned(
                          left: 20,
                          bottom: 70,
                          child: FeatureCircleWidget(
                            position: leftIconsPosition,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10.0),
                              child: Text(
                                "Doubt Clarification",
                                style: TextStyle(
                                    fontFamily: "BRUSH",
                                    letterSpacing: 0.9,
                                    fontSize: 17.0),
                              ),
                            ),
                          )),
                      Positioned(
                        right: 100.0,
                        bottom: 0,
                        child: FeatureCircleWidget(
                            position: rightIconsPosition,
                            child: Container(
                              color: Colors.white70,
                              padding: const EdgeInsets.all(12.0),
                              child: Assets.emoji.image(
                                width: 28.0,
                              ),
                            )),
                      )
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (page != 1)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (controller1.isAnimating ||
                                controller2.isAnimating) {
                              return;
                            }
                            if (page == 3) {
                              controller4.reverse();
                              controller3.reverse();
                              controller2.reverse();
                            } else if (page == 2) {
                              page2TextPosition = Tween<Offset>(
                                      begin: const Offset(4.4, 0),
                                      end: const Offset(0.1, 0))
                                  .animate(controller1);
                              studentCirclePosition = Tween<Offset>(
                                      begin: const Offset(0, 0),
                                      end: const Offset(0, 2))
                                  .animate(controller1);
                              studentCircleSize =
                                  Tween<double>(begin: 1, end: 0.35)
                                      .animate(controller1);
                              teacherVideoPosition = Tween<Offset>(
                                      begin: const Offset(0, -10),
                                      end: const Offset(0, -1.6))
                                  .animate(controller1);
                              setStackCardAnmation();
                              controller1.reverse();
                            }
                            setState(() {
                              page--;
                            });
                          },
                          child: CircularStepProgressIndicator(
                            totalSteps: 3,
                            currentStep: page,
                            width: 50,
                            height: 50.0,
                            unselectedColor: Colors.grey.withOpacity(0.3),
                            selectedColor: AppColor.orange2,
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                      if (page != 1)
                        const SizedBox(
                          width: 10.0,
                        ),
                      GestureDetector(
                        onTap: () {
                          if (!_teacherVideoController.value.isPlaying) {
                            _teacherVideoController.play();
                          }
                          if (controller1.isAnimating ||
                              controller2.isAnimating) {
                            return;
                          }
                          if (page == 1) {
                            page2TextPosition = Tween<Offset>(
                                    begin: const Offset(4.4, 0),
                                    end: const Offset(0.1, 0))
                                .animate(controller1);
                            controller1.forward();
                          } else if (page == 2) {
                            controller2.forward().whenComplete(() {
                              controller3.forward().whenComplete(() {
                                controller4.forward();
                              });
                            });

                            studentCirclePosition = Tween<Offset>(
                                    end: const Offset(3.4, 0),
                                    begin: const Offset(0, 2))
                                .animate(controller2);
                            studentCircleSize =
                                Tween<double>(end: 0.16, begin: 0.35)
                                    .animate(controller2);

                            teacherVideoPosition = Tween<Offset>(
                                    end: const Offset(-3.8, -4.8),
                                    begin: const Offset(0, -1.6))
                                .animate(controller2);

                            page2TextPosition = Tween<Offset>(
                                    end: const Offset(4.4, 0),
                                    begin: const Offset(0.1, 0))
                                .animate(controller2);
                            card1Position = Tween<Offset>(
                                    end: const Offset(3.3, 0),
                                    begin: const Offset(0, 0))
                                .animate(
                              CurvedAnimation(
                                parent: controller2,
                                curve:
                                    Interval(0, 1, curve: Sprung.underDamped),
                              ),
                            );
                            card2Position = Tween<Offset>(
                                    end: const Offset(2.2, 0),
                                    begin: const Offset(0, 0))
                                .animate(
                              CurvedAnimation(
                                parent: controller2,
                                curve:
                                    Interval(0, 1, curve: Sprung.underDamped),
                              ),
                            );
                            card3Position = Tween<Offset>(
                                    end: const Offset(1.1, 0),
                                    begin: const Offset(0, 0))
                                .animate(
                              CurvedAnimation(
                                parent: controller2,
                                curve:
                                    Interval(0, 1, curve: Sprung.underDamped),
                              ),
                            );
                            card4Position = Tween<Offset>(
                                    end: const Offset(1, 0),
                                    begin: const Offset(0, 0))
                                .animate(
                              CurvedAnimation(
                                parent: controller2,
                                curve:
                                    Interval(0, 1, curve: Sprung.underDamped),
                              ),
                            );
                          }
                          setState(() {
                            page++;
                          });
                        },
                        child: Container(
                          height: 55.0,
                          width: width * 0.87 - 50,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 8),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                )
                              ],
                              borderRadius: BorderRadius.circular(12.0),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColor.orange,
                                  AppColor.orange2,
                                ],
                              )),
                          child: Center(
                            child: Text(
                              page == 3 ? "Get Started" : "Next",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
