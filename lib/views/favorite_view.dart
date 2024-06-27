
import 'package:ebook/widgets/custom_text.dart';
import 'package:ebook/widgets/favorite_list_book_vertical.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../widgets/search_list_book_vertical.dart';

class Favorite extends StatefulWidget{
  const Favorite({super.key});

  @override
  State<StatefulWidget> createState() {
    return FavoriteState();
  }

}

class FavoriteState extends State<Favorite>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: AppColors.blue,
        width: double.infinity,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: CustomText(textSize: 18,style: Style.bold,textColor: Colors.white,text: 'Thư viện'),
            decoration: BoxDecoration(
              color: AppColors.blue
            ),
          ),
          FavoriteListBookVertical(),
        ]),
      ),
    );
  }

}