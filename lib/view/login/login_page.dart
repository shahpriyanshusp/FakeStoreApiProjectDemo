import 'package:fakestore/controller/login/login_controller.dart';
import 'package:fakestore/model/colors.dart';
import 'package:fakestore/model/utils.dart';
import 'package:fakestore/view/ui/fs_textformfield.dart';
import 'package:fakestore/view/ui/progress_hud.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (_) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ProgressHUD(
              loading: _.isLoading,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _.formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Image.asset(
                              Utils().imageLogoAsset,
                              width: 90,
                              height: 90,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            FSTextFormField(
                              controller: _.controllerName,
                              keyboardType: TextInputType.text,
                              validator: _.validateEmail,
                              onChanged: _.onChangeUserName,
                              label: "UserName",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GetBuilder<LoginController>(
                              id: 'Password',
                              builder: (_) {
                                return FSTextFormField(
                                  controller: _.controllerPass,
                                  keyboardType: TextInputType.text,
                                  validator: _.validatePass,
                                  onChanged: _.onChangePass,
                                  obscureText: !_.isVisibilityPass,
                                  label: "Password",
                                  suffixIcon: IconButton(
                                    icon: !_.isVisibilityPass
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                    onPressed: _.changePasswordVisibility,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            GetBuilder<LoginController>(
                                id: 'BtnLogin',
                                builder: (_) {
                                  return OutlinedButton(
                                    onPressed: _.isCompleteForm
                                        ? () => _.onLogin()
                                        : null,
                                    child: Text(
                                      "Login",
                                      style: const TextStyle().copyWith(
                                        color: FSColors.purple,
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Don´t have an account yet? ',
                                style: Theme.of(context).textTheme.bodyLarge,
                                children:  <TextSpan>[
                                  TextSpan(
                                      text: 'join now',
                                      recognizer: TapGestureRecognizer()..onTap = () =>_.goToSingIn(),
                                      style:const TextStyle(
                                        decoration: TextDecoration.underline,
                                      )),
                                  // can add more TextSpans here...
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
