import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AttendanceHistoryScreenState createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  String _userName = '';
  Map<String, List<dynamic>> _attendanceData = {};
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;

    if (user != null) {
      final email = user.email;
      final snapshot = await firestore.collection('employee').doc(email).get();

      if (snapshot.exists) {
        setState(() {
          _userName = snapshot.data()?['name'] ?? 'Unknown User';
        });
      }
    }
  }

  Future<void> _fetchAttendanceData(DateTime selectedDay) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;

    if (user != null) {
      final email = user.email;
      final dateStr =
          '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}';

      final snapshot = await firestore
          .collection('employee')
          .doc(email)
          .collection('attendance')
          .doc(dateStr)
          .get();

      if (snapshot.exists) {
        setState(() {
          _attendanceData = Map<String, List<dynamic>>.from(snapshot.data()!);
        });
      } else {
        setState(() {
          _attendanceData = {};
        });
      }
    }
  }

  void _showEventPopup(BuildContext context, DateTime selectedDay) async {
    await _fetchAttendanceData(selectedDay);

    bool isToday = isSameDay(selectedDay, DateTime.now());

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Attendance on ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
            style: const TextStyle(color: Colors.deepPurple),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Employee: $_userName',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Selected Date: ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
                  style: TextStyle(
                      color: isToday ? Colors.green : Colors.black,
                      fontSize: 16),
                ),
                Text(
                  'Current Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 30),
                _attendanceData.isEmpty
                    ? const Text(
                        'No attendance data available',
                        style: TextStyle(fontSize: 16),
                      )
                    : Table(
                        border: TableBorder.all(color: Colors.black, width: 1),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(2),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Session',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Status',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Time',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                          ..._attendanceData.entries.map(
                            (entry) {
                              final session = entry.key;
                              final presence =
                                  entry.value[0] as bool ? 'P' : 'A';
                              final timestamp = entry.value[1] as String;
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(session,
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(presence,
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(timestamp,
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Close', style: TextStyle(color: Colors.blueGrey)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Attendance History')),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              firstDay: DateTime.utc(DateTime.now().year - 1, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showEventPopup(context, selectedDay);
              },
              eventLoader: (day) {
                return [];
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.blue,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.blue,
                ),
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 119, 192, 228),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle:
                    TextStyle(color: Color.fromARGB(255, 150, 64, 255)),
                todayTextStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
