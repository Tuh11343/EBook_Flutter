
import 'package:ebook/utils/app_color.dart';
import 'package:ebook/utils/app_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_text.dart';
import '../widgets/show_exit_dialog.dart';

class UserNLG extends StatefulWidget{
  const UserNLG({super.key});

  @override
  State<StatefulWidget> createState() {
    return UserNLGState();
  }

}

class UserNLGState extends State<UserNLG>{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end:Alignment.bottomCenter,
          colors: [
            AppColors.blue,
            AppColors.white80,
          ]
        )
      ),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsetsDirectional.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),
                  const Text('Đăng nhập để lưu lại quá trình',style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.black
                  )),
                  const SizedBox(height: 10,),
                  FilledButton.tonal(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.gray80),
                    ),
                    onPressed: () {
                      debugPrint('Pressed');
                      context.push('/userNLG/signIn');
                    },
                    child: const CustomText(
                      text: 'Đăng nhập',
                      textColor: Colors.black,
                      style: Style.bold,
                      textSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  TextButton(onPressed: () {
                      AppNavigation.router.push('/userNLG/signUp');
                  }, child: const Text(
                    'Tạo tài khoản mới',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.underline,
                    ),
                  ))
                ],
              ),
            ),
            Positioned(top: -60,left: 0,right: 0,child: Image.asset('assets/icons/icon_person_64.png',height: 100,width: 100,)),
          ],
        ),
      ),
    );
  }

}