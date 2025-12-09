class Speciality {
  final int id;
  final String name;
  final int? domainId;

  Speciality({required this.id, required this.name, this.domainId});

  factory Speciality.fromJson(Map<String, dynamic> json) {
    int? dId;
    final d = json['domain'];
    if (d is Map) {
      final raw = d['id'];
      if (raw is int)
        dId = raw;
      else if (raw is String)
        dId = int.tryParse(raw);
    }
    return Speciality(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      domainId: dId,
    );
  }
}
