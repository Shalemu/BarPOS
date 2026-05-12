import 'package:barpos/services/model/counters_model.dart';

class UserModel {
  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String userType;
  final String token;
  final CounterModel counter;

    final String role;
  final List<String> permissions;

  UserModel({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.userType,
    required this.token,
    required this.role,
    required this.permissions,
    required this.counter,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json["firstName"] ?? "",
      middleName: json["middleName"] ?? "",
      lastName: json["lastName"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      email: json["email"] ?? "",
      userType: json["userType"] ?? "",
      token: json["token"] ?? "",


            role: json["role"] ?? "",

      permissions: json["permissions"] != null
          ? List<String>.from(json["permissions"])
          : [],

    
      counter: CounterModel.fromJson(json["counter"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "email": email,
      "userType": userType,
      "token": token,
      "role": role,
      "permissions": permissions,

      // optional
      "counter": {
        "id": counter.id,
        "name": counter.name,
      },
    };
  }
}