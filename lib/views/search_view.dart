import 'package:ebook/utils/app_color.dart';
import 'package:ebook/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/main_wrapper_controller.dart';
import '../controller/search_controller.dart';

class SearchView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchViewState();
  }
}

class SearchViewState extends State<SearchView> {
  // final List<Book> dumiesBookList = [
  //   Book(
  //       id: 1,
  //       book_type: BookType.NORMAL,
  //       published_year: 2014,
  //       rating: 10,
  //       name: "Nuôi Con Bằng Trái Tim Tỉnh Thức",
  //       progress: 0,
  //       image:
  //           "https://thuvienhoasen.org/images/file/SFO5nWNm2ggBAmBH/hat-giong-tam-hon.png",
  //       lyric: null,
  //       src_audio: "",
  //       language: "VNI",
  //       description:
  //           "Tôi từng đọc đâu đó rằng từ khi có con, trái tim chúng ta nhảy ra khỏi lồng ngực và bắt đầu đi loanh quanh trên đôi chan của chúng nó mãi mãi. Nỗi đau, cái đẹp, sự bất lực và sự tuyệt vời"),
  //   Book(
  //       id: 1,
  //       book_type: BookType.NORMAL,
  //       published_year: 2014,
  //       rating: 10,
  //       name: "Nuôi Con Bằng Trái Tim Tỉnh Thức",
  //       progress: 0,
  //       image: "https://nxbhcm.com.vn/Image/Biasach/dacnhantam86.jpg",
  //       lyric: null,
  //       src_audio: "",
  //       language: "VNI",
  //       description:
  //           "Tôi từng đọc đâu đó rằng từ khi có con, trái tim chúng ta nhảy ra khỏi lồng ngực và bắt đầu đi loanh quanh trên đôi chan của chúng nó mãi mãi. Nỗi đau, cái đẹp, sự bất lực và sự tuyệt vời"),
  //   Book(
  //       id: 1,
  //       book_type: BookType.NORMAL,
  //       published_year: 2014,
  //       rating: 10,
  //       name: "Nuôi Con Bằng Trái Tim Tỉnh Thức",
  //       progress: 0,
  //       image:
  //           "https://thuvienhoasen.org/images/file/SFO5nWNm2ggBAmBH/hat-giong-tam-hon.png",
  //       lyric: null,
  //       src_audio: "",
  //       language: "VNI",
  //       description:
  //           "Tôi từng đọc đâu đó rằng từ khi có con, trái tim chúng ta nhảy ra khỏi lồng ngực và bắt đầu đi loanh quanh trên đôi chan của chúng nó mãi mãi. Nỗi đau, cái đẹp, sự bất lực và sự tuyệt vời"),
  // ];

  // final List<Genre> controller.genreList = [
  //   Genre(id: 1, name: 'Hài hước', image: ''),
  //   Genre(id: 2, name: 'Tình cảm', image: ''),
  //   Genre(id: 3, name: 'Lãng mạn', image: ''),
  //   Genre(id: 4, name: 'Hành động', image: ''),
  //   Genre(id: 5, name: 'Phiêu lưu', image: '')
  // ];

  final List<String> _sortList = ['Tên sách', 'Đánh giá'];

  int? _filterOption;
  String? _sortOption = 'None';
  String currentSearchText = '';
  final _textEditingController=TextEditingController();

  void _showFilteringModalBottomSheet(
      BuildContext context, SearchViewController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Thể loại',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.genreList.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(controller.genreList[index].name),
                          value: controller.genreList[index].id.toString(),
                          groupValue: _filterOption.toString(),
                          toggleable: true,
                          onChanged: (String? value) {
                            setState(() {
                              if (value == null) {
                                _filterOption = null;
                                Provider.of<SearchViewController>(context,
                                        listen: false)
                                    .firstLoad(currentSearchText, null, 10, 0);
                              } else {
                                _filterOption = int.parse(value!);
                                Provider.of<SearchViewController>(context,
                                        listen: false)
                                    .firstLoad(currentSearchText, _filterOption,
                                        10, 0);
                              }
                            });

                            // Thằng này dùng để đóng bottom sheet
                            // Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortingModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sắp xếp',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _sortList.length,
                    itemBuilder: (context, index) {
                      return RadioListTile<String>(
                        title: Text(_sortList[index]),
                        value: _sortList[index],
                        groupValue: _sortOption,
                        toggleable: true,
                        onChanged: (String? value) {
                          Provider.of<SearchViewController>(context,
                                  listen: false)
                              .sortList(_sortOption);

                          setState(() {
                            if (value == null || value.isEmpty) {
                              _sortOption = null;
                            } else {
                              _sortOption = value!;
                            }
                          });

                          // Thằng này dùng để đóng bottom sheet
                          // Navigator.pop(context);
                        },
                      );
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<SearchViewController>(context, listen: false).loadGenreList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: AppColors.blue,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              SearchBar(
              controller: _textEditingController,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
              },
              onChanged: (value) {
                currentSearchText = value;
              },
              onSubmitted: (value) {
                try {
                  Provider.of<SearchViewController>(context,
                      listen: false)
                      .firstLoad(
                      currentSearchText, _filterOption, 10, 0);
                } catch (e) {
                  debugPrint('Exception from search:${e}');
                }
              },
              leading: const Icon(Icons.search),
            ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _showFilteringModalBottomSheet(
                          context,
                          Provider.of<SearchViewController>(context,
                              listen: false));
                    },
                    icon: Image.asset('assets/icons/icon_filter_64.png',
                        width: 24, height: 24, fit: BoxFit.cover),
                    label: const Text('Bộ lọc',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      onPressed: () {
                        _showSortingModalBottomSheet(context);
                      },
                      icon: Image.asset('assets/icons/icon_sort_50.png',
                          width: 24, height: 24, fit: BoxFit.cover),
                      label: const Text('Sắp xếp',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ]),
          ),
          Expanded(
            child: Container(
                padding:
                    const EdgeInsets.only(top: 30, left: 20, right: 20),
                color: Colors.white,
                child: ListBookVertical()),
          )
        ]),
      ),
    );
  }
}
