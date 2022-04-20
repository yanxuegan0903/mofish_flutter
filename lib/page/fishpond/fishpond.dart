// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:mofish_flutter/page/fishpond/fishpondListModel.dart';
import 'package:mofish_flutter/page/fishpond/fishpondModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:mofish_flutter/page/search/search.dart';
import 'package:mofish_flutter/page/webview/webViewPage.dart';
import 'package:mofish_flutter/request/baseRequest.dart';

typedef OnClickCategory = Function(int index);
typedef OnClickCategoryItem = Function(int index, String id);
typedef OnClickListItem = Function(FishpondListItem item);

class fishpondPage extends StatefulWidget {
  const fishpondPage({Key? key}) : super(key: key);

  @override
  _fishpondPageState createState() => _fishpondPageState();
}

class _fishpondPageState extends State<fishpondPage>
    with AutomaticKeepAliveClientMixin {
  FishpondModel? model;
  int _selectCategoryIndex = 0;
  int _selectItemIndex = 0;
  List<FishpondListItem>? _list;
  ScrollController _categoryController = ScrollController();
  ScrollController _listController = ScrollController();
  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchAllCategorys();

    _listController.addListener(() {
      if (_listController.position.pixels ==
          _listController.position.maxScrollExtent) {
        int pageIndex = _page + 1;
        _fetchCategoryItems(page: pageIndex);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();

    _categoryController.dispose();

    _listController.removeListener(() {});
    _listController.dispose();
  }

  onClickCategory(int index) {
    if (_selectCategoryIndex != index) {
      setState(() {
        _selectItemIndex = 0;
        _selectCategoryIndex = index;
      });

      _categoryController.animateTo(
        0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      _listController.animateTo(
        0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      _fetchCategoryItems();
    }
  }

  onClickCategoryItem(int index, String id) {
    if (index != _selectItemIndex) {
      setState(() {
        _selectItemIndex = index;
      });
      _listController.animateTo(
        0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      _fetchCategoryItems();
    }
  }

  onClickListItem(FishpondListItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return WebviewPage(
          item.url ?? "",
        );
      }),
    );
  }

  int getLengthFormCategory() {
    FishpondData? data = model?.data?[_selectCategoryIndex];
    if ((data?.items?.length ?? 0) > 0) {
      return data!.items!.length;
    }
    return 0;
  }

  //  请求鱼塘的所有item
  _fetchAllCategorys() async{
    var request = BaseRequest("https://api.tophub.fun","GetAllType");
    var result = await request.get();
    setState(() {
      model = FishpondModel.fromJson(result);
    });
    _fetchCategoryItems();
  }

  Future<List> _fetchCategoryItems({int page = 0}) async {
    if (_selectItem != null) {
      _page = page;
      String url =
          'https://api.tophub.fun/v2/GetAllInfoGzip?id=${_selectItem!.id}&page=$page&type=android';
      var response = await http.get(Uri.parse(url));
      FishpondListModel listModel = FishpondListModel.fromJson(
          convert.jsonDecode(convert.utf8.decode(response.bodyBytes)));
      if (page == 0) {
        _list = <FishpondListItem>[];
        _list?.addAll(listModel.data?.data ?? []);
      } else {
        _list?.addAll(listModel.data?.data ?? []);
      }

      setState(() {});
    }
    return [];
  }

  FishpondItem? get _selectItem {
    if ((model?.data?.length ?? 0) > 0) {
      FishpondData data = model!.data![_selectCategoryIndex];
      if ((data.items?.length ?? 0) > 0) {
        FishpondItem? item = data.items?[_selectItemIndex];
        return item;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double _paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage();
          }));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Icon(
              Icons.search,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: _paddingTop),
        decoration: BoxDecoration(color: Color.fromARGB(255, 245, 245, 245)),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 235, 235, 235),
              ),
              margin: EdgeInsets.only(left: 5),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  FishpondData? data = model?.data?[index];
                  return CategoryCell(
                    name: data?.itemKey ?? '',
                    index: index,
                    onClick: onClickCategory,
                    isSelect: index == _selectCategoryIndex,
                  );
                },
                itemCount: model?.data?.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 235, 235, 235),
              ),
              margin: EdgeInsets.fromLTRB(5, 2, 0, 0),
              child: ListView.builder(
                controller: _categoryController,
                itemBuilder: (BuildContext context, int index) {
                  FishpondData data = model!.data![_selectCategoryIndex];
                  FishpondItem item = data.items![index];
                  return CategoryItemCell(
                    item: item,
                    index: index,
                    onClick: onClickCategoryItem,
                    isSelect: index == _selectItemIndex,
                  );
                },
                itemCount: getLengthFormCategory(),
                scrollDirection: Axis.horizontal,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchCategoryItems,
                child: ListView.builder(
                  controller: _listController,
                  padding: EdgeInsets.only(top: 10),
                  itemBuilder: (BuildContext context, int index) {
                    FishpondListItem? item = _list?[index];
                    return ListItemCell(
                      item: item,
                      onClick: onClickListItem,
                    );
                  },
                  itemCount: (_list?.length ?? 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ListItemCell extends StatelessWidget {
  FishpondListItem? item;
  OnClickListItem? onClick;

  ListItemCell({Key? key, this.onClick, this.item}) : super(key: key);

  Widget getIcon() {
    if ((item?.icon?.length ?? 0) > 0 &&
        (item?.icon?.startsWith('http') ?? false)) {
      return Image.network(
        item!.icon!,
        width: 20,
        height: 20,
        errorBuilder: ((BuildContext context, Object error, StackTrace? stackTrace,) {
          return Container();
        }),
      );
    }

    return Container();
  }

  Widget getImage() {
    if ((item?.imgUrl?.length ?? 0) > 0 &&
        (item?.imgUrl?.startsWith('http') ?? false)) {
      return Container(
        padding: EdgeInsets.only(right: 10),
        alignment: Alignment.centerLeft,
        child: Image.network(
          item!.imgUrl!,
          width: 70,
          height: 70,
          errorBuilder: ((BuildContext context, Object error, StackTrace? stackTrace,) {
            return Container();
          }),
        ),

      );
    }

    return Container();
  }

  String getTimeStr() {
    if (item?.createTime != null) {
      DateTime time =
          DateTime.fromMillisecondsSinceEpoch(item!.createTime! * 1000);
      return '${time.year}/${time.month}/${time.day} ${time.hour}:${time.second}';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GestureDetector(
      onTap: () {
        if (onClick != null) {
          onClick!(item!);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
        // decoration: BoxDecoration(color: Colors.red),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getImage(),
              Expanded(
                // widthFactor: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item?.title ?? '',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            child: Container(
                              child: Wrap(children: [
                                getIcon(),
                                Text(item?.type ?? '')
                              ]),
                              padding: EdgeInsets.only(right: 10),
                            ),
                            visible: (item?.icon?.length ?? 0) > 0 ||
                                (item?.type?.length ?? 0) > 0,
                          ),
                          Visibility(
                              child: Container(
                                child: Text(item?.hotDesc ?? ''),
                                padding: EdgeInsets.only(right: 10),
                              ),
                              visible: (item?.hotDesc?.length ?? 0) > 0),
                          Visibility(
                              child: Text(getTimeStr()),
                              visible: (item?.createTime != null)),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                  ),
                                  Text('收藏'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                  ),
                                  Text('评论'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 1,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 211, 211, 211),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItemCell extends StatelessWidget {
  FishpondItem? item;
  int? index;
  bool? isSelect;
  OnClickCategoryItem? onClick;

  CategoryItemCell(
      {Key? key, this.item, this.onClick, this.index, this.isSelect})
      : super(key: key);

  Widget getIcon() {
    if ((item?.icon?.length ?? 0) > 0 &&
        (item?.icon?.startsWith('http') ?? false)) {
      return Container(
        child: Image.network(
          item!.icon!,
          width: 20,
          height: 20,
          fit: BoxFit.fill,
          errorBuilder: ((BuildContext context, Object error, StackTrace? stackTrace,) {
            return Container();
          }),
        ),
        padding: EdgeInsets.only(right: 5),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ((isSelect ?? false) ? Colors.green : Colors.transparent),
      child: TextButton(
          onPressed: () {
            if (onClick != null) {
              onClick!(index ?? 0, item?.id ?? '');
            }
          },
          child: Row(
            children: [
              getIcon(),
              Text(
                item?.name ?? '',
                style: TextStyle(
                    fontSize: 20,
                    color: (isSelect ?? false) ? Colors.white : Colors.black),
              ),
            ],
          )),
    );
  }
}

class CategoryCell extends StatelessWidget {
  String? name;
  int? index;
  bool? isSelect;
  OnClickCategory? onClick;

  CategoryCell({Key? key, this.name, this.onClick, this.index, this.isSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ((isSelect ?? false) ? Colors.green : Colors.transparent),
      // margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: TextButton(
        onPressed: () {
          if (onClick != null) {
            onClick!(index ?? 0);
          }
        },
        child: Text(
          name ?? '',
          style: TextStyle(
              fontSize: 22,
              color: (isSelect ?? false) ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
