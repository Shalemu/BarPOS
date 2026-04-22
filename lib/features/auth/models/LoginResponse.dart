import 'package:barpos/services/models/user_model.dart';

class LoginResponseModel {
  final String status;
  final String message;
  final UserModel user;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
      user: UserModel.fromJson(json["user"]),
    );
  }
}