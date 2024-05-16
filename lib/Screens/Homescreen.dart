// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Task({required this.name, required this.description});
}

class _HomeScreenState extends State<HomeScreen> {
  //initialize variable login hours,minutes ,seconds from login page
  late int loginHours;
  late int loginMinutes;
  late int loginSeconds;
  late String logintime;
  late DateTime loginDateTime;
  int idletime = 0;

  //task textediting controller
  TextEditingController taskname = TextEditingController();
  TextEditingController taskdescription = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //accesing login hours,minutes ,seconds from login page
    getLoginTime();
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

  // List to store tasks
  List<Task> tasks = [];

  // Method to add a new task to the list
  void addTask() {
    setState(() {
      // Create a new task from the entered name and description
      Task newTask =
          Task(name: taskname.text, description: taskdescription.text);
      // Add the new task to the list
      tasks.add(newTask);
      // Clear the text fields after adding the task
      taskname.clear();
      taskdescription.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IdleDetector(
      idleTime: Duration(milliseconds: 15),
      onIdle: (data) {
        //show dialog box when user is idle for 2 minutes
        Get.snackbar("Error", "You are in Idle Stage Return to your Work");
        setState(() {
          idletime += DateTime.now().millisecond;
        });

        // You can use this idle duration as needed
      },
      child: Scaffold(
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
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 40,
                                decoration:
                                    BoxDecoration(color: Colors.red[400]),
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
                                      "${idletime}",
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
                                      tasks.length.toString(),
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
                                    Text(
                                      "Task Update",
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
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
                                            color: Colors.black.withOpacity(
                                                0.17000000178813934),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: taskname,
                                        decoration: InputDecoration(
                                          hintText: 'Task Name',
                                          hintStyle: GoogleFonts.poppins(
                                            color: Colors.black.withOpacity(
                                                0.5400000214576721),
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
                                            color: Colors.black.withOpacity(
                                                0.17000000178813934),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: taskdescription,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null, // Allow multiple lines
                                        textInputAction:
                                            TextInputAction.newline,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Descriptive Points & Work Done',
                                          hintStyle: GoogleFonts.poppins(
                                            color: Colors.black.withOpacity(
                                                0.5400000214576721),
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
                                            addTask();
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        GestureDetector(
                                          onTap: () {},
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
                                                    "Complete Task",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
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
                                    Container(
                                      height: Get.height * 0.5,
                                      child: Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: tasks.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              color: Colors.purple.shade50,
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
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            border: Border.all(
                                                                color: HexColor(
                                                                    "#690ABF"),
                                                                width: 1)),
                                                        child: Center(
                                                          child: Text(
                                                            tasks[index].name,
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        16.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 190,
                                                      ),
                                                      Container(
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
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      tasks[index].description,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
