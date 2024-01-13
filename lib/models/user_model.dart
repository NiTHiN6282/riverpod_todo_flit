// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String name;
  String email;
  DateTime date;
  String id;
  UserModel({
    required this.name,
    required this.email,
    required this.date,
    required this.id,
  });

  UserModel copyWith({
    String? name,
    String? email,
    DateTime? date,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'date': date,
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      date: map['date'].toDate(),
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, date: $date, id: $id)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.date == date &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ date.hashCode ^ id.hashCode;
  }
}
