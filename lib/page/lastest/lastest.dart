import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:mofish_flutter/page/lastest/lastestModel.dart';
import 'package:mofish_flutter/page/webview/webViewPage.dart';

typedef OnClickLastestItem = Function(LastestListItem item);

class lastestPage extends StatefulWidget {
  const lastestPage({Key? key}) : super(key: key);

  @override
  _lastestPageState createState() => _lastestPageState();
}

class _lastestPageState extends State<lastestPage> with AutomaticKeepAliveClientMixin {
  LastestListModel? _model;
  int _page = 0;
  List<LastestListItem>? _list;

  ScrollController _listController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchLastestItems();

    _listController.addListener(() {
      if (_listController.position.pixels ==
          _listController.position.maxScrollExtent) {
        int pageIndex = _page + 1;
        _fetchLastestItems(page: pageIndex);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();

    _listController.removeListener(() {});
    _listController.dispose();
  }

  Future<List> _fetchLastestItems({int page = 0}) async {
    _page = page;
    String url = 'https://api.tophub.fun/GetRandomInfo?time=$page&is_follow=0';
    var response = await http.get(Uri.parse(url));
    LastestListModel listModel = LastestListModel.fromJson(
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)));
    if (page == 0) {
      _list = <LastestListItem>[];
      _list?.addAll(listModel.data ?? []);
    } else {
      _list?.addAll(listModel.data ?? []);
    }

    setState(() {});
    return [];
  }

  onClickListItem(LastestListItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return WebviewPage(
          item.url ?? "",
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('最新'),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: _fetchLastestItems,
          child: ListView.builder(
            controller: _listController,
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (BuildContext context, int index) {
              LastestListItem? item = _list?[index];
              return LastestItemCell(
                item: item,
                onClick: onClickListItem,
              );
            },
            itemCount: (_list?.length ?? 0),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class LastestItemCell extends StatelessWidget {
  LastestListItem? item;
  OnClickLastestItem? onClick;

  LastestItemCell({Key? key, this.onClick, this.item}) : super(key: key);

  Widget getIcon() {
    if ((item?.icon?.length ?? 0) > 0) {
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
      DateTime time = DateTime.fromMillisecondsSinceEpoch(
          int.parse(item!.createTime!) * 1000);
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
