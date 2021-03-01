import 'package:stacked/stacked.dart';
import 'package:unplan/app/locator.dart';
import 'package:unplan/service/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();

  Future postLogin(
    String email,
    String password,
  ) async {
    await _authService.postLogin(email, password);
  }
}
