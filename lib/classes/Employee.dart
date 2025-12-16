import 'package:hr_management/classes/types.dart';

/// Represents a single employee in the system.
/// Contains personal info, employment status, and organizational links.
class Employee {
  final String id;
  final String fullName;
  final String rank;
  final String category;
  final String specialty;
  final String department;
  final Status status;
  final DateTime? requestDate;
  final String? gradeEn;
  final String? gradeAr;

  final int step;
  final int? departmentId; // optional, parsed from nested department
  final int? specialityId; // optional, parsed from nested speciality
  final int? bodyId;
  final int? gradeId; // Added gradeId
  final String? bodyEn;
  final String? bodyAr;

  // Fields for modify employee dialog
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? reference;
  final DateTime? dateOfBirth;
  final bool? retireRequest;

  Employee({
    required this.id,
    required this.fullName,
    required this.rank,
    required this.category,
    required this.specialty,
    required this.department,
    required this.status,
    this.step = 0,
    this.requestDate,
    this.gradeEn,
    this.gradeAr,
    this.departmentId,
    this.specialityId,
    this.bodyId,
    this.gradeId,
    this.bodyEn,
    this.bodyAr,
    this.firstName,
    this.lastName,
    this.address,
    this.reference,
    this.dateOfBirth,
    this.retireRequest,
  });

  /// Factory constructor to create Employee from JSON (API response format)
  factory Employee.fromJson(Map<String, dynamic> json) {
    // Extract firstName and lastName separately
    final firstName = json['firstName']?.toString() ?? '';
    final lastName = json['lastName']?.toString() ?? '';
    
    // Handle fullName - API returns firstName + lastName or fullName
    String fullName = json['fullName'] ?? json['full_name'] ?? '';
    if (fullName.isEmpty && (firstName.isNotEmpty || lastName.isNotEmpty)) {
      fullName = '$firstName $lastName'.trim();
    }

    // Handle department - API returns object with name property
    String department = '';
    int? departmentId;
    if (json['department'] is Map) {
      final dep = json['department'] as Map;
      department = dep['name'] ?? '';
      final depIdRaw = dep['id'] ?? dep['_id'];
      if (depIdRaw is int) {
        departmentId = depIdRaw;
      } else if (depIdRaw is String) {
        departmentId = int.tryParse(depIdRaw);
      }
    } else if (json['department'] is String) {
      department = json['department'];
    } else if (json['departmentId'] != null) {
      departmentId = json['departmentId'] is int
          ? json['departmentId']
          : int.tryParse(json['departmentId'].toString());
    }

    // Handle speciality - API returns object with name property
    String specialty = '';
    int? specialityId;
    if (json['speciality'] is Map) {
      final spec = json['speciality'] as Map;
      specialty = spec['name'] ?? '';
      final specIdRaw = spec['id'] ?? spec['_id'];
      if (specIdRaw is int) {
        specialityId = specIdRaw;
      } else if (specIdRaw is String) {
        specialityId = int.tryParse(specIdRaw);
      }
    } else if (json['speciality'] is String) {
      specialty = json['speciality'];
    } else {
      // Fallback for 'specialty' parsing if API changes back
      specialty = json['specialty'] ?? '';
    }
    if (json['specialityId'] != null && specialityId == null) {
      specialityId = json['specialityId'] is int
          ? json['specialityId']
          : int.tryParse(json['specialityId'].toString());
    }

    int? bodyId;
    String? bodyEn;
    String? bodyAr;
    if (json['body'] is Map) {
      final b = json['body'] as Map;
      final bIdRaw = b['id'] ?? b['_id'];
      if (bIdRaw is int) {
        bodyId = bIdRaw;
      } else if (bIdRaw is String) {
        bodyId = int.tryParse(bIdRaw);
      }
      bodyEn = (b['nameEn'] ?? b['designationFR'])?.toString();
      bodyAr = (b['nameAr'] ?? b['designationAR'])?.toString();
    }

    // Handle rank - API returns originalRank or currentRank
    String rank = json['rank'] ?? json['currentRank'] ?? json['originalRank'] ?? '';

    // Handle grade translations
    String? gradeEn = json['gradeEn'] ?? json['grade_en'];
    String? gradeAr = json['gradeAr'] ?? json['grade_ar'];
    
    // Attempt to extract grade from nested object if direct fields are missing
    if (json['grade'] is Map) {
      gradeEn ??= json['grade']['designationFR'];
      gradeAr ??= json['grade']['designationAR'];
    }

    // Handle dateOfBirth separately from requestDate
    DateTime? dateOfBirth;
    if (json['dateOfBirth'] != null) {
      dateOfBirth = DateTime.tryParse(json['dateOfBirth'].toString());
    }

    // Handle requestDate (different from dateOfBirth)
    DateTime? requestDate;
    if (json['requestDate'] != null) {
      requestDate = DateTime.tryParse(json['requestDate'].toString());
    }

    // Extract address and reference
    final address = json['address']?.toString();
    final reference = json['reference']?.toString();

    // Extract retireRequest
    bool? retireRequest;
    if (json['retireRequest'] != null) {
      retireRequest = json['retireRequest'] is bool
          ? json['retireRequest'] as bool
          : json['retireRequest'].toString().toLowerCase() == 'true';
    }


    // Safe parsing for gradeId
    int? gradeId;
    if (json['gradeId'] is int) {
      gradeId = json['gradeId'];
    } else if (json['grade'] is Map) {
       final g = json['grade'];
       if (g['id'] is int) {
         gradeId = g['id'];
       } else {
         gradeId = int.tryParse(g['id']?.toString() ?? '');
       }
    }

    // Safe parsing for step
    int step = 0;
    if (json['step'] is int) {
      step = json['step'];
    } else {
      step = int.tryParse(json['step']?.toString() ?? '0') ?? 0;
    }

    return Employee(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      fullName: fullName,
      rank: rank,
      category: json['category'] ?? '', // Not present in provided schema
      specialty: specialty,
      department: department,
      status: _parseStatus(json['status']),
      step: step,
      requestDate: requestDate,
      dateOfBirth: dateOfBirth,
      gradeEn: gradeEn,
      gradeAr: gradeAr,
      departmentId: departmentId,
      specialityId: specialityId,
      bodyId: bodyId,
      bodyAr: bodyAr,
      firstName: firstName.isNotEmpty ? firstName : null,
      lastName: lastName.isNotEmpty ? lastName : null,
      address: address,
      reference: reference,
      retireRequest: retireRequest,
      gradeId: gradeId,
    );
  }

  /// Convert Employee to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'rank': rank,
      'category': category,
      'specialty': specialty,
      'department': department,
      'status': status.name,
      'step': step,
      'requestDate': requestDate?.toIso8601String(),
      'gradeEn': gradeEn,
      'gradeAr': gradeAr,
      'departmentId': departmentId,
      'specialityId': specialityId,
    };
  }

  /// Helper to parse status string to Status enum
  static Status _parseStatus(dynamic statusValue) {
    if (statusValue == null) return Status.employed;
    final rawStatus = statusValue.toString();
    
    // Explicit checks for uppercase
    if (rawStatus == 'RETIRED') return Status.retired;
    if (rawStatus == 'TO_RETIRE') return Status.toRetire;
    
    final statusStr = rawStatus.toLowerCase();
    
    // Robust checks
    if (statusStr.contains('retired')) return Status.retired;
    if (statusStr.contains('retire')) return Status.toRetire;
    
    switch (statusStr) {
      case 'active':
      case 'employed':
        return Status.employed;
      default:
        return Status.employed;
    }
  }
}
