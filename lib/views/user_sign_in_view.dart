import 'package:ebook/app_instance.dart';
import 'package:ebook/constant.dart';
import 'package:ebook/controller/main_wrapper_controller.dart';
import 'package:ebook/controller/user_sign_in_controller.dart';
import 'package:ebook/utils/app_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_color.dart';
import '../widgets/custom_text.dart';
import '../widgets/widgets.dart';

class UserSignIn extends StatefulWidget {
  const UserSignIn({super.key});

  @override
  State<StatefulWidget> createState() {
    return UserSignInState();
  }
}

class UserSignInState extends State<UserSignIn> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async{

      var mainWrapperController =
      Provider.of<MainWrapperController>(context, listen: false);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int accountID = prefs.getInt(AppInstance().accountID) ?? -1;
      if (accountID == -1) {
        messageSnackBar(context, 'Có lỗi xảy ra khi tìm kiếm tài khoản');
      }else{
        await mainWrapperController.findAccountByID(accountID);
      }
      await Provider.of<UserSignInController>(context, listen: false).getUserName(mainWrapperController.currentAccount!.id!);
    });
  }

  Future<void> _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri,mode: LaunchMode.inAppBrowserView)) {
      debugPrint('Loi:${uri}');
      throw Exception('Could not launch $uri');
    }
  }

  void _shareApp(BuildContext context) {
    final String text = 'Hãy thử ứng dụng tuyệt vời này: https://example.com';
    Share.share(text, subject: 'Ứng dụng tuyệt vời');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.blue,
                  AppColors.white80,
                ]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                        style: Style.bold,
                        textSize: 24,
                        text: 'Tài khoản',
                        textColor: Colors.white),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/icon_person_64.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                            text: Provider.of<UserSignInController>(context,
                                        listen: true)
                                    .userName,
                            textSize: 18,
                            style: Style.normal,
                            textColor: Colors.white),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: CustomText(
                        style: Style.bold,
                        text: "Mua gói hội viên",
                        textColor: Colors.black,
                        textSize: 18,
                      )),
                      const Center(
                          child: CustomText(
                        style: Style.bold,
                        text: "nội dung độc quyền",
                        textColor: Colors.black,
                        textSize: 18,
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: FilledButton.tonal(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.gray80),
                          ),
                          onPressed: () {
                            AppNavigation.router.push('/userSI/payment');
                          },
                          child: const CustomText(
                            text: 'Nâng cấp ngay',
                            textColor: Colors.black,
                            style: Style.bold,
                            textSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomText(
                        style: Style.bold,
                        text: "Hỗ trợ",
                        textColor: Colors.black,
                        textSize: 18,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.gray80),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10)),
                          ),
                          onPressed: () {
                            _launchUrl('https://www.facebook.com/KillerTuh');
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Liên hệ hỗ trợ',
                                textColor: Colors.black,
                                style: Style.bold,
                                textSize: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.gray80),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10)),
                          ),
                          onPressed: () {
                            _launchUrl('https://www.facebook.com/KillerTuh');
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Về chúng tôi',
                                textColor: Colors.black,
                                style: Style.bold,
                                textSize: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.gray80),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10)),
                          ),
                          onPressed: () {

                            _shareApp(context);

                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Chia sẻ ứng dụng',
                                textColor: Colors.black,
                                style: Style.bold,
                                textSize: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var mainWrapperController=Provider.of<MainWrapperController>(context,listen: false);
                          mainWrapperController.currentAccount=null;
                          mainWrapperController.currentAccountSubscription=null;
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove(AppInstance().accountID);

                          Fluttertoast.showToast(
                              msg: "Đăng xuất thành công",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);
                          AppNavigation.router.go('/userNLG');
                        },
                        child: const Center(
                          child: CustomText(
                              style: Style.bold,
                              textSize: 18,
                              text: 'Đăng xuất',
                              textColor: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
