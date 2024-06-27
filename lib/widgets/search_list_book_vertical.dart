import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:ebook/controller/search_controller.dart';

import '../controller/audio_controller.dart';
import '../model/Book.dart';

class ListBookVertical extends StatefulWidget {
  int? genreID;
  String? name;

  ListBookVertical({super.key, this.genreID, this.name});

  @override
  State<StatefulWidget> createState() {
    return ListBookVerticalState();
  }
}

class ListBookVerticalState extends State<ListBookVertical> {
  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 2, milliseconds: 0));
    SearchViewController controller =
        Provider.of<SearchViewController>(context, listen: false);
    int offset = controller.bookList.bookList.length;
    controller.loadMore(widget.name ?? '', widget.genreID, 5, offset);
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<SearchViewController>(context, listen: false)
          .firstLoad('', null, 10, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadMore(
      isFinish: Provider.of<SearchViewController>(context, listen: true)
          .bookList
          .bookList
          .length >=
          Provider.of<SearchViewController>(context, listen: true)
              .bookList
              .maxLength,
      onLoadMore: _loadMore,
      child: ListView.builder(
        itemCount:
        Provider.of<SearchViewController>(context, listen: true)
            .bookList
            .bookList
            .length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Column(children: [
            GestureDetector(
              onTap: () {
                SearchViewController searchViewController=Provider.of<SearchViewController>(context, listen: false);
                List<Book> bookList=searchViewController.bookList.bookList;
                context.push("/detailBook",extra: bookList[index]);

              },
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: Provider.of<SearchViewController>(context,
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
                    Provider.of<SearchViewController>(context, listen: true)
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
    );
  }
}
