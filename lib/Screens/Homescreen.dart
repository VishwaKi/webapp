// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, sort_child_properties_last

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:idle_detector/idle_detector.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Define a class to represent a task
class Task {
  final String name;
  final String description;
  String status;

  Task({required this.name, required this.description, required this.status});
}

class _HomeScreenState extends State<HomeScreen> {
  //initialize variable login hours,minutes ,seconds from login page
  late int loginHours;
  late int loginMinutes;
  late int loginSeconds;
  late String logintime;
  late DateTime loginDateTime;

  //Duration
  Duration idleDuration = Duration();

  //taskcompletedcount
  int taskcompletedcount = 0;

  //task textediting controller
  TextEditingController taskname = TextEditingController();
  TextEditingController taskdescription = TextEditingController();
  //checking the status of the task
  String selectedValue = "Active";

  //assign the status to another variable
  late String taskstatus;

  //timer
  late Timer _timer;
  late Timer _idletimer;

  bool idlevalue = false;

  //focusing textfield
  final FocusNode textFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    //accesing login hours,minutes ,seconds from login page
    getLoginTime();
    overlaytimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  //calculate the login time of user.
  void getLoginTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      loginHours = prefs.getInt('loginHours') ?? 0;
      loginMinutes = prefs.getInt('loginMinutes') ?? 0;
      loginSeconds = prefs.getInt('loginSeconds') ?? 0;
      logintime = prefs.getString('loginTime').toString();
      loginDateTime = DateTime.parse(logintime);
    });
  }

  //calculate idle time
  //start timer
  void startidletimer() {
    _idletimer = Timer.periodic(Duration(seconds: 1), (timer) => addTime());
    idlevalue = true;
  }

//pausetimer
  void pause() {
    _idletimer.cancel();
  }

//inrement time duration
  void addTime() {
    final addseconds = 1;
    setState(() {
      final seconds = idleDuration.inSeconds + addseconds;
      idleDuration = Duration(seconds: seconds);
    });
  }

  //overlat timer
  void overlaytimer() {
    Timer.periodic(Duration(minutes: 10), (timer) => _showOverlay());
  }

  //overlay
  void _showOverlay() {
    taskstatus = selectedValue;
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black)),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              'Task Update',
              style: GoogleFonts.poppins(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            content: Text(
              'Your task is in progress, Update for every one hour',
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.5400000214576721),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (taskname.text.isNotEmpty &&
                      taskdescription.text.isNotEmpty) {
                    // Perform any actions you need to here

                    // Close the overlay
                    Navigator.pop(context);
                    addTask();
                  } else if (taskname.text.isEmpty ||
                      taskdescription.text.isEmpty) {
                    Get.snackbar("Task Error",
                        "First Active the task and write what you done");
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: Get.width * 0.32,
                  height: 50,
                  decoration: BoxDecoration(
                    color: HexColor("#690ABF"),
                    gradient: LinearGradient(colors: [
                      HexColor("#690ABF"),
                      HexColor("#690ABF").withOpacity(0.8),
                      HexColor("#690ABF").withOpacity(0.6),
                      HexColor("#690ABF").withOpacity(0.4),
                      HexColor("#690ABF").withOpacity(0.2),
                    ]),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      "Update Now",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

// List to store tasks
  List<Task> tasks = [];

  // Method to add a new task to the list
  /*void addTask() {
    setState(() {
      if (taskname.text.isNotEmpty &&
          taskdescription.text.isNotEmpty &&
          taskstatus.isNotEmpty) {
        // Check if there's already an active task
        bool hasActiveTask = tasks.any((task) => task.status == "Active");
        bool hasidletask = tasks.any((task) => task.status == "Idle");
        bool hastaskname = tasks.any((task) => task.name == taskname.text);

        if (!hasActiveTask || taskstatus != "Active") {
          // Create a new task from the entered name and description
          if (taskstatus == "Active") {
            print("hello");
            if (hasidletask) {
              //tasks.removeWhere((task) =&gt; task.status == "Idle");
              for (int i = 0; i < tasks.length; i++) {
                if (tasks[i].name == taskname.text) {
                  setState(() {
                    _idletimer.cancel();
                    tasks[i].status = taskstatus;

                    selectedValue = "Active";
                  });
                }
              }
            } else {
              Task newTask = Task(
                name: taskname.text,
                description: taskdescription.text,
                status: taskstatus,
              );
              // Add the new task to the list
              tasks.add(newTask);
            }
          } else if (taskstatus == "Completed") {
            // Find the task with the entered name and change its status to "Completed"

            for (int i = 0; i < tasks.length; i++) {
              if (tasks[i].name == taskname.text) {
                if (idlevalue) {
                  pause();
                  setState(() {
                    idlevalue = false;
                  });
                  taskname.clear();
                  taskdescription.clear();
                  tasks[i].status = taskstatus;
                  taskcompletedcount +=
                      1; // Increment completed count only if status changed from "Active" to "Completed"
                  selectedValue = "Active";
                } else {
                  taskname.clear();
                  taskdescription.clear();
                  tasks[i].status = taskstatus;
                  taskcompletedcount +=
                      1; // Increment completed count only if status changed from "Active" to "Completed"
                  selectedValue = "Active";
                }
              }
            }
          } else if (taskstatus == "Idle") {
            // Find the task with the entered name and change its status to "Completed"
            if (!hasidletask) {
              for (int i = 0; i < tasks.length; i++) {
                if (tasks[i].name == taskname.text) {
                  startidletimer();

                  setState(() {
                    tasks[i].status = taskstatus;

                    selectedValue = "Idle";
                  });
                }
              }
            }
          }
        } else {
          // Display an error message if an active task already exists
          Get.snackbar("Error", "An active task already exists.");
        }
      } else if (taskname.text.isEmpty) {
        Get.snackbar(
          "Task Error",
          "Task Name is empty",
          padding: const EdgeInsets.all(15),
          margin: EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: Get.width * 0.713,
          ),
        );
      } else if (taskdescription.text.isEmpty) {
        Get.snackbar(
          "Task Error",
          "Task Description is empty",
          padding: const EdgeInsets.all(15),
          margin: EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: Get.width * 0.713,
          ),
        );
      }
    });
  }
*/
  void addTask() {
    setState(() {
      if (taskname.text.isNotEmpty &&
          taskdescription.text.isNotEmpty &&
          taskstatus.isNotEmpty) {
        // Check if there's already an active task
        bool hasActiveTask = tasks.any((task) => task.status == "Active");
        bool hasIdleTask = tasks.any((task) => task.status == "Idle");
        bool hasTaskName = tasks.any((task) => task.name == taskname.text);

        if (!hasActiveTask || taskstatus != "Active") {
          // Handle status transitions
          if (taskstatus == "Active") {
            if (hasIdleTask && hasTaskName) {
              for (int i = 0; i < tasks.length; i++) {
                if (tasks[i].name == taskname.text) {
                  _idletimer.cancel();
                  tasks[i].status = taskstatus;
                  selectedValue = "Active";
                  break;
                }
              }
            } else if (!hasTaskName) {
              Task newTask = Task(
                name: taskname.text,
                description: taskdescription.text,
                status: taskstatus,
              );
              tasks.add(newTask);
            } else {
              Get.snackbar("Error", "Task with this name already exists.");
            }
          } else if (taskstatus == "Completed") {
            // Find the task with the entered name and change its status to "Completed"

            for (int i = 0; i < tasks.length; i++) {
              if (tasks[i].name == taskname.text &&
                  tasks[i].status == "Active") {
                if (idlevalue) {
                  pause();
                  setState(() {
                    idlevalue = false;
                  });
                  taskname.clear();
                  taskdescription.clear();
                  tasks[i].status = taskstatus;
                  taskcompletedcount +=
                      1; // Increment completed count only if status changed from "Active" to "Completed"
                  selectedValue = "Active";
                } else {
                  taskname.clear();
                  taskdescription.clear();
                  tasks[i].status = taskstatus;
                  taskcompletedcount +=
                      1; // Increment completed count only if status changed from "Active" to "Completed"
                  selectedValue = "Active";
                }
              }
            }
          } else if (taskstatus == "Idle") {
            if (!hasIdleTask) {
              for (int i = 0; i < tasks.length; i++) {
                if (tasks[i].name == taskname.text) {
                  startidletimer();
                  tasks[i].status = taskstatus;
                  selectedValue = "Idle";
                  break;
                }
              }
            } else {
              Get.snackbar("Error", "An idle task already exists.");
            }
          }
        } else {
          Get.snackbar("Error", "An active task already exists.");
        }
      } else {
        if (taskname.text.isEmpty) {
          Get.snackbar(
            "Task Error",
            "Task Name is empty",
            padding: const EdgeInsets.all(15),
            margin: EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: Get.width * 0.713,
            ),
          );
        }
        if (taskdescription.text.isEmpty) {
          Get.snackbar(
            "Task Error",
            "Task Description is empty",
            padding: const EdgeInsets.all(15),
            margin: EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: Get.width * 0.713,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              width: Get.width * 0.23,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Get.height * 0.22,
                    color: Colors.purple[50],
                    child: Padding(
                      padding: const EdgeInsets.only(top: 33.5, left: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: Get.height * 0.135,
                            padding: const EdgeInsets.all(8),
                            child: Image.asset("images/2.png"),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: HexColor("9979fc"), width: 2),
                                borderRadius: BorderRadius.circular(18)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Vishwa.L",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: Get.width * 0.1,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: HexColor("#E57FF7"),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "App Developer",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      height: Get.height * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.home,
                                color: HexColor("9979fc"),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  "Home",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1.5,
                            endIndent: 14,
                            color: HexColor("#DAD1DB"),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: HexColor("9979fc"),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  "Tasks",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1.5,
                            endIndent: 14,
                            color: HexColor("#DAD1DB"),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.task,
                                color: HexColor("9979fc"),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  "History Tasks",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1.5,
                            endIndent: 14,
                            color: HexColor("#DAD1DB"),
                          ),
                          const Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              setState(() {
                                prefs.clear();
                              });
                              Get.toNamed('/');
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(color: Colors.red[400]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.exit_to_app,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      "Logout",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Get.height,
              width: 1,
              color: HexColor("#DAD1DB"),
            ),
            Container(
              color: HexColor("#E5EAE9"),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width * 0.769,
                    height: 70,
                    color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Dashboard",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        IconButton(
                          onPressed: () {
                            //refresh();
                          },
                          icon: Icon(
                            Icons.refresh_sharp,
                            color: Colors.amber,
                          ),
                        ),
                        Text(
                          "Login Session",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: Get.width * 0.061,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: HexColor("#18D952"),
                          ),
                          child: Center(
                            child: Text(
                              "${loginHours}:${loginMinutes}:${loginSeconds}",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: Get.width * 0.15,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: HexColor("#690ABF"),
                          ),
                          child: Center(
                            child: Text(
                              //"${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}",
                              "${DateFormat.yMMMEd().format(DateTime.now())}",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1.5,
                    width: Get.width * 0.769,
                    color: HexColor("#DAD1DB"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              width: 200,
                              height: Get.height * 0.15,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Today",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    "${DateTime.now().difference(loginDateTime).inHours}H:${DateTime.now().difference(loginDateTime).inMinutes.remainder(60)}M:${DateTime.now().difference(loginDateTime).inSeconds.remainder(60)}S",
                                    style: GoogleFonts.poppins(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              width: 200,
                              height: Get.height * 0.15,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Idle Time",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    "${idleDuration.inHours.remainder(60)}H:${idleDuration.inMinutes.remainder(60)}M:${idleDuration.inSeconds.remainder(60)}S",
                                    style: GoogleFonts.poppins(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              width: 200,
                              height: Get.height * 0.15,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tasks completed",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    taskcompletedcount.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: Get.height * 0.8,
                              width: Get.width * 0.305,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Task Update",
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 130,
                                        decoration: ShapeDecoration(
                                          color: HexColor("F7F7F7"),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1.50,
                                              color: Colors.black.withOpacity(
                                                  0.17000000178813934),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: DropdownButton(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 7),
                                          underline: Container(),
                                          value: selectedValue,
                                          items: const [
                                            DropdownMenuItem(
                                                child: Text("Active"),
                                                value: "Active"),
                                            DropdownMenuItem(
                                                child: Text("InActive"),
                                                value: "InActive"),
                                            DropdownMenuItem(
                                                child: Text("Idle"),
                                                value: "Idle"),
                                            DropdownMenuItem(
                                                child: Text("Completed"),
                                                value: "Completed"),
                                          ],
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedValue = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 56,
                                    decoration: ShapeDecoration(
                                      color: HexColor("F7F7F7"),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1.50,
                                          color: Colors.black
                                              .withOpacity(0.17000000178813934),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: taskname,
                                      autofocus: true,
                                      onSubmitted: (value) {
                                        textFocusNode.requestFocus();
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Task Name',
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.black
                                              .withOpacity(0.5400000214576721),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                      ),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black
                                            .withOpacity(0.5400000214576721),
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 300,
                                    decoration: ShapeDecoration(
                                      color: HexColor("F7F7F7"),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1.50,
                                          color: Colors.black
                                              .withOpacity(0.17000000178813934),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: taskdescription,
                                      focusNode: textFocusNode,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null, // Allow multiple lines
                                      textInputAction: TextInputAction.newline,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Descriptive Points & Work Done',
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.black
                                              .withOpacity(0.5400000214576721),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                      ),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black
                                            .withOpacity(0.5400000214576721),
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            taskstatus = selectedValue;
                                            addTask();
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(13),
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: HexColor("#690ABF"),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.domain_verification,
                                                  color: Colors.white,
                                                  size: 26.8,
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  //"${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}",
                                                  "Update Task",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(16.5),
                            width: Get.width * 0.418,
                            height: Get.height * 0.63,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Completed Tasks",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 1.5,
                                  width: Get.width * 0.769,
                                  color: HexColor("#DAD1DB"),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: ShapeDecoration(
                                          color: HexColor("F7F7F7"),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1.50,
                                              color: Colors.black.withOpacity(
                                                  0.17000000178813934),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        width: Get.width * 0.4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: Get.width * 0.2,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: HexColor("#690ABF"),
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      HexColor("#690ABF"),
                                                      HexColor("#690ABF")
                                                          .withOpacity(0.8),
                                                      HexColor("#690ABF")
                                                          .withOpacity(0.6),
                                                      HexColor("#690ABF")
                                                          .withOpacity(0.4),
                                                      HexColor("#690ABF")
                                                          .withOpacity(0.2),
                                                    ]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      tasks[index].name,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 190,
                                                ),
                                                tasks[index].status == "Active"
                                                    ? Container(
                                                        width: Get.width * 0.06,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: HexColor(
                                                              "#18D952"),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Active",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : tasks[index]
                                                            .status
                                                            .contains(
                                                                "Completed")
                                                        ? Container(
                                                            width: Get.width *
                                                                0.06,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "Completed",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : tasks[index].status ==
                                                                "Idle"
                                                            ? Container(
                                                                width:
                                                                    Get.width *
                                                                        0.06,
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .cyan,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Idle",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                width:
                                                                    Get.width *
                                                                        0.06,
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          180,
                                                                          4,
                                                                          4),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "InActive",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 8,
                                                  left: 8,
                                                  right: 20),
                                              child: Text(
                                                tasks[index].description,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
