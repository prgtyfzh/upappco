import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uId;
  String uName;
  String uEmail;
  UserModel({
    required this.uId,
    required this.uName,
    required this.uEmail,
  });

  UserModel copyWith({
    String? uId,
    String? uName,
    String? uEmail,
  }) {
    return UserModel(
      uId: uId ?? this.uId,
      uName: uName ?? this.uName,
      uEmail: uEmail ?? this.uEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'uName': uName,
      'uEmail': uEmail,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] ?? '',
      uName: map['uName'] ?? '',
      uEmail: map['uEmail'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(uId: $uId, uName: $uName, uEmail: $uEmail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uId == uId &&
        other.uName == uName &&
        other.uEmail == uEmail;
  }

  @override
  int get hashCode => uId.hashCode ^ uName.hashCode ^ uEmail.hashCode;

  static User? fromFirebaseUser(User user) {}
}
