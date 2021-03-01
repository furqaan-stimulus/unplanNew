import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:unplan/app/locator.dart';
import 'package:unplan/app/router.gr.dart';

class SplashViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  Future<bool> isUserSignedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    if (token == null) {
      setBusy(true);
      await _navigationService.pushNamedAndRemoveUntil(Routes.loginView);
    } else {
      await _navigationService.pushNamedAndRemoveUntil(Routes.homeView);
    }
    return token != null;
  }
}
