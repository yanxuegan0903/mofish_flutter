import 'package:mofish_flutter/model/baseModel.dart';


class FishpondListModel {
  int?code;
  String?message;
  FishpondListData? data;

  FishpondListModel({this.code, this.message, this.data});

  FishpondListModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    message = json['Message'];
    data = json['Data'] != null ? FishpondListData.fromJson(json['Data']) : null;
  }

}

class FishpondListData {
  List<FishpondListItem>? data;

  FishpondListData({this.data});

  FishpondListData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FishpondListItem>[];
      json['data'].forEach((v) {
        data?.add(FishpondListItem.fromJson(v));
      });
    }
  }
}

class FishpondListItem {
  int?id;
  int?createTime;
  int?commentNum;
  int?approvalNum;
  String?title;
  String?hotDesc;
  String?url;
  String?imgUrl;
  String?type;
  String?isRss;
  int?isAgree;
  String?icon;
  String?tid;

  FishpondListItem(
      {this.id,
        this.createTime,
        this.commentNum,
        this.approvalNum,
        this.title,
        this.hotDesc,
        this.url,
        this.imgUrl,
        this.type,
        this.isRss,
        this.isAgree,
        this.icon,
        this.tid});

  FishpondListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['CreateTime'];
    commentNum = json['commentNum'];
    approvalNum = json['approvalNum'];
    title = json['Title'];
    hotDesc = json['hotDesc'];
    url = json['Url'];
    imgUrl = json['imgUrl'];
    type = json['type'];
    isRss = json['isRss'];
    isAgree = json['is_agree'];
    icon = json['icon'];
    tid = json['tid'];
  }
}