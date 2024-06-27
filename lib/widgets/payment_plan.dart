import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class PaymentPlan extends StatefulWidget {
  PlanType currentPlanType;
  PlanType planType;
  String planName;
  String planPrice;
  final Function(PlanType) onPlanSelected;

  PaymentPlan({
    super.key,
    required this.currentPlanType,
    required this.planType,
    required this.planName,
    required this.planPrice,
    required this.onPlanSelected,
  });

  @override
  State<StatefulWidget> createState() {
    return PaymentPlanState();
  }
}

enum PlanType { normal, premium }

class PaymentPlanState extends State<PaymentPlan> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Center(
                child: Text(
                  widget.planName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  widget.planPrice,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(
                color: Colors.black,
                thickness: 2,
                height: 2,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.gray80,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/icon_bookmark_64.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                        widget.planType == PlanType.normal
                            ? 'Tối đa 10 \nBookmark'
                            : 'Không giới hạn \nBookmark',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/icon_book_100.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                        widget.planType == PlanType.normal
                            ? 'Được phép \ntruy cập mọi \nloại sách \nthông thường'
                            : 'Được phép \ntruy cập mọi \nloại sách \nkhông giới hạn',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.black,
                thickness: 2,
                height: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Radio<PlanType>(
                    value: widget.planType,
                    groupValue: widget.currentPlanType,
                    onChanged: (value) {
                      if (value != null) {
                        widget.onPlanSelected(value);
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      widget.currentPlanType == widget.planType
                          ? 'Đang sử dụng'
                          : 'Chọn',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
