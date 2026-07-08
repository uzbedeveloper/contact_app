class Contact {
  final String? id;
  final String name;
  final String phone;

  Contact({this.id, required this.name, required this.phone});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
  };

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json['id']?.toString(),
    name: json['name'] as String,
    phone: json['phone'] as String,
  );

  Contact copyWith({String? id, String? name, String? phone}) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}