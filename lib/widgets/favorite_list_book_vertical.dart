import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/controller/favoriteController.dart';
import 'package:ebook/utils/app_navigation.dart';
import 'package:ebook/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_instance.dart';
import '../controller/main_wrapper_controller.dart';
import '../model/Book.dart';

class FavoriteListBookVertical extends StatefulWidget {
  const FavoriteListBookVertical({super.key});

  @override
  State<StatefulWidget> createState() {
    return FavoriteListBookVerticalState();
  }
}

class FavoriteListBookVerticalState extends State<FavoriteListBookVertical> {
  List<String> dropDownList = ['Tên sách', 'Đánh giá'];
  String? dropdownValue;

  Future<bool> _loadMore(int userID) async {
    await Future.delayed(Duration(seconds: 2, milliseconds: 0));
    FavoriteController controller =
        Provider.of<FavoriteController>(context, listen: false);
    int offset = controller.bookList.maxLength;
    controller.loadMore(userID, 5, offset);
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
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
        Provider.of<FavoriteController>(context, listen: false)
            .firstLoad(mainWrapperController.currentUser!.id!, 5, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var accountID = Provider.of<MainWrapperController>(context, listen: true)
        .currentAccount!
        .id!;
    dropdownValue=dropDownList[0];

    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        padding: const EdgeInsets.all(20),
        child: LoadMore(
          isFinish: Provider.of<FavoriteController>(context, listen: true)
                  .bookList
                  .bookList
                  .length >=
              Provider.of<FavoriteController>(context, listen: true)
                  .bookList
                  .maxLength,
          onLoadMore: () {
            return _loadMore(accountID);
          },
          child: Column(
            children: [
              Row(
                children: [
                  CustomText(
                      text:
                          'Số lượng sách: ${Provider.of<FavoriteController>(context, listen: true).bookList.bookList.length}',
                      textSize: 16,
                      style: Style.bold,
                      textColor: Colors.black),
                  const Spacer(),
                  DropdownMenu<String>(
                    initialSelection: dropDownList.first,
                    onSelected: (String? value) {
                      setState(() {
                        dropdownValue = value!;

                        //sort bookList
                        Provider.of<FavoriteController>(context, listen: false).sortList(dropdownValue);

                      });
                    },
                    dropdownMenuEntries:
                        dropDownList.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                    inputDecorationTheme: InputDecorationTheme(
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                      constraints: BoxConstraints.tight(const
                      Size.fromHeight(40)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      Provider.of<FavoriteController>(context, listen: true)
                          .bookList
                          .bookList
                          .length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      GestureDetector(
                        onTap: () {
                          FavoriteController searchViewController =
                              Provider.of<FavoriteController>(context,
                                  listen: false);
                          List<Book> bookList =
                              searchViewController.bookList.bookList;
                          AppNavigation.router
                              .push("/detailBook", extra: bookList[index]);
                        },
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: Provider.of<FavoriteController>(context,
                                      listen: true)
                                  .bookList
                                  .bookList[index]
                                  .image!,
                              width: 110,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              Provider.of<FavoriteController>(context,
                                      listen: true)
                                  .bookList
                                  .bookList[index]
                                  .name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
