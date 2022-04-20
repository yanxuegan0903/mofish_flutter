// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mofish_flutter/page/lastest/lastest.dart';
import 'package:mofish_flutter/page/lastest/lastestModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:mofish_flutter/page/webview/webViewPage.dart';
import 'package:mofish_flutter/request/baseRequest.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  List<LastestListItem>? _list;

  _searchWithKeyword(String keyword) async {

    var request = BaseRequest("https://api.tophub.fun","SearchKey");
    request.params = {"key":keyword};
    var result = await request.get();
    LastestListModel listModel = LastestListModel.fromJson(result);
    _list = <LastestListItem>[];
    _list?.addAll(listModel.data ?? []);
    setState(() {
      
    });
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
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Row(
              children: [
                BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        labelStyle: TextStyle(fontSize: 18),
                        label: Text('请输入关键字'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                      ),
                      // onChanged: (text) {
                      //   _searchWithKeyword(text);
                      // },
                      onSubmitted: (text) {
                        _searchWithKeyword(text);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
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
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
