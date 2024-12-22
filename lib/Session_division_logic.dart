// import 'dart:io'; // For user input
// // ignore: depend_on_referenced_packages
// import 'package:intl/intl.dart';

// void main() {
//   // Prompt user for input
//   print('Enter the start time hour (0-23):');
//   int startHour = int.parse(stdin.readLineSync()!);

//   print('Enter the end time hour (0-23):');
//   int endHour = int.parse(stdin.readLineSync()!);

//   // Validate input
//   if (startHour < 0 ||
//       startHour > 23 ||
//       endHour < 0 ||
//       endHour > 23 ||
//       startHour >= endHour) {
//     print(
//         'Invalid input. Start time should be less than end time, and within 0-23.');
//     return;
//   }

//   // Initialize time variables
//   DateTime now = DateTime.now();
//   DateTime firstSessionStart =
//       DateTime(now.year, now.month, now.day, startHour, 0);

//   int? currentSessionIndex =
//       findCurrentSession(now, firstSessionStart, endHour - startHour);

//   if (currentSessionIndex != null) {
//     DateTime sessionStart =
//         firstSessionStart.add(Duration(hours: currentSessionIndex));
//     DateTime sessionEnd = sessionStart.add(const Duration(hours: 1));

//     print('Current session #${currentSessionIndex + 1}:');
//     print('Start: ${DateFormat('HH:mm').format(sessionStart)}');
//     print('End: ${DateFormat('HH:mm').format(sessionEnd)}');
//   } else {
//     print('No session is active at the moment.');
//   }
// }

// int? findCurrentSession(
//     DateTime currentTime, DateTime firstSessionStart, int totalSessions) {
//   for (int i = 0; i < totalSessions; i++) {
//     DateTime sessionStart = firstSessionStart.add(Duration(hours: i));
//     DateTime sessionEnd = sessionStart.add(const Duration(hours: 1));

//     if (currentTime.isAfter(sessionStart) && currentTime.isBefore(sessionEnd)) {
//       return i;
//     }
//   }
//   return null;
// }


// // // ignore: depend_on_referenced_packages
// // import 'package:intl/intl.dart';

// // void main() {
// //   DateTime now = DateTime.now();
// //   DateTime firstSessionStart = DateTime(now.year, now.month, now.day, 9, 0);

// //   int? currentSessionIndex = findCurrentSession(now, firstSessionStart);

// //   if (currentSessionIndex != null) {
// //     DateTime sessionStart =
// //         firstSessionStart.add(Duration(hours: currentSessionIndex));
// //     DateTime sessionEnd = sessionStart.add(const Duration(hours: 1));

// //     print('Current session #${currentSessionIndex + 1}:');
// //     print('Start: ${DateFormat('HH:mm').format(sessionStart)}');
// //     print('End: ${DateFormat('HH:mm').format(sessionEnd)}');
// //   } else {
// //     print('No session is active at the moment.');
// //   }
// // }

// // int? findCurrentSession(DateTime currentTime, DateTime firstSessionStart) {
// //   for (int i = 0; i < 15; i++) {
// //     DateTime sessionStart = firstSessionStart.add(Duration(hours: i));
// //     DateTime sessionEnd = sessionStart.add(const Duration(hours: 1));

// //     if (currentTime.isAfter(sessionStart) && currentTime.isBefore(sessionEnd)) {
// //       return i;
// //     }
// //   }
// //   return null;
// // }
