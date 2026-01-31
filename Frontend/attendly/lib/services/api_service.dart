import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/class.dart';
import '../models/attendance.dart';
import '../utils/config.dart';

class ApiService {
  static String get baseUrl => AppConfig.backendBaseUrl;

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> get headers {
    final headers = {'Content-Type': 'application/json'};

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Helper method to handle API responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body;
    print('🔥 FLUTTER: _handleResponse - Status: ${response.statusCode}');
    print('🔥 FLUTTER: _handleResponse - Body: $body');
    print(
      '🔥 FLUTTER: _handleResponse - Content-Type: ${response.headers['content-type']}',
    );

    // Check if response is HTML (404 page from server)
    if (body.trim().startsWith('<!doctype html>') ||
        body.trim().startsWith('<html')) {
      print('🔥 FLUTTER: _handleResponse - Received HTML instead of JSON');
      throw Exception(
        'Server returned HTML instead of JSON. Status: ${response.statusCode}. This usually means the API endpoint was not found.',
      );
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(body);
      print('🔥 FLUTTER: _handleResponse - Parsed data: $data');
    } catch (e) {
      print('🔥 FLUTTER: _handleResponse - JSON decode error: $e');
      throw Exception('Invalid JSON response from server. Body: $body');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('🔥 FLUTTER: _handleResponse - Success response');
      return data;
    } else {
      print('🔥 FLUTTER: _handleResponse - Error response');
      throw Exception(data['error'] ?? data['msg'] ?? 'Unknown error occurred');
    }
  }

  // Authentication endpoints
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    print('🔥 FLUTTER: Starting registration');
    print('🔥 FLUTTER: URL: $baseUrl/api/auth/signup');
    print('🔥 FLUTTER: Headers: $headers');
    print(
      '🔥 FLUTTER: Data: firstName=$firstName, lastName=$lastName, email=$email',
    );

    final requestBody = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'role': 'student', // Default role, will be updated later
    };

    print('🔥 FLUTTER: Request body: $requestBody');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('🔥 FLUTTER: Response status: ${response.statusCode}');
      print('🔥 FLUTTER: Response headers: ${response.headers}');
      print('🔥 FLUTTER: Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('🔥 FLUTTER: Exception in register: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateUserRole(String role) async {
    print('🔥 FLUTTER: Starting updateUserRole');
    print('🔥 FLUTTER: Role: $role');
    print('🔥 FLUTTER: URL: $baseUrl/api/auth/update-role');
    print('🔥 FLUTTER: Headers: $headers');

    final requestBody = {'role': role};
    print('🔥 FLUTTER: Request body: $requestBody');

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/auth/update-role'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('🔥 FLUTTER: UpdateRole response status: ${response.statusCode}');
      print('🔥 FLUTTER: UpdateRole response headers: ${response.headers}');
      print('🔥 FLUTTER: UpdateRole response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('🔥 FLUTTER: Exception in updateUserRole: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyToken() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/verify-token'),
      headers: headers,
    );

    return _handleResponse(response);
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/logout'),
      headers: headers,
    );

    _handleResponse(response);
  }

  // Face data endpoints
  Future<Map<String, dynamic>> uploadFaceData(List<String> images) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/face-data/upload'),
      headers: headers,
      body: jsonEncode({'images': images}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getFaceData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/face-data/my-data'),
      headers: headers,
    );

    return _handleResponse(response);
  }

  // Class endpoints
  Future<Map<String, dynamic>> createClass({
    required String name,
    required String description,
  }) async {
    print('🔥 FLUTTER: Creating class: $name');
    print('🔥 FLUTTER: URL: $baseUrl/api/classes/create');

    final requestBody = {'name': name, 'description': description};
    print('🔥 FLUTTER: Request body: $requestBody');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/classes/create'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('🔥 FLUTTER: CreateClass response status: ${response.statusCode}');
      print('🔥 FLUTTER: CreateClass response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('🔥 FLUTTER: Exception in createClass: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> joinClass(String joinCode) async {
    print('🔥 FLUTTER: Joining class with code: $joinCode');
    print('🔥 FLUTTER: URL: $baseUrl/api/classes/join');

    final requestBody = {'join_code': joinCode};
    print('🔥 FLUTTER: Request body: $requestBody');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/classes/join'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('🔥 FLUTTER: JoinClass response status: ${response.statusCode}');
      print('🔥 FLUTTER: JoinClass response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('🔥 FLUTTER: Exception in joinClass: $e');
      rethrow;
    }
  }

  Future<List<ClassModel>> getMyClasses() async {
    print('🔥 FLUTTER: Getting my classes');
    print('🔥 FLUTTER: URL: $baseUrl/api/classes/my-classes');
    print('🔥 FLUTTER: Headers: $headers');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/classes/my-classes'),
        headers: headers,
      );

      print('🔥 FLUTTER: GetMyClasses response status: ${response.statusCode}');
      print('🔥 FLUTTER: GetMyClasses response body: ${response.body}');

      final data = _handleResponse(response);
      final classes = data['classes'] as List;
      return classes.map((json) => ClassModel.fromJson(json)).toList();
    } catch (e) {
      print('🔥 FLUTTER: Exception in getMyClasses: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTeacherDashboardStats() async {
    print('🔥 FLUTTER: Getting teacher dashboard statistics');
    print('🔥 FLUTTER: URL: $baseUrl/api/classes/dashboard-stats');
    print('🔥 FLUTTER: Headers: $headers');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/classes/dashboard-stats'),
        headers: headers,
      );

      print(
        '🔥 FLUTTER: Dashboard stats response status: ${response.statusCode}',
      );
      print('🔥 FLUTTER: Dashboard stats response body: ${response.body}');

      final data = _handleResponse(response);
      return data;
    } catch (e) {
      print('🔥 FLUTTER: Exception in getTeacherDashboardStats: $e');
      rethrow;
    }
  }

  Future<ClassModel> getClassDetail(int classId) async {
    print('🔥 FLUTTER: Getting class detail for ID: $classId');
    print('🔥 FLUTTER: URL: $baseUrl/api/classes/$classId');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/classes/$classId'),
        headers: headers,
      );

      print(
        '🔥 FLUTTER: GetClassDetail response status: ${response.statusCode}',
      );
      print('🔥 FLUTTER: GetClassDetail response body: ${response.body}');

      final data = _handleResponse(response);
      return ClassModel.fromJson(data['class']);
    } catch (e) {
      print('🔥 FLUTTER: Exception in getClassDetail: $e');
      rethrow;
    }
  }

  // Attendance endpoints
  Future<Map<String, dynamic>> recognizeFaces({
    required int classId,
    required List<String> images,
    double tolerance = 0.6,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/attendance/recognize-faces'),
      headers: headers,
      body: jsonEncode({
        'class_id': classId,
        'images': images,
        'tolerance': tolerance,
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createAttendanceSession({
    required int classId,
    required String sessionName,
    required DateTime sessionDate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/attendance/create-session'),
      headers: headers,
      body: jsonEncode({
        'class_id': classId,
        'session_name': sessionName,
        'session_date': sessionDate.toIso8601String().split('T')[0],
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> markAttendance({
    required int sessionId,
    required List<int> studentIds,
    String recognitionMethod = 'face_recognition',
    Map<String, double>? confidenceScores,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/attendance/mark-attendance'),
      headers: headers,
      body: jsonEncode({
        'session_id': sessionId,
        'student_ids': studentIds,
        'recognition_method': recognitionMethod,
        'confidence_scores': confidenceScores ?? {},
      }),
    );

    return _handleResponse(response);
  }

  Future<List<AttendanceSession>> getClassSessions(int classId) async {
    print('🔥 FLUTTER: Getting attendance sessions for class ID: $classId');
    print('🔥 FLUTTER: URL: $baseUrl/api/attendance/sessions/$classId');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/attendance/sessions/$classId'),
        headers: headers,
      );

      print(
        '🔥 FLUTTER: GetClassSessions response status: ${response.statusCode}',
      );
      print('🔥 FLUTTER: GetClassSessions response body: ${response.body}');

      final data = _handleResponse(response);
      final sessions = data['sessions'] as List;
      return sessions.map((json) => AttendanceSession.fromJson(json)).toList();
    } catch (e) {
      print('🔥 FLUTTER: Exception in getClassSessions: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSessionAttendance(int sessionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/attendance/session/$sessionId/records'),
      headers: headers,
    );

    return _handleResponse(response);
  }

  // Student endpoints
  Future<List<Map<String, dynamic>>> getClassStudents(int classId) async {
    print('🔥 FLUTTER: Getting students for class ID: $classId');
    print('🔥 FLUTTER: URL: $baseUrl/api/classes/$classId');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/classes/$classId'),
        headers: headers,
      );

      print(
        '🔥 FLUTTER: GetClassStudents response status: ${response.statusCode}',
      );
      print('🔥 FLUTTER: GetClassStudents response body: ${response.body}');

      final data = _handleResponse(response);
      final classData = data['class'];
      final students = classData['students'] as List? ?? [];
      return students.cast<Map<String, dynamic>>();
    } catch (e) {
      print('🔥 FLUTTER: Exception in getClassStudents: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getStudentAttendanceStats(
    int studentId,
    int classId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/students/$studentId/attendance-stats?class_id=$classId',
      ),
      headers: headers,
    );

    return _handleResponse(response);
  }

  Future<List<AttendanceRecord>> getStudentAttendanceRecords({
    required String classId,
    required String period,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/attendance/student-records?class_id=$classId&period=$period',
      ),
      headers: headers,
    );

    final data = _handleResponse(response);
    final records = data['records'] as List;
    return records.map((json) => AttendanceRecord.fromJson(json)).toList();
  }

  // Face data endpoints
  Future<Map<String, dynamic>> registerStudentFaceData({
    required List<String> images,
  }) async {
    print('🔥 FLUTTER: Registering face data with ${images.length} images');
    print('🔥 FLUTTER: Request URL: $baseUrl/api/face-data/register-student');
    print(
      '🔥 FLUTTER: Current token: ${_token != null ? "${_token!.substring(0, 10)}..." : "NULL"}',
    );
    print('🔥 FLUTTER: Headers: $headers');

    // Double-check headers contain authorization
    if (!headers.containsKey('Authorization')) {
      print('🔥 FLUTTER: ERROR - No Authorization header found!');
      throw Exception('No authentication token available');
    }

    final response = await http
        .post(
          Uri.parse('$baseUrl/api/face-data/register-student'),
          headers: headers,
          body: jsonEncode({'images': images}),
        )
        .timeout(
          const Duration(minutes: 5),
          onTimeout: () => throw Exception(
            'Registration timed out. Please check your connection and try again.',
          ),
        );

    print(
      '🔥 FLUTTER: Face data registration response status: ${response.statusCode}',
    );
    print('🔥 FLUTTER: Face data registration response body: ${response.body}');

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getStudentFaceDataStatus() async {
    print('🔥 FLUTTER: Calling getStudentFaceDataStatus()');
    print('🔥 FLUTTER: URL: $baseUrl/api/face-data/student/facial-status');
    print('🔥 FLUTTER: Headers: $headers');

    final response = await http.get(
      Uri.parse('$baseUrl/api/face-data/student/facial-status'),
      headers: headers,
    );

    print('🔥 FLUTTER: Status check response code: ${response.statusCode}');
    print('🔥 FLUTTER: Status check response body: ${response.body}');

    return _handleResponse(response);
  }

  // New progressive face data upload endpoints
  Future<Map<String, dynamic>> uploadSingleFaceImage({
    required String image,
    required int sequenceNumber,
  }) async {
    print('🔥 FLUTTER: Uploading single image #$sequenceNumber');

    final response = await http.post(
      Uri.parse('$baseUrl/api/face-data/upload-single'),
      headers: headers,
      body: jsonEncode({'image': image, 'sequence_number': sequenceNumber}),
    );

    print('🔥 FLUTTER: Single image upload response: ${response.statusCode}');
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> uploadBatchWithProgress({
    required List<String> images,
  }) async {
    print(
      '🔥 FLUTTER: Uploading batch with progress - ${images.length} images',
    );

    final response = await http
        .post(
          Uri.parse('$baseUrl/api/face-data/upload-batch-with-progress'),
          headers: headers,
          body: jsonEncode({'images': images}),
        )
        .timeout(
          const Duration(minutes: 5),
          onTimeout: () => throw Exception(
            'Batch upload timed out. Please check your connection and try again.',
          ),
        );

    print('🔥 FLUTTER: Batch upload response: ${response.statusCode}');
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> validateFaceImage({
    required String image,
  }) async {
    print('🔥 FLUTTER: Validating face image');

    final response = await http.post(
      Uri.parse('$baseUrl/api/face-data/validate-image'),
      headers: headers,
      body: jsonEncode({'image': image}),
    );

    print('🔥 FLUTTER: Image validation response: ${response.statusCode}');
    return _handleResponse(response);
  }

  // New facial recognition specific endpoints
  Future<Map<String, dynamic>> uploadFaceForRecognition({
    required List<String> images,
  }) async {
    print(
      '🔥 FLUTTER: Uploading faces for recognition - ${images.length} images',
    );

    final response = await http.post(
      Uri.parse('$baseUrl/api/face-data/upload-for-recognition'),
      headers: headers,
      body: jsonEncode({'images': images}),
    );

    print('🔥 FLUTTER: Recognition upload response: ${response.statusCode}');
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> checkRecognitionReadiness() async {
    print('🔥 FLUTTER: Checking recognition readiness');

    final response = await http.get(
      Uri.parse('$baseUrl/api/face-data/recognition-ready'),
      headers: headers,
    );

    print('🔥 FLUTTER: Recognition readiness response: ${response.statusCode}');
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> testFaceRecognition({
    required String image,
  }) async {
    print('🔥 FLUTTER: Testing face recognition');

    final response = await http.post(
      Uri.parse('$baseUrl/api/face-data/test-recognition'),
      headers: headers,
      body: jsonEncode({'image': image}),
    );

    print('🔥 FLUTTER: Recognition test response: ${response.statusCode}');
    return _handleResponse(response);
  }

  // Student-specific facial data APIs
  Future<Map<String, dynamic>> studentUploadFacialData({
    required List<String> images,
    bool replaceExisting = false,
  }) async {
    print(
      '🔥 FLUTTER: Student uploading facial data - ${images.length} images',
    );
    print('🔥 FLUTTER: Replace existing: $replaceExisting');

    final response = await http.post(
      Uri.parse('$baseUrl/api/face-data/student/upload-facial-data'),
      headers: headers,
      body: jsonEncode({'images': images, 'replace_existing': replaceExisting}),
    );

    print('🔥 FLUTTER: Student facial upload response: ${response.statusCode}');
    print('🔥 FLUTTER: Student facial upload body: ${response.body}');
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getStudentFacialStatus() async {
    print('🔥 FLUTTER: Getting student facial status');

    final response = await http.get(
      Uri.parse('$baseUrl/api/face-data/student/facial-status'),
      headers: headers,
    );

    print('🔥 FLUTTER: Student facial status response: ${response.statusCode}');
    print('🔥 FLUTTER: Student facial status body: ${response.body}');
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteStudentFacialData() async {
    print('🔥 FLUTTER: Deleting student facial data');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/face-data/student/delete-facial-data'),
      headers: headers,
    );

    print('🔥 FLUTTER: Delete facial data response: ${response.statusCode}');
    print('🔥 FLUTTER: Delete facial data body: ${response.body}');
    return _handleResponse(response);
  }

  // Upload facial data with orientations for better recognition
  Future<Map<String, dynamic>> uploadFaceDataWithOrientations({
    required List<Map<String, String>>
    images, // [{image: base64, orientation: "front"}]
  }) async {
    print(
      '🔥 FLUTTER: Uploading facial data with orientations - ${images.length} images',
    );

    for (var i = 0; i < images.length; i++) {
      print(
        '🔥 FLUTTER: Image ${i + 1}: orientation = ${images[i]['orientation']}',
      );
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/face-data/upload-orientations'),
      headers: headers,
      body: jsonEncode({'images': images}),
    );

    print('🔥 FLUTTER: Orientation upload response: ${response.statusCode}');
    print('🔥 FLUTTER: Orientation upload body: ${response.body}');
    return _handleResponse(response);
  }

  // Class joining endpoints
  Future<Map<String, dynamic>> leaveClass({required int classId}) async {
    print('🔥 FLUTTER: Leaving class with ID: $classId');
    print('🔥 FLUTTER: URL: $baseUrl/api/classes/$classId/leave');

    final response = await http.post(
      Uri.parse('$baseUrl/api/classes/$classId/leave'),
      headers: headers,
    );

    print('🔥 FLUTTER: Leave class response code: ${response.statusCode}');
    print('🔥 FLUTTER: Leave class response body: ${response.body}');

    return _handleResponse(response);
  }

  // Classroom photo recognition endpoints
  Future<Map<String, dynamic>> getClassStudentsWithFacialData(
    int classId,
  ) async {
    print(
      '🔥 FLUTTER: Getting class students with facial data for class: $classId',
    );

    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/face-data/class/$classId/students-with-facial-data',
      ),
      headers: headers,
    );

    print('🔥 FLUTTER: Get students response: ${response.statusCode}');
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> recognizeStudentsFromPhoto({
    required int classId,
    required String imageBase64,
    double recognitionThreshold = 0.6,
    int maxFaces = 50,
  }) async {
    print('🔥 FLUTTER: Recognizing students from photo for class: $classId');

    final requestBody = {
      'class_id': classId,
      'image': imageBase64,
      'recognition_threshold': recognitionThreshold,
      'max_faces': maxFaces,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/face-data/recognize-from-photo'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('🔥 FLUTTER: Recognition response: ${response.statusCode}');
    return _handleResponse(response);
  }

  // Mark individual student attendance
  Future<Map<String, dynamic>> markStudentAttendance({
    required int sessionId,
    required int studentId,
    required String status,
    double? recognitionConfidence,
    String? recognitionMethod,
  }) async {
    print(
      '🔥 FLUTTER: Marking individual attendance - Session: $sessionId, Student: $studentId, Status: $status',
    );

    final requestBody = {
      'session_id': sessionId,
      'student_ids': [studentId], // Backend expects array
      'status': status,
      if (recognitionConfidence != null)
        'confidence_scores': {studentId.toString(): recognitionConfidence},
      if (recognitionMethod != null) 'recognition_method': recognitionMethod,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/attendance/mark-attendance'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('🔥 FLUTTER: Mark attendance response: ${response.statusCode}');
    return _handleResponse(response);
  }
}
