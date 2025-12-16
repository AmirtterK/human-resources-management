import 'package:hr_management/classes/Speciality.dart';

/// Represents a functional domain containing multiple specialities.
class Domain {
  final String id;
  final String name;
  final List<Speciality> specialities;

  Domain({required this.id, required this.name, this.specialities = const []});

  factory Domain.fromJson(Map<String, dynamic> json) {
    List<Speciality> specs = [];
    if (json['specialities'] is List) {
      specs = (json['specialities'] as List)
          .map((s) => Speciality.fromJsonWithDomainId(s, json['id']))
          .toList();
    }
    return Domain(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialities: specs,
    );
  }
}
