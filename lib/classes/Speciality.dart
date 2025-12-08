class Speciality {
  final int id;
  final String name;

  Speciality({
    required this.id,
    required this.name,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
    );
  }
}
