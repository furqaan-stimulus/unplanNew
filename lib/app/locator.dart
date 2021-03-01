import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:unplan/app/locator.config.dart';

final locator = GetIt.instance;

@InjectableInit()
void setUpLocator() async {
  $initGetIt(locator);
}
