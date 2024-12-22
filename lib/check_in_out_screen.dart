import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class CheckInOutScreen extends StatefulWidget {
  const CheckInOutScreen({super.key});

  @override
  State<CheckInOutScreen> createState() => _CheckInOutScreenState();
}

class _CheckInOutScreenState extends State<CheckInOutScreen> {
  late Future<Map<String, dynamic>> sessionDataFuture;
  Map<String, bool> attendanceStatus = {};

  @override
  void initState() {
    super.initState();
    sessionDataFuture = fetchUserSessionData();
  }

  Future<void> _markAttendance(String sessionKey) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user is currently logged in.");
      }

      String email = user.email ?? "";
      if (email.isEmpty) {
        throw Exception("User email is not available.");
      }

      DateTime now = DateTime.now();
      String todayDate = DateFormat('yyyy-MM-dd').format(now);
      String formattedTime = DateFormat('HH:mm:ss').format(now);

      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      double deviceLatitude = position.latitude;
      double deviceLongitude = position.longitude;

      double referenceLatitude = 17.357936842091643;
      double referenceLongitude = 78.50784671075692;

      double distanceInMeters = Geolocator.distanceBetween(
        referenceLatitude,
        referenceLongitude,
        deviceLatitude,
        deviceLongitude,
      );
      double distanceInKilometers = distanceInMeters / 1000;

      if (distanceInKilometers > 0.3) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You are not within range! You are ${distanceInKilometers.toStringAsFixed(2)} km away.Please try again after getting into 1km range.',
            ),
          ),
        );
        return;
      }

      DocumentReference attendanceDoc = FirebaseFirestore.instance
          .collection('employee')
          .doc(email)
          .collection('attendance')
          .doc(todayDate);

      DocumentSnapshot docSnapshot = await attendanceDoc.get();
      Map<String, dynamic> data =
          docSnapshot.exists ? docSnapshot.data() as Map<String, dynamic> : {};

      data[sessionKey] = [
        true,
        formattedTime,
        deviceLatitude.toString(),
        deviceLongitude.toString(),
        "${distanceInKilometers.toStringAsFixed(2)} KM"
      ];

      await attendanceDoc.set(data);

      setState(() {
        attendanceStatus[sessionKey] = true;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance marked successfully!')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error marking attendance: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> fetchUserSessionData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No user is currently logged in.");
    }

    String documentID = user.email ?? "";
    if (documentID.isEmpty) {
      throw Exception("User email is not available.");
    }

    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('employee')
        .doc(documentID)
        .get();

    if (docSnapshot.exists) {
      return docSnapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('No session data found for the user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Check-In/Out Session')),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: sessionDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Error fetching session data.'),
            );
          }

          int? startTime = snapshot.data!['Start Time'] as int?;
          int? endTime = snapshot.data!['End Time'] as int?;

          if (startTime == null || endTime == null) {
            return const Center(
              child: Text('Start Time or End Time is missing in the database.'),
            );
          }

          DateTime now = DateTime.now();
          DateTime firstSessionStart =
              DateTime(now.year, now.month, now.day, startTime, 0);

          int totalSessions = endTime - startTime;
          int? currentSessionIndex =
              findCurrentSession(now, firstSessionStart, totalSessions);

          return FutureBuilder(
            future: fetchAttendanceData(),
            builder: (context, attendanceSnapshot) {
              if (attendanceSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (attendanceSnapshot.hasError || !attendanceSnapshot.hasData) {
                return const Center(
                  child: Text('Error fetching attendance data.'),
                );
              }

              Map<String, dynamic> attendanceData =
                  attendanceSnapshot.data as Map<String, dynamic>;

              return ListView.builder(
                itemCount: totalSessions,
                itemBuilder: (context, index) {
                  DateTime sessionStart =
                      firstSessionStart.add(Duration(hours: index));
                  DateTime sessionEnd =
                      sessionStart.add(const Duration(hours: 1));

                  String sessionKey = '${sessionStart.hour}-${sessionEnd.hour}';
                  bool isMarked = attendanceData.containsKey(sessionKey);

                  Color sessionColor;
                  if (currentSessionIndex == index) {
                    sessionColor = const Color.fromARGB(255, 76, 175, 168);
                  } else if (sessionStart.isBefore(now)) {
                    sessionColor = const Color.fromARGB(255, 59, 147, 255);
                  } else {
                    sessionColor = Colors.grey;
                  }

                  return Card(
                    color: sessionColor,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Session #${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Start: ${DateFormat('HH:mm').format(sessionStart)}\n'
                        'End: ${DateFormat('HH:mm').format(sessionEnd)}\n'
                        'Status: ${isMarked ? 'Present' : 'Absent'}',
                        style: TextStyle(
                          color: sessionColor == Colors.green
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      trailing: currentSessionIndex == index
                          ? ElevatedButton(
                              onPressed: isMarked
                                  ? null
                                  : () => _markAttendance(sessionKey),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isMarked ? Colors.grey : Colors.blue,
                              ),
                              child:
                                  Text(isMarked ? 'Marked' : 'Mark Attendance'),
                            )
                          : isMarked
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchAttendanceData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No user is currently logged in.");
    }

    String email = user.email ?? "";
    if (email.isEmpty) {
      throw Exception("User email is not available.");
    }

    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('employee')
        .doc(email)
        .collection('attendance')
        .doc(todayDate)
        .get();

    if (docSnapshot.exists) {
      return docSnapshot.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  int? findCurrentSession(
      DateTime currentTime, DateTime firstSessionStart, int totalSessions) {
    for (int i = 0; i < totalSessions; i++) {
      DateTime sessionStart = firstSessionStart.add(Duration(hours: i));
      DateTime sessionEnd = sessionStart.add(const Duration(hours: 1));

      if (currentTime.isAfter(sessionStart) &&
          currentTime.isBefore(sessionEnd)) {
        return i;
      }
    }
    return null;
  }
}
