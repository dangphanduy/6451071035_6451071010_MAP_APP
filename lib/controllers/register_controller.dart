import 'package:get/get.dart';
import 'package:map_app_6451071035_6451071010/data/services/register_auth_service.dart';
import 'package:map_app_6451071035_6451071010/data/models/user_model.dart';
class RegisterController {
  final AuthService _authService = AuthService();
  Future<String?> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      UserModel userModel = UserModel(
        id: "",
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phone: phone,
      );
      await _authService.registerUser(userModel: userModel, password:
      password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}