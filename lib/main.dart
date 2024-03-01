import 'package:flutter/material.dart';
import 'package:routine_quality_tracker/custom_datetime.dart';
import 'package:routine_quality_tracker/device_size.dart';
import 'package:routine_quality_tracker/primary_background.dart';
import 'package:routine_quality_tracker/stroke_text.dart';

void main() {
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
  List<String> notes = [];
  Menu currentMenu = Menu.routineQualityTracker;
  CustomDateTime customDateTime = const CustomDateTime();
  double sliderValue = 0.0;

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
        return planTracker();
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
        return titles[5];
      default:
    }
  }

  homeScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 5),
          child: Image.asset("assets/icons/Vector.png"),
        ),
        const SizedBox(height: 15),
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
              Image.asset(
                "assets/images/Group 7.png",
                scale: 0.1,
                width: DeviceSize.width(context, partNumber: 5),
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
              child: const Text("today: 12.02.24, 12:00")),
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
                body: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 12,
                  itemBuilder: (context, index) => TextField(
                    onChanged: (text) {
                      if (index > -1 && index < notes.length) {
                        if (text == "") {
                          notes.removeAt(index);
                        } else {
                          notes[index] = text;
                        }
                      } else {
                        notes.add(text);
                      }
                    },
                    minLines: 1,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      hintText: index < notes.length + 1 ? "+" : "",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    enabled: index < notes.length + 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
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
              child: const Text("today: 12.02.24, 12:00")),
        ],
      ),
      const SizedBox(height: 40),
      progressbar(context)
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
    List name = ["great", "fine", "not very good", "bad", "terrible"];
    List<Color> colors = const [
      Color.fromRGBO(0, 173, 152, 1),
      Color.fromRGBO(118, 173, 0, 1),
      Color.fromRGBO(42, 132, 216, 1),
      Color.fromRGBO(229, 131, 40, 1),
      Color.fromRGBO(221, 0, 0, 1),
    ];

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
                child: const Text("today: 12.02.24, 12:00")),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              paths.length,
              (index) => Padding(
                    padding: EdgeInsets.all(index == 2 ? 0.0 : 8.0),
                    child: Column(
                      children: [
                        Image.asset("assets/icons/${paths[index]}"),
                        const SizedBox(height: 5),
                        Text(
                          name[index],
                          style: TextStyle(fontSize: 13, color: colors[index]),
                        )
                      ],
                    ),
                  )),
        )
      ],
    );
  }

  sleepTrackWidget() {
    List paths = ["a1.png", "a2.png", "a3.png", "a4.png"];
    List name = [
      "good sleep",
      "average sleep",
      "insufficient sleep",
      "insomnia"
    ];
    List<Color> colors = const [
      Color.fromRGBO(0, 173, 152, 1),
      Color.fromRGBO(118, 173, 0, 1),
      Color.fromRGBO(42, 132, 216, 1),
      Color.fromRGBO(221, 0, 0, 1),
    ];

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
                child: const Text("today: 12.02.24, 12:00")),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              paths.length,
              (index) => Column(
                    children: [
                      Image.asset("assets/icons/${paths[index]}"),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 75,
                        child: Text(
                          name[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: colors[index]),
                        ),
                      )
                    ],
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
              child: const Text("today: 12.02.24, 12:00")),
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
                body: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 12,
                  itemBuilder: (context, index) => TextField(
                    onChanged: (text) {
                      if (index > -1 && index < notes.length) {
                        if (text == "") {
                          notes.removeAt(index);
                        } else {
                          notes[index] = text;
                        }
                      } else {
                        notes.add(text);
                      }
                    },
                    minLines: 1,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      hintText: index < notes.length + 1 ? "..." : "",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    enabled: index < notes.length + 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }

  progressbar(context) {
    return Center(
      child: SizedBox(
        width: DeviceSize.height(context, partNumber: 4) - 20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 5,
                child: Text("${(sliderValue * 100).toStringAsFixed(0)}%")),
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
                            setState(() {
                              sliderValue = value;
                            });
                            print("sliderValue:$sliderValue");
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(right: 5, child: Text("100%")),
          ],
        ),
      ),
    );
  }

  gratitudeJournal() {
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
              child: const Text("today: 12.02.24, 12:00")),
        ],
      ),
      const Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
        child: Text(
            "It is extremely important to remember what you are grateful for in this life. Think of the people and things you love and write gratitude notes!"),
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
                body: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 12,
                  itemBuilder: (context, index) => TextField(
                    onChanged: (text) {
                      if (index > -1 && index < notes.length) {
                        if (text == "") {
                          notes.removeAt(index);
                        } else {
                          notes[index] = text;
                        }
                      } else {
                        notes.add(text);
                      }
                    },
                    minLines: 1,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      hintText: index < notes.length + 1 ? "..." : "",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    enabled: index < notes.length + 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
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
  myStats
}
