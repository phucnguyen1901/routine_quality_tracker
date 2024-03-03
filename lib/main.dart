import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routine_quality_tracker/custom_datetime.dart';
import 'package:routine_quality_tracker/device_size.dart';
import 'package:routine_quality_tracker/primary_background.dart';
import 'package:routine_quality_tracker/stats_model.dart';
import 'package:routine_quality_tracker/stroke_text.dart';
import 'package:routine_quality_tracker/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

final player = AudioPlayer();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  player.setVolume(1);
  player.setReleaseMode(ReleaseMode.loop);
  player.play(AssetSource('sounds/routinetracker.wav'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List titles = [
    "Routine Quality Tracker",
    "Mood tracker",
    "Sleep tracker",
    "Activities Tracker",
    "Plan Tracker",
    "Gratitude Journal",
    "My stats"
  ];
  List moodNames = ["great", "fine", "not very good", "bad", "terrible"];
  List sleepNames = [
    "good sleep",
    "average sleep",
    "insufficient sleep",
    "insomnia"
  ];

  List moodPath = ["bb3.png", "bb2.png", "bb4.png", "bb5.png", "bb1.png"];
  List sleepsPath = [
    "aa1.png",
    "aa4.png",
    "aa2.png",
    "aa3.png",
  ];

  List<Color> sleepTrackColors = const [
    Color.fromRGBO(0, 173, 152, 1),
    Color.fromRGBO(118, 173, 0, 1),
    Color.fromRGBO(42, 132, 216, 1),
    Color.fromRGBO(221, 0, 0, 1),
  ];

  List<Color> moodColors = const [
    Color.fromRGBO(0, 173, 152, 1),
    Color.fromRGBO(118, 173, 0, 1),
    Color.fromRGBO(42, 132, 216, 1),
    Color.fromRGBO(229, 131, 40, 1),
    Color.fromRGBO(221, 0, 0, 1),
  ];

  List<String> activitiesTrackerList = [];
  List<String> planTrackerList = [];
  List<String> gratitudeJournalList = [];

  Menu currentMenu = Menu.routineQualityTracker;
  CustomDateTime customDateTime = const CustomDateTime();
  double sliderValue = 0.0;

  late Stats today;

  List<Stats> stats = [];

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: PrimaryBackground(
          nameImage: buildBackground(),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentMenu = Menu.routineQualityTracker;
                        });
                      },
                      child: currentMenu == Menu.routineQualityTracker
                          ? Image.asset("assets/icons/Vector.png")
                          : Image.asset("assets/icons/Group 2.png")),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: StrokeText(text: buildBackground()),
                )),
                SizedBox(
                  height: DeviceSize.height(context) - kToolbarHeight,
                  child: buildScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildScreen() {
    switch (currentMenu) {
      case Menu.routineQualityTracker:
        return homeScreen();
      case Menu.moodTracker:
        return moodTracker();
      case Menu.sleepTracker:
        return sleepTracker();
      case Menu.activitiesTracker:
        return activitiesTrackerScreen();
      case Menu.activitiesTracker2:
        return activitiesTrackerScreen2();
      case Menu.planTracker:
        return planTracker();
      case Menu.gratitudeJournal:
        return gratitudeJournal();
      case Menu.myStats:
        return myStats();
      case Menu.myStats2:
        return myStats2();
      default:
    }
  }

  buildBackground() {
    switch (currentMenu) {
      case Menu.routineQualityTracker:
        return titles[0];
      case Menu.moodTracker:
        return titles[1];
      case Menu.sleepTracker:
        return titles[2];
      case Menu.activitiesTracker:
        return titles[3];
      case Menu.activitiesTracker2:
        return titles[3];
      case Menu.planTracker:
        return titles[4];
      case Menu.gratitudeJournal:
        return titles[5];
      case Menu.myStats:
        return titles[6];
      case Menu.myStats2:
        return titles[6];
      default:
    }
  }

  homeScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 50),
        Center(child: Image.asset("assets/images/Group 137.png")),
        SizedBox(height: DeviceSize.height(context, partNumber: 2) - 10),
        SizedBox(
          width: DeviceSize.width(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentMenu = Menu.moodTracker;
                  });
                },
                child: Image.asset(
                  "assets/images/Group 2.png",
                  scale: 0.1,
                  width: DeviceSize.width(context, partNumber: 5),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentMenu = Menu.sleepTracker;
                  });
                },
                child: Image.asset(
                  "assets/images/Group 3.png",
                  scale: 0.1,
                  width: DeviceSize.width(context, partNumber: 5),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentMenu = Menu.activitiesTracker;
                  });
                },
                child: Image.asset(
                  "assets/images/Group 4.png",
                  scale: 0.1,
                  width: DeviceSize.width(context, partNumber: 5),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentMenu = Menu.planTracker;
                  });
                },
                child: Image.asset(
                  "assets/images/Group 5.png",
                  scale: 0.1,
                  width: DeviceSize.width(context, partNumber: 5),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentMenu = Menu.gratitudeJournal;
                  });
                },
                child: Image.asset(
                  "assets/images/Group 6.png",
                  scale: 0.1,
                  width: DeviceSize.width(context, partNumber: 5),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentMenu = Menu.myStats;
                  });
                },
                child: Image.asset(
                  "assets/images/Group 7.png",
                  scale: 0.1,
                  width: DeviceSize.width(context, partNumber: 5),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  activitiesTrackerScreen() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
            onTap: () {
              setState(() {
                currentMenu = Menu.routineQualityTracker;
              });
            },
            child: Image.asset("assets/icons/Group 2.png")),
      ),
      const Spacer(),
      Center(
          child: GestureDetector(
              onTap: () {
                setState(() {
                  currentMenu = Menu.activitiesTracker2;
                });
              },
              child: Image.asset("assets/images/arrow.png"))),
      const SizedBox(height: 10),
      Image.asset(
        "assets/images/Group 275.png",
        width: DeviceSize.width(context, partNumber: 8),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Image.asset(
              "assets/icons/Calendar.png",
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
              onTap: () {
                showCustomDateDiaglog(context);
              },
              child: Text(
                "today: 12.02.24, 12:00",
                style: styles.copyWith(fontWeight: FontWeight.w700),
              )),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        width: DeviceSize.width(context),
        height: DeviceSize.height(context, partNumber: 6) + 20,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(62, 55, 81, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
            ),
            Container(
              color: Colors.white.withOpacity(0.7),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              height: DeviceSize.height(context, partNumber: 6) - 30,
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...textFieldList(1, activitiesTrackerList),
                        ...List.generate(8, (index) {
                          final controller = TextEditingController();
                          return TextField(
                            controller: controller..text = "",
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.done,
                            style: styles.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 21),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            enabled: false,
                          );
                        })
                      ],
                    ),
                  )),
            ),
          ],
        ),
      )
    ]);
  }

  List<Widget> textFieldList(int type, List<String> dataList) {
    List<TextField> textFieldList = [];

    for (int index = 0; index < dataList.length + 1; index++) {
      final controller = TextEditingController();
      textFieldList.add(TextField(
        controller: controller
          ..text = index == dataList.length ? "" : dataList[index],
        onChanged: (text) {
          if (index > -1 && index < dataList.length) {
            if (text == "") {
              dataList.removeAt(index);
            } else {
              dataList[index] = text.trim();
            }
          } else {
            dataList.add(text.trim());
          }
          if (type == 1) {
            today = today.copyWith(activitiesTracker: dataList);
          } else if (type == 2) {
            today = today.copyWith(plansTracker: dataList);
          } else if (type == 3) {
            today = today.copyWith(gratitudeJournal: dataList);
          }
          saveList([today]);
          print("today:$today");
        },
        onSubmitted: (value) {
          setState(() {});
        },
        minLines: 1,
        maxLines: 3,
        textInputAction: TextInputAction.done,
        style: styles.copyWith(fontWeight: FontWeight.w700, fontSize: 21),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          hintText: type == 1 ? "+" : "...",
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ));
    }

    return textFieldList;
  }

  activitiesTrackerScreen2() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
            onTap: () {
              setState(() {
                currentMenu = Menu.routineQualityTracker;
              });
            },
            child: Image.asset("assets/icons/Group 2.png")),
      ),
      const SizedBox(height: 50),
      Image.asset(
        "assets/images/Group 278.png",
        width: DeviceSize.width(context, partNumber: 8),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Image.asset(
              "assets/icons/Calendar.png",
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
              onTap: () {
                showCustomDateDiaglog(context);
              },
              child: Text("today: 12.02.24, 12:00",
                  style: styles.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14))),
        ],
      ),
      const SizedBox(height: 40),
      progressbar()
    ]);
  }

  moodTracker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  currentMenu = Menu.routineQualityTracker;
                });
              },
              child: Image.asset("assets/icons/Group 2.png")),
        ),
        const SizedBox(height: 70),
        Image.asset(
          "assets/images/Group 276.png",
          width: DeviceSize.width(context, partNumber: 8),
        ),
        const SizedBox(height: 10),
        calendarWidget(),
      ],
    );
  }

  calendarWidget() {
    List paths = ["b3.png", "b2.png", "b4.png", "b5.png", "b1.png"];
    print("todayasdasdasd:$today");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Image.asset(
                "assets/icons/Calendar.png",
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
                onTap: () {
                  showCustomDateDiaglog(context);
                },
                child: Text(
                  "today: ${DateFormat('dd.MM.yyyy').format(today.date)} , ${today.time}",
                  style: styles.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14),
                )),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              paths.length,
              (index) => GestureDetector(
                    onTap: () {
                      today = today.copyWith(moodIndex: index);
                      setState(() {
                        currentMenu = Menu.routineQualityTracker;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(index == 2 ? 0.0 : 8.0),
                      child: Column(
                        children: [
                          Image.asset("assets/icons/${paths[index]}"),
                          const SizedBox(height: 5),
                          Text(
                            moodNames[index],
                            style: styles.copyWith(
                                fontSize: 13,
                                color: moodColors[index],
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  )),
        )
      ],
    );
  }

  sleepTrackWidget() {
    List paths = ["a1.png", "a2.png", "a3.png", "a4.png"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Image.asset(
                "assets/icons/Calendar.png",
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
                onTap: () {
                  showCustomDateDiaglog(context);
                },
                child: Text(
                  "today: 12.02.24, 12:00",
                  style: styles.copyWith(fontWeight: FontWeight.w700),
                )),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              paths.length,
              (index) => GestureDetector(
                    onTap: () {
                      today = today.copyWith(sleepStatsIndex: index);
                      setState(() {
                        currentMenu = Menu.routineQualityTracker;
                      });
                      print("today: $today");
                    },
                    child: Column(
                      children: [
                        Image.asset("assets/icons/${paths[index]}"),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 75,
                          child: Text(
                            sleepNames[index],
                            textAlign: TextAlign.center,
                            style: styles.copyWith(
                                fontSize: 13,
                                color: sleepTrackColors[index],
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  )),
        )
      ],
    );
  }

  sleepTracker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  currentMenu = Menu.routineQualityTracker;
                });
              },
              child: Image.asset("assets/icons/Group 2.png")),
        ),
        const SizedBox(height: 70),
        Image.asset(
          "assets/images/Group 277.png",
          width: DeviceSize.width(context, partNumber: 8),
        ),
        const SizedBox(height: 10),
        sleepTrackWidget(),
      ],
    );
  }

  planTracker() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
            onTap: () {
              setState(() {
                currentMenu = Menu.routineQualityTracker;
              });
            },
            child: Image.asset("assets/icons/Group 2.png")),
      ),
      const Spacer(),
      Center(
          child: GestureDetector(
              onTap: () {
                setState(() {
                  currentMenu = Menu.activitiesTracker2;
                });
              },
              child: Image.asset("assets/images/arrow.png"))),
      const SizedBox(height: 10),
      Image.asset(
        "assets/images/Group 279.png",
        width: DeviceSize.width(context, partNumber: 8),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Image.asset(
              "assets/icons/Calendar.png",
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
              onTap: () {
                showCustomDateDiaglog(context);
              },
              child: Text("today: 12.02.24, 12:00",
                  style: styles.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14))),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        width: DeviceSize.width(context),
        height: DeviceSize.height(context, partNumber: 6) + 20,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(62, 55, 81, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
            ),
            Container(
              color: Colors.white.withOpacity(0.7),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              height: DeviceSize.height(context, partNumber: 6) - 30,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...textFieldList(2, planTrackerList),
                      ...List.generate(8, (index) {
                        final controller = TextEditingController();
                        return TextField(
                          controller: controller..text = "",
                          minLines: 1,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          style: styles.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 21),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          enabled: false,
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }

  progressbar() {
    return Center(
      child: SizedBox(
        width: DeviceSize.height(context, partNumber: 4) - 20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 0,
                child: Text(
                  "${(sliderValue * 100).toStringAsFixed(0)}%",
                  style: murechoStyle.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14),
                )),
            SizedBox(
              width: DeviceSize.width(context, partNumber: 5),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 3)),
                    height: 30,
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 30,
                      width: sliderValue <= 0.03
                          ? 10
                          : DeviceSize.width(context, partNumber: 5) *
                              sliderValue,
                      decoration: BoxDecoration(
                          color: sliderValue >= 0.3
                              ? sliderValue >= 0.7
                                  ? const Color.fromRGBO(45, 211, 122, 1)
                                  : const Color.fromRGBO(65, 75, 166, 1)
                              : const Color.fromRGBO(246, 63, 0, 1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 3)),
                    ),
                  ),
                  Positioned(
                    left: -10,
                    child: Opacity(
                      opacity: 0.0,
                      child: SizedBox(
                        width: DeviceSize.width(context, partNumber: 5) + 10,
                        child: Slider(
                          value: sliderValue,
                          onChanged: (value) {
                            today = today.copyWith(percent: value);
                            setState(() {
                              sliderValue = value;
                            });
                            print("today: $today");
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                right: 0,
                child: Text("100%",
                    style: murechoStyle.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 14))),
          ],
        ),
      ),
    );
  }

  gratitudeJournal() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  currentMenu = Menu.routineQualityTracker;
                });
              },
              child: Image.asset("assets/icons/Group 2.png")),
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Image.asset(
                "assets/icons/Calendar.png",
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
                onTap: () {
                  showCustomDateDiaglog(context);
                },
                child: Text("today: 12.02.24, 12:00",
                    style: styles.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 14))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
          child: Text(
            "It is extremely important to remember what you are grateful for in this life. Think of the people and things you love and write gratitude notes!",
            textAlign: TextAlign.center,
            style: styles.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: DeviceSize.width(context),
          height: DeviceSize.height(context, partNumber: 6) + 20,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                height: 50,
                width: DeviceSize.width(context),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(227, 126, 126, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                padding: const EdgeInsets.all(8),
                child: Image.asset("assets/icons/gratitude.png"),
              ),
              Container(
                color: Colors.white.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                height: DeviceSize.height(context, partNumber: 6) - 30,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...textFieldList(3, gratitudeJournalList),
                        ...List.generate(8, (index) {
                          final controller = TextEditingController();
                          return TextField(
                            controller: controller..text = "",
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.done,
                            style: styles.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 21),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            enabled: false,
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  myStats() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
            onTap: () {
              setState(() {
                currentMenu = Menu.routineQualityTracker;
              });
            },
            child: Image.asset("assets/icons/Group 2.png")),
      ),
      const SizedBox(height: 80),
      SizedBox(
        height: DeviceSize.height(context, partNumber: 7) + 20,
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(194, 235, 249, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      child: Row(children: [
                        Image.asset(
                          "assets/icons/calendar2.png",
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Text("today: 12.02.24, 12:00",
                            style: styles.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 14))
                      ]),
                    ),
                    Container(
                      color: Colors.white.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      height: 100,
                      child: Stack(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                        "assets/icons/${moodPath[stats[index].moodIndex]}"),
                                    const SizedBox(width: 5),
                                    StrokeText(
                                      text: moodNames[stats[index].moodIndex],
                                      insideColor:
                                          moodColors[stats[index].moodIndex],
                                      outsideColor:
                                          const Color.fromRGBO(62, 55, 81, 1),
                                      fontSize: 15,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Image.asset(
                                        "assets/icons/${sleepsPath[stats[index].sleepStatsIndex]}"),
                                    const SizedBox(width: 5),
                                    StrokeText(
                                      text: sleepNames[
                                          stats[index].sleepStatsIndex],
                                      insideColor: sleepTrackColors[
                                          stats[index].sleepStatsIndex],
                                      outsideColor:
                                          const Color.fromRGBO(62, 55, 81, 1),
                                      fontSize: 15,
                                    )
                                  ],
                                ),
                              ]),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 130.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  progressbarStatic(stats[index].percent),
                                  const SizedBox(height: 3),
                                  Text(
                                    "Activities Tracker",
                                    style: styles.copyWith(
                                        color:
                                            const Color.fromRGBO(62, 55, 81, 1),
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: stats.length),
      )
    ]);
  }

  myStats2() {
    return Padding(
      padding: EdgeInsets.only(
          top: DeviceSize.height(context, partNumber: 2), left: 16, right: 16),
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 20),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(194, 235, 249, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Row(children: [
              Image.asset(
                "assets/icons/calendar2.png",
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 10),
              Text("today: 12.02.24, 12:00",
                  style: styles.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14))
            ]),
          ),
          Container(
            color: Colors.white.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: DeviceSize.height(context, partNumber: 8) - 110,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.asset("assets/icons/${moodPath[0]}"),
                      const SizedBox(width: 5),
                      StrokeText(
                        text: moodNames[stats[1].moodIndex],
                        insideColor: moodColors[stats[1].moodIndex],
                        outsideColor: const Color.fromRGBO(62, 55, 81, 1),
                        fontSize: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset("assets/icons/${sleepsPath[0]}"),
                      const SizedBox(width: 5),
                      StrokeText(
                        text: sleepNames[stats[1].sleepStatsIndex],
                        insideColor: sleepTrackColors[stats[1].sleepStatsIndex],
                        outsideColor: const Color.fromRGBO(62, 55, 81, 1),
                        fontSize: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    "assets/images/Group 4.png",
                    width: DeviceSize.width(context, partNumber: 4),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Text(
                            "OK",
                            style: styles.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 5),
                      itemCount: 3),
                  const SizedBox(height: 10),
                  Image.asset(
                    "assets/images/Group 5.png",
                    width: DeviceSize.width(context, partNumber: 4),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Text(
                            "OK",
                            style: styles.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 5),
                      itemCount: 7),
                  const SizedBox(height: 10),
                  Image.asset(
                    "assets/images/Group 6.png",
                    width: DeviceSize.width(context, partNumber: 4),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Text(
                            "OK",
                            style: styles.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 5),
                      itemCount: 5),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  progressbarStatic(percent) {
    return Center(
      child: SizedBox(
        width: DeviceSize.height(context, partNumber: 2) + 30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 5, child: Text("${(percent * 100).toStringAsFixed(0)}%")),
            SizedBox(
              width: DeviceSize.width(context, partNumber: 2) + 25,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 3)),
                    height: 20,
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 20,
                      width: percent <= 0.03
                          ? 10
                          : DeviceSize.width(context, partNumber: 2) * percent +
                              25,
                      decoration: BoxDecoration(
                          color: percent >= 0.3
                              ? percent >= 0.7
                                  ? const Color.fromRGBO(45, 211, 122, 1)
                                  : const Color.fromRGBO(65, 75, 166, 1)
                              : const Color.fromRGBO(246, 63, 0, 1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 3)),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(right: 0, child: Text("100%")),
          ],
        ),
      ),
    );
  }

  void saveList(List<Stats> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList =
        list.map((item) => jsonEncode(item.toJson())).toList();
    print("encodedList:$encodedList");
    prefs.setStringList('stats_list', encodedList);
  }

  Future<void> getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('stats_list');
    print("fetch encodedList:$encodedList");
    setState(() {
      if (encodedList != null) {
        stats = encodedList
            .map((String item) => Stats.fromJson(jsonDecode(item)))
            .toList();
      }

      today = stats.firstWhere(
          (element) =>
              element.date.year == DateTime.now().year &&
              element.date.month == DateTime.now().month &&
              element.date.day == DateTime.now().day, orElse: () {
        return Stats(
          date: DateTime.now(),
          time: "${DateTime.now().hour}:${DateTime.now().minute}",
          moodIndex: 0,
          sleepStatsIndex: 0,
          percent: 0.5,
          activitiesTracker: [],
          plansTracker: [],
          gratitudeJournal: [],
        );
      });

      activitiesTrackerList = today.activitiesTracker;
      planTrackerList = today.plansTracker;
      gratitudeJournalList = today.gratitudeJournal;
      print("stats:$activitiesTrackerList");
    });
  }
}

enum Menu {
  routineQualityTracker,
  moodTracker,
  sleepTracker,
  activitiesTracker,
  activitiesTracker2,
  planTracker,
  gratitudeJournal,
  myStats,
  myStats2
}
