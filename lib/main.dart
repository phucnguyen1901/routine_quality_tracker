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
      title: 'Routine Quality Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
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
  double sliderValue = 0.0;

  late Stats today;

  Stats? currentMyStats;

  List<Stats> stats = [];
  DateTime dateSelected = DateTime.now();

  bool isPlaySound = true;

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
          child: SizedBox(
            width: DeviceSize.width(context),
            height: DeviceSize.height(context),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: currentMenu == Menu.routineQualityTracker
                      ? isPlaySound
                          ? GestureDetector(
                              onTap: () {
                                player.stop();
                                setState(() {
                                  isPlaySound = false;
                                });
                              },
                              child: Image.asset("assets/icons/Vector.png"))
                          : GestureDetector(
                              onTap: () {
                                player.play(
                                    AssetSource('sounds/routinetracker.wav'));
                                setState(() {
                                  isPlaySound = true;
                                });
                              },
                              child: Image.asset("assets/icons/Vector2.png"))
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              if (currentMenu == Menu.myStats2) {
                                currentMenu = Menu.myStats;
                              } else if (currentMenu ==
                                  Menu.activitiesTracker2) {
                                currentMenu = Menu.activitiesTracker;
                              } else {
                                resetDataList();
                                currentMenu = Menu.routineQualityTracker;
                              }
                            });
                          },
                          child: Image.asset("assets/icons/Group 2.png")),
                ),
                Positioned(
                  top: 20,
                  child: SizedBox(
                      width: DeviceSize.width(context),
                      child:
                          Center(child: StrokeText(text: buildBackground()))),
                ),
                SizedBox(
                  height: DeviceSize.height(context) - kToolbarHeight,
                  child: buildScreen(),
                ),
                buildCreateButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildCreateButton() {
    if (currentMenu == Menu.activitiesTracker ||
        currentMenu == Menu.planTracker ||
        currentMenu == Menu.gratitudeJournal) {
      return Positioned(
        bottom: 40,
        child: SizedBox(
            width: DeviceSize.width(context),
            child: Center(
                child: GestureDetector(
                    onTap: () {
                      handleData();
                      if (currentMenu == Menu.activitiesTracker) {
                        today = today.copyWith(
                            activitiesTracker: activitiesTrackerList);
                      } else if (currentMenu == Menu.planTracker) {
                        today = today.copyWith(plansTracker: planTrackerList);
                      } else if (currentMenu == Menu.gratitudeJournal) {
                        today = today.copyWith(
                            gratitudeJournal: gratitudeJournalList);
                      }
                      stats.add(today);
                      stats.sort((a, b) => b.date.compareTo(a.date));
                      saveList(stats);
                      resetDataList();
                      setState(() {
                        currentMenu = Menu.routineQualityTracker;
                      });
                    },
                    child: Image.asset("assets/images/button.png")))),
      );
    } else {
      return const SizedBox.shrink();
    }
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
    return SizedBox(
      height: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                onTap: () async {
                  DateTime date =
                      await showCustomDateDialog(context, dateSelected);
                  dateSelected = date;
                  handleData(isRemove: false);
                  activitiesTrackerList = [...today.activitiesTracker];

                  setState(() {});
                },
                child: Text(
                  renderDate(dateSelected),
                  style: styles.copyWith(fontWeight: FontWeight.w700),
                )),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: DeviceSize.width(context),
          // height: DeviceSize.height(context, partNumber: 6) + 20,
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
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
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
      ]),
    );
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

          // if (type == 1) {
          //   // today = today.copyWith(activitiesTracker: dataList);
          //   activitiesTrackerList = dataList;
          // } else if (type == 2) {
          //   // today = today.copyWith(plansTracker: dataList);
          //   planTrackerList = dataList;
          // } else if (type == 3) {
          //   // today = today.copyWith(gratitudeJournal: dataList);
          //   gratitudeJournalList = dataList;
          // }
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
      const SizedBox(height: 120),
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
              onTap: () async {
                DateTime date =
                    await showCustomDateDialog(context, dateSelected);
                dateSelected = date;
                handleData(isRemove: false);
                activitiesTrackerList = [...today.activitiesTracker];
                setState(() {
                  sliderValue = today.percent;
                });
              },
              child: Text(renderDate(dateSelected),
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

  handleData({bool isRemove = true}) {
    today = stats.firstWhere(
        (element) =>
            element.date.year == dateSelected.year &&
            element.date.month == dateSelected.month &&
            element.date.day == dateSelected.day, orElse: () {
      return Stats(
        date: dateSelected,
        time: "${dateSelected.hour}:${dateSelected.minute}",
        moodIndex: 0,
        sleepStatsIndex: 0,
        percent: 0.5,
        activitiesTracker: [],
        plansTracker: [],
        gratitudeJournal: [],
      );
    });

    if (isRemove) {
      stats.removeWhere((element) =>
          element.date.year == dateSelected.year &&
          element.date.month == dateSelected.month &&
          element.date.day == dateSelected.day);
    }
  }

  calendarWidget() {
    List paths = ["b3.png", "b2.png", "b4.png", "b5.png", "b1.png"];

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
                onTap: () async {
                  DateTime date =
                      await showCustomDateDialog(context, dateSelected);
                  dateSelected = date;
                  handleData(isRemove: false);
                  resetDataList();

                  setState(() {});
                },
                child: Text(
                  renderDate(dateSelected),
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
                      handleData();
                      today = today.copyWith(moodIndex: index);
                      stats.add(today);
                      stats.sort((a, b) => b.date.compareTo(a.date));

                      saveList(stats);

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
                onTap: () async {
                  DateTime date =
                      await showCustomDateDialog(context, dateSelected);
                  dateSelected = date;
                  handleData(isRemove: false);
                  resetDataList();
                  setState(() {});
                },
                child: Text(
                  renderDate(dateSelected),
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
                      handleData();
                      today = today.copyWith(sleepStatsIndex: index);
                      stats.add(today);
                      stats.sort((a, b) => b.date.compareTo(a.date));

                      saveList(stats);

                      setState(() {
                        currentMenu = Menu.routineQualityTracker;
                      });
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
              onTap: () async {
                DateTime date =
                    await showCustomDateDialog(context, dateSelected);
                dateSelected = date;
                handleData(isRemove: false);
                planTrackerList = [...today.plansTracker];

                setState(() {});
              },
              child: Text(renderDate(dateSelected),
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
    sliderValue = today.percent;
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
                            handleData();
                            today = today.copyWith(percent: value);
                            stats.add(today);
                            stats.sort((a, b) => b.date.compareTo(a.date));

                            saveList(stats);

                            setState(() {
                              sliderValue = value;
                            });
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
    return Column(children: [
      // const SizedBox(height: 100),
      const Spacer(),
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
              onTap: () async {
                DateTime date =
                    await showCustomDateDialog(context, dateSelected);
                dateSelected = date;
                handleData(isRemove: false);
                gratitudeJournalList = [...today.gratitudeJournal];

                setState(() {});
              },
              child: Text(renderDate(dateSelected),
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
        height: DeviceSize.height(context, partNumber: 5) + 50,
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
              height: DeviceSize.height(context, partNumber: 5),
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
    ]);
  }

  myStats() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 140),
      SizedBox(
        height: DeviceSize.height(context, partNumber: 7) + 20,
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  currentMyStats = stats[index];
                  setState(() {
                    currentMenu = Menu.myStats2;
                  });
                },
                child: Padding(
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
                          Text(renderDate(stats[index].date),
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
                                          color: const Color.fromRGBO(
                                              62, 55, 81, 1),
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
      child: SingleChildScrollView(
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
              child: GestureDetector(
                onTap: () async {
                  DateTime date =
                      await showCustomDateDialog(context, dateSelected);
                  dateSelected = date;
                  handleData(isRemove: false);
                  currentMyStats = today;
                  setState(() {});
                },
                child: Row(children: [
                  Image.asset(
                    "assets/icons/calendar2.png",
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(renderDate(currentMyStats!.date),
                      style: styles.copyWith(
                          fontWeight: FontWeight.w700, fontSize: 14))
                ]),
              ),
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
                        Image.asset(
                            "assets/icons/${moodPath[currentMyStats!.moodIndex]}"),
                        const SizedBox(width: 5),
                        StrokeText(
                          text: moodNames[currentMyStats!.moodIndex],
                          insideColor: moodColors[currentMyStats!.moodIndex],
                          outsideColor: const Color.fromRGBO(62, 55, 81, 1),
                          fontSize: 15,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Image.asset(
                            "assets/icons/${sleepsPath[currentMyStats!.sleepStatsIndex]}"),
                        const SizedBox(width: 5),
                        StrokeText(
                          text: sleepNames[currentMyStats!.sleepStatsIndex],
                          insideColor:
                              sleepTrackColors[currentMyStats!.sleepStatsIndex],
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
                              currentMyStats!.activitiesTracker[index],
                              style: styles.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 5),
                        itemCount: currentMyStats!.activitiesTracker.length),
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
                              currentMyStats!.plansTracker[index],
                              style: styles.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 5),
                        itemCount: currentMyStats!.plansTracker.length),
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
                              currentMyStats!.gratitudeJournal[index],
                              style: styles.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 5),
                        itemCount: currentMyStats!.gratitudeJournal.length),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                left: 0,
                child: Text(
                  "${(percent * 100).toStringAsFixed(0)}%",
                  style: murechoStyle.copyWith(fontWeight: FontWeight.w700),
                )),
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
            Positioned(
                right: 0,
                child: Text(
                  "100%",
                  style: murechoStyle.copyWith(fontWeight: FontWeight.w700),
                )),
          ],
        ),
      ),
    );
  }

  void saveList(List<Stats> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList =
        list.map((item) => jsonEncode(item.toJson())).toList();
    prefs.setStringList('stats_list', encodedList);
  }

  Future<void> getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('stats_list');
    setState(() {
      if (encodedList != null) {
        stats = encodedList
            .map((String item) => Stats.fromJson(jsonDecode(item)))
            .toList();
        stats.sort((a, b) => b.date.compareTo(a.date));
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

      resetDataList();
      sliderValue = today.percent;
    });
  }

  bool isNotToday(DateTime dateTime) {
    DateTime now = DateTime.now();
    return dateTime.year != now.year ||
        dateTime.month != now.month ||
        dateTime.day != now.day;
  }

  bool isYesterday(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  renderDate(DateTime date) {
    String text = "";
    if (!isNotToday(date)) {
      text = "today: ";
    } else if (isYesterday(date)) {
      text = "yesterday: ";
    }
    return "$text${DateFormat('dd.MM.yyyy').format(date)} , ${"${DateTime.now().hour}:${DateTime.now().minute}"}";
  }

  resetDataList() {
    activitiesTrackerList = [...today.activitiesTracker];
    planTrackerList = [...today.plansTracker];
    gratitudeJournalList = [...today.gratitudeJournal];
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
