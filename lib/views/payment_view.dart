import 'package:ebook/app_instance.dart';
import 'package:ebook/constant.dart';
import 'package:ebook/controller/main_wrapper_controller.dart';
import 'package:ebook/controller/payment_controller.dart';
import 'package:ebook/model/Book.dart';
import 'package:ebook/widgets/custom_text.dart';
import 'package:ebook/widgets/payment_plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<StatefulWidget> createState() {
    return PaymentViewState();
  }
}

class PaymentViewState extends State<PaymentView> {
  bool _presentPayment = false;
  PlanType planType = PlanType.normal;
  bool _customTileExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await initPaymentMethod();
    });
  }

  Future<void> initPaymentMethod() async {
    var mainWrapperController =
        Provider.of<MainWrapperController>(context, listen: false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int accountID = prefs.getInt(AppInstance().accountID) ?? -1;
    if (accountID == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      //Initialize Payment Method
      await mainWrapperController.findAccountByID(accountID);
      //Check if account subscription is normal or premium
      if (mainWrapperController.currentAccountSubscription?.bookType ==
          BookType.PREMIUM) {
        planType = PlanType.premium;
      }

      var controller = Provider.of<PaymentController>(context, listen: false);
      var result = await controller.paymentRequest(accountID, 20000);

      debugPrint('Result:${result}');
      var paymentIntent = result['paymentIntent'];
      var ephemeralKey = result['ephemeralKey'];
      var customerId = result['customer'];
      var publishableKey = result['publishableKey'];
      Stripe.publishableKey = publishableKey!;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: paymentIntent,
          // Customer keys
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customerId,
          // Extra options
          // applePay: const PaymentSheetApplePay(
          //   merchantCountryCode: 'US',
          // ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.dark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountSubscriptionHistory =
        Provider.of<MainWrapperController>(context, listen: true)
            .accountSubscriptionHistory;

    String formattedStartDate = accountSubscriptionHistory?.start != null
        ? DateFormat('MM/dd/yyyy').format(accountSubscriptionHistory!.start!)
        : '';

    String formattedEndDate = accountSubscriptionHistory?.end != null
        ? DateFormat('MM/dd/yyyy').format(accountSubscriptionHistory!.end!)
        : 'Không có';
    if (formattedEndDate == formattedStartDate) {
      formattedEndDate = 'Không có';
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                  child: CustomText(
                      text: 'Gói hội viên',
                      textSize: 25,
                      style: Style.bold,
                      textColor: Colors.black)),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: PaymentPlan(
                        currentPlanType: planType,
                        planType: PlanType.normal,
                        planName: 'Normal',
                        planPrice: 'Miễn phí',
                        onPlanSelected: (value) {
                          try {
                            var mainWrapperController =
                                Provider.of<MainWrapperController>(context,
                                    listen: false);
                            if (mainWrapperController
                                    .currentAccountSubscription!.bookType ==
                                BookType.PREMIUM) {
                              messageSnackBar(
                                  context, 'Bạn đang sử dụng gói premium');
                            }
                          } catch (e) {
                            debugPrint('Error from select normal plan:${e}');
                          }
                        },
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: PaymentPlan(
                      currentPlanType: planType,
                      planType: PlanType.premium,
                      planName: 'Premium',
                      planPrice: '200\$ /tháng',
                      onPlanSelected: (value) async {
                        var controller = Provider.of<PaymentController>(context,
                            listen: false);
                        var mainWrapperController =
                            Provider.of<MainWrapperController>(context,
                                listen: false);

                        if (controller.isReadyToPayment) {
                          if (!_presentPayment) {
                            _presentPayment = true;
                            try {
                              await Stripe.instance.presentPaymentSheet();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Thanh toán thành công'),
                                  duration: Duration(seconds: 1),
                                ),
                              );

                              //Cập nhật UI nếu thanh toán thành công
                              setState(() {
                                planType = value;
                              });

                              //Cập nhật thông tin tài khoản nếu thành công
                              var result =
                                  await controller.updateAccountToPremium(
                                      mainWrapperController
                                          .currentAccountSubscription!,
                                      mainWrapperController
                                          .accountSubscriptionHistory!);
                              if (!result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Có lỗi xảy ra trong quá trình nâng cấp'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint(
                                  'Error from handle call api payment:${e}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Thanh toán thất bại'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                            _presentPayment = false;
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Trình thanh toán chưa sẵn sàng vui lòng đợi trong giây lát!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ExpansionTile(
                childrenPadding: EdgeInsets.zero,
                title: const CustomText(
                    text: 'Thông tin gói hiện tại',
                    textColor: Colors.black,
                    style: Style.bold,
                    textSize: 18),
                trailing: Icon(
                  _customTileExpanded
                      ? Icons.arrow_drop_down_circle
                      : Icons.arrow_drop_down,
                ),
                children: [
                  ListTile(
                      title: CustomText(
                    style: Style.normal,
                    textColor: Colors.black,
                    text: 'Ngày bắt đầu:$formattedStartDate',
                    textSize: 16,
                  )),
                  ListTile(
                      title: CustomText(
                    style: Style.normal,
                    textColor: Colors.black,
                    text: 'Ngày kết thúc:$formattedEndDate',
                    textSize: 16,
                  )),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _customTileExpanded = expanded;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
