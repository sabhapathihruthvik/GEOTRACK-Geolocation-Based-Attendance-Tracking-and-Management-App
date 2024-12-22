# GEOTRACK-Geolocation-Based Attendance Tracking and Management App

Welcome to the **GEOTRACK-Geolocation-Based Attendance Tracking and Management System** repository! This system provides an efficient, accurate, and user-friendly way of managing employee attendance based on their geographical location. It is designed for organizations that wish to streamline their attendance tracking using advanced geolocation technology integrated with a vibrant UI/UX design.

---

## 🎯 **Key Features**

### 📍 Geolocation-Based Check-In/Out
- Employees can mark their attendance only within a specified radius (1 km by default) of the workplace.
- Real-time location validation using precise latitude and longitude coordinates.
- Displays a notification if an employee is outside the allowed range with details on their exact distance from the workplace.

### 🕒 Real-Time Session-Based Attendance
- Breaks the workday into multiple sessions based on organizational schedules.
- Displays session timings dynamically, allowing employees to check in for specific active sessions.
- Highlights missed sessions to ensure better compliance.

### 📜 Detailed Employee Information
- A centralized **User Info Screen** displaying:
  - Personal Details (Name, Email, Designation, etc.)
  - Work Details (Employee ID, Department, Performance Rating, etc.)
  - Contact Information (Phone Number, Address, etc.)
- All data is fetched securely from the Firestore database.

### 📊 Firebase Integration
- Real-time data synchronization powered by **Firebase Firestore**.
- Secure authentication using **Firebase Authentication** to ensure access only to authorized employees.
- Attendance history and status are stored efficiently in subcollections.

### 🚦 Intuitive UI/UX Design
- Vibrant color palette (Purple, Indigo, Blue, etc.) to enhance user engagement.
- Dynamic visuals to differentiate session statuses:
  - **Current Session**: Highlighted in teal.
  - **Missed Sessions**: Marked in blue.
  - **Upcoming Sessions**: Grayed out.

---

## 🛠️ **Technologies Used**

### Frontend
- **Flutter**: Crafting an elegant and interactive user interface.
- **Dart**: Ensuring robust business logic and seamless navigation.

### Backend
- **Firebase Firestore**: A scalable, cloud-based NoSQL database.
- **Firebase Authentication**: Secure user login and data access.

### Location Services
- **Geolocator**: Accurate tracking of device location for geofencing.
- **intl Package**: Simplifies date and time formatting.

---

## 🗂️ **App Workflow Overview**

### **1. User Login**
   - Employees log in securely using Firebase Authentication.

### **2. Check-In/Out Screen**
   - Displays all available sessions with respective timings.
   - Allows marking attendance for active sessions, based on geolocation validation.

### **3. User Information Screen**
   - Centralized view of employee-specific information fetched from Firestore.
   - Displays profile data, organizational details, and performance metrics.

---

## 🎥 **Mockup Videos/Images and Previews**

### ▶️ **Login Screen Walkthrough**
_A detailed walkthrough of the secure user login process, demonstrating error handling and seamless access._

![LockScreen](https://github.com/user-attachments/assets/029d5c31-4f3e-4352-8aad-f65f91f07226)

![LoginScreen](https://github.com/user-attachments/assets/ae10dcd9-0973-4426-86ed-faed88c66caf)

### ▶️ **Attendance History**
_Accessing the users attendance upto one year prior._
![AttendanceHistory](https://github.com/user-attachments/assets/5ce2f113-d84d-4017-9695-57c75696a9e5)
![Screenshot (204)](https://github.com/user-attachments/assets/7c839426-3460-4c87-9d14-7cea6eeb69c9)


### ▶️ **Check-In/Out Process**
_Showcasing how employees can mark their attendance based on real-time geolocation validation._
![Screenshot (207)](https://github.com/user-attachments/assets/2a9336ba-5cf8-4856-8d5d-6a1cee1f87ee)
![CheckInOut](https://github.com/user-attachments/assets/dd0c3ca2-0954-438a-8a73-2c52691f90f0)

### ▶️ **User Info Dashboard**
_A complete demonstration of the information displayed for employees, retrieved dynamically from Firestore._
![Profile](https://github.com/user-attachments/assets/7b933204-8078-46ed-9535-7b0b318b3470)
![Screenshot (206)](https://github.com/user-attachments/assets/5ae62272-815d-410d-a09c-0b94c7b65a81)

---

## 📋 **Use Cases**

1. **Corporate Offices**
   - Track employee attendance effortlessly for in-office staff.
   - Validate remote employees' presence in specific regions.

2. **Educational Institutions**
   - Monitor student attendance during lectures or workshops.
   - Ensure compliance with attendance policies for different sessions.

3. **Construction Sites**
   - Verify workers' presence on-site.
   - Highlight absenteeism and improve workforce allocation.

4. **Field Teams**
   - Real-time updates on employees' attendance across geographically distributed teams.


---

## 🚀 **Getting Started**

1. Clone this repository:
   ```bash
   git clone https://github.com/sabhapathihruthvik/GEOTRACK-Geolocation-Based-Attendance-Tracking-and-Management-App.git
   ```

2. Navigate to the project directory:
   ```bash
   cd geolocation-attendance-tracker
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Set up Firebase credentials by adding your `google-services.json` file in the `android/app` directory and `GoogleService-Info.plist` in the `ios/Runner` directory.

5. Run the project:
   ```bash
   flutter run
   ```

---

## 🤝 **Contributions**

Contributions are welcome! Feel free to raise issues, fork the repository, and submit pull requests. Let's build something awesome together.

---

## 📜 **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

