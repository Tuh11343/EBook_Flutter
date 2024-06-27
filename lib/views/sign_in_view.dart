import 'package:dio/dio.dart';
import 'package:ebook/controller/sign_in_controller.dart';
import 'package:ebook/utils/app_color.dart';
import 'package:ebook/utils/app_navigation.dart';
import 'package:ebook/widgets/custom_text.dart';
import 'package:ebook/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../utils/regex_pattern.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.blue, AppColors.gray80])),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.all(20),
                child: Row(
                  children: [
                    const CustomText(
                        text: 'Đăng nhập',
                        textSize: 20,
                        style: Style.bold,
                        textColor: Colors.white),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size.fromRadius(17),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chào mừng đến với',
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const Text(
                            'EBook!',
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          MyTextField(
                            labelText: 'Gmail',
                            controller: _emailController,
                            obscureText: false,
                            isNumber: false,
                            prefixIcon: 'assets/icons/icon_prefix_person_64.png',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MyTextField(
                            labelText: 'Mật khẩu',
                            controller: _passwordController,
                            obscureText: true,
                            isNumber: false,
                            prefixIcon: 'assets/icons/icon_lock_50.png',
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Consumer<SignInController>(
                            builder: (context, controller, child) {
                              if (controller.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return GestureDetector(
                                    onTap: () async {
                                      String email = _emailController.text;
                                      String password = _passwordController.text;
                                      if (email == null || email.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: "Không được để tài khoản trống",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                        return;
                                      } else if (!RegexPattern.validatePassword(
                                          password)) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Mật khẩu phải gồm 6 ký tự trở lên",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                        return;
                                      }

                                      var signInStatus = await controller.signIn(
                                          email, password);
                                      if(signInStatus){
                                        Fluttertoast.showToast(
                                            msg:
                                            "Đăng nhập thành công",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                        AppNavigation.router.go('/userSI');
                                      }else{
                                        Fluttertoast.showToast(
                                            msg:
                                            "Đăng nhập thất bại tài khoản hoặc mật khẩu không đúng",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.black),
                                      child: const Center(
                                        child: Text(
                                          'Đăng nhập',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ));
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                              )),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Hoặc cách khác',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Consumer<SignInController>(
                              builder: (BuildContext context, SignInController controller, Widget? child) {
                                return GestureDetector(
                                  onTap: () async{
                                      bool status=await controller.googleSignIn();
                                      if(status) {
                                        Fluttertoast.showToast(
                                            msg: "Đăng nhập thành công",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            fontSize: 16.0
                                        );
                                        AppNavigation.router.go('/userSI');
                                      }else{
                                        Fluttertoast.showToast(
                                            msg: "Đăng nhập thất bại",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            fontSize: 16.0
                                        );
                                      }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: AppColors.white80,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Image.asset(
                                      'assets/icons/icon_google_48.png',
                                      height: 30,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
