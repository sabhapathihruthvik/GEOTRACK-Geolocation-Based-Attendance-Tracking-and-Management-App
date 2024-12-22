import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  Future<Map<String, dynamic>> fetchUserData() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final email = user.email;

    final snapshot = await firestore.collection('employee').doc(email).get();

    if (snapshot.exists) {
      return snapshot.data()!;
    } else {
      throw Exception("Employee not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('User Info')),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                    color: Color.fromARGB(255, 179, 0, 255), fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'Employee not found',
                style: TextStyle(
                    color: Color.fromARGB(255, 16, 12, 12), fontSize: 18),
              ),
            );
          }

          final userData = snapshot.data!;
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(
                        'assets/profile_images/${userData["email"]}.png',
                      ),
                      onBackgroundImageError: (_, __) => SvgPicture.asset(
                        'assets/icons/placeholder.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildInfoRow("Name", userData['name']),
                  const Divider(
                      thickness: 1.2, color: Color.fromARGB(96, 173, 141, 141)),
                  buildInfoRow("Employee ID", userData['employeeID']),
                  const Divider(
                      thickness: 1.2, color: Color.fromARGB(96, 0, 0, 0)),
                  buildInfoRow("Designation", userData['designation']),
                  const Divider(thickness: 1.2, color: Colors.black38),
                  buildInfoRow("Department", userData['department']),
                  const Divider(thickness: 1.2, color: Colors.black38),
                  buildInfoRow("Email Address", userData['email']),
                  const Divider(thickness: 1.2, color: Colors.black38),
                  buildInfoRow("Phone Number", userData['phoneNumber']),
                  const Divider(thickness: 1.2, color: Colors.black38),
                  buildInfoRow("Address", userData['address']),
                  const Divider(thickness: 1.2, color: Colors.black38),
                  buildInfoRow(
                    "Joining Date",
                    userData['joiningDate'] ?? "Not provided",
                  ),
                  const Divider(thickness: 1.2, color: Colors.black38),
                  buildInfoRow(
                    "Performance Rating",
                    userData['performanceRating']?.toString() ?? "Not Rated",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromRGBO(159, 34, 255, 0.824),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
