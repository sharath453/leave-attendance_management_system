import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = Constants.baseUrl;

  Future<void> uploadNotes(
      int facultyId, String subject, String filePath) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_notes.php'));
      request.fields['faculty_id'] = facultyId.toString();
      request.fields['subject'] = subject;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();

      // Read the response
      var responseString = await response.stream.bytesToString();
      print(
          'Server response: $responseString'); // Print the server response for debugging

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(responseString);
        if (decodedResponse['success'] == true) {
          return;
        } else {
          throw Exception(
              'Failed to upload notes: ${decodedResponse['message']}');
        }
      } else {
        throw Exception('Failed to upload notes: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to upload notes: $e');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to log in: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to log in: $e');
    }
  }

  Future<bool> register(String fullName, String username, String password,
      String email, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'full_name': fullName,
          'username': username,
          'password': password,
          'email': email,
          'role': role,
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success'] != null) {
          return true;
        } else {
          print('Error: ${responseBody['error']}');
          return false;
        }
      } else {
        print('Failed to register: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Failed to register: $e');
      return false;
    }
  }

  Future<void> applyLeave(
      int studentId, String startDate, String endDate, String reason) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/apply_leave.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'usn':
              '4AL21CS${studentId.toString().padLeft(3, '0')}', // Use the complete USN format
          'start_date': startDate,
          'end_date': endDate,
          'reason': reason,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to apply for leave: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to apply for leave: $e');
    }
  }

  Future<List<dynamic>> viewLeaveApplications(String usernamePrefix) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/get_leave_applications.php?username_prefix=$usernamePrefix'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['applications'];
      } else {
        throw Exception(
            'Failed to fetch leave applications: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch leave applications: $e');
    }
  }

  Future<List<dynamic>> fetchAttendanceData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_attendance.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to fetch attendance data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch attendance data: $e');
    }
  }

  Future<List<dynamic>> fetchFines() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_fines.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch fines: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch fines: $e');
    }
  }

  Future<void> uploadAttendance(
      int studentId, String subject, double attendancePercentage) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/upload_attendance.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'student_id': studentId,
          'subject': subject,
          'attendance_percentage': attendancePercentage,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to upload attendance: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to upload attendance: $e');
    }
  }

  Future<List<dynamic>> fetchNotes(int studentId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/get_notes.php?student_id=$studentId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch notes: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<void> submitFine(int studentId, double fineAmount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/submit_fine.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'student_id': studentId,
          'fine_amount': fineAmount,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to submit fine: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to submit fine: $e');
    }
  }

  Future<void> markLeaveAsApproved(int leaveId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mark_leave_as_approved.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'leave_id': leaveId,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark leave as approved: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to mark leave as approved: $e');
    }
  }

  Future<void> markLeaveAsRejected(int leaveId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mark_leave_as_rejected.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'leave_id': leaveId,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark leave as rejected: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to mark leave as rejected: $e');
    }
  }
}
