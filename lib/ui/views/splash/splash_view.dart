import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/ui/views/splash/splash_view_model.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:unplan/utils/view_color.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      viewModelBuilder: () => SplashViewModel(),
      onModelReady: (model) {
        Future.delayed(
          Duration(milliseconds: 1000),
          () {
            model.isUserSignedIn();
          },
        );
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ViewColor.background_purple_color,
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 125.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: Utils.splashText0, style: TextStyles.splashTitle1),
                              TextSpan(text: Utils.splashText1, style: TextStyles.splashTitle2),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            Utils.splashText2,
                            style: TextStyles.splashSubTitle,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/new.png'),
                      SizedBox(
                        width: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
