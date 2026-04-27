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

  UserModel({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.userType,
    required this.token,
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

      // optional
      "counter": {
        "id": counter.id,
        "name": counter.name,
      },
    };
  }
}