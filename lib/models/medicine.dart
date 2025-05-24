class Medicine {
  final int? id;
  final String name;
  final String time;
  final bool taken;
  final String location;

  Medicine({
    this.id,
    required this.name,
    required this.time,
    this.taken = false,
    required this.location,
  });

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      time: map['time'],
      taken: map['taken'] == 1,
      location: map['location'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'taken': taken ? 1 : 0,
      'location': location,
    };
  }
}
