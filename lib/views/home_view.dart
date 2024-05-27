
import 'package:ebook/controller/main_wrapper_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/home_controller.dart';
import '../widgets/widgets.dart';

class HomeView extends StatefulWidget{

  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }

}

class HomeViewState extends State<HomeView>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<HomeController>(context, listen: false)
          .firstInit(context, 10, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextButton(
              style: ButtonStyle(
              ),
              onPressed: () {
                  debugPrint('Pressed');
                  MainWrapperController mainController=Provider.of<MainWrapperController>(context,listen:false);
                  mainController.updateShowSongControl(!mainController.showSongControl);
              },
              child: Text('TextButton'),
            ),
            SizedBox(height: 100,),
            BigBookWidget(),
            NormalHorizontalBook(),
            NormalHorizontalBook(),
            NormalHorizontalBook(),
            NormalHorizontalBook(),
          ],
        ),
      ),
    );
  }

}