import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:unplan/ui/views/login/login_view_model.dart';
import 'package:unplan/utils/text_styles.dart';
import 'package:unplan/utils/utils.dart';
import 'package:unplan/utils/view_color.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _obscureText = false;

  final _formKey = GlobalKey<FormState>();

  void toggle() {
    setState(() {
      this._obscureText = !this._obscureText;
    });
  }

  FocusNode emailFocus;
  FocusNode pwd;
  FocusNode submitFocus;

  @override
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    pwd = FocusNode();
    submitFocus = FocusNode();
  }

  @override
  void dispose() {
    emailFocus.dispose();
    pwd.dispose();
    submitFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          backgroundColor: ViewColor.text_white_color,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 150.0),
                          child: Text(
                            Utils.LOGIN,
                            style: TextStyles.loginTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  color: ViewColor.background_white_color,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ViewColor.text_grey_color,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20.0, 4.0, 10.0, 4.0),
                                    child: TextFormField(
                                      style: TextStyles.emailTextStyle,
                                      focusNode: emailFocus,
                                      enabled: true,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (term) {
                                        emailFocus.unfocus();
                                        FocusScope.of(context).requestFocus(pwd);
                                      },
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: Utils.hintEmail,
                                        hintStyle: TextStyles.emailHintStyle,
                                        border: InputBorder.none,
                                        errorStyle: TextStyles.leaveMessages,
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return Utils.msgEmail;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ViewColor.text_grey_color,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20.0, 4.0, 6.0, 4.0),
                                    child: TextFormField(
                                      style: TextStyles.passwordTextStyle,
                                      focusNode: pwd,
                                      enabled: true,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (term) {
                                        pwd.unfocus();
                                        FocusScope.of(context).requestFocus(submitFocus);
                                      },
                                      controller: passwordController,
                                      obscureText: !this._obscureText,
                                      obscuringCharacter: "*",
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: Utils.hintPassword,
                                        hintStyle: TextStyles.passwordHintStyle,
                                        border: InputBorder.none,
                                        errorStyle: TextStyles.leaveMessages,
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return Utils.msgPassword;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: double.infinity,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    focusNode: submitFocus,
                                    child: Text(
                                      Utils.buttonLogin,
                                      style: TextStyles.buttonTextStyle1,
                                    ),
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus.unfocus();
                                      if (_formKey.currentState.validate()) {
                                        model.postLogin(
                                          emailController.text,
                                          passwordController.text,
                                        );
                                      }
                                    },
                                    color: ViewColor.button_green_color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 5.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(text: Utils.splashText0, style: TextStyles.loginTitle),
                                TextSpan(text: Utils.splashText1, style: TextStyles.loginFooterTitle1),
                              ])),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              Utils.splashText2,
                              style: TextStyles.loginFooterSubTitle,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
