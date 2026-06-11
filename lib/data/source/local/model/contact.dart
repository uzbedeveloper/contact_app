class Contact {
  final String? id;
  final String name;
  final String phone;

  Contact({this.id, required this.name, required this.phone});

  Contact copyWith({String? id, String? name, String? phone}) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'phone': phone};

  factory Contact.fromMap(Map<String, dynamic> map) => Contact(
    id: map['id'] as String?,
    name: map['name'] as String,
    phone: map['phone'] as String,
  );
}