// ignore_for_file: curly_braces_in_flow_control_structures, empty_constructor_bodies

import 'package:mofish_flutter/model/baseModel.dart';

class FishpondModel {
  int?code;
  String?message;
  List<FishpondData>? data;

  FishpondModel({int? code, String? message, this.data});

  FishpondModel.fromJson(Map<String, dynamic> json) {

    if (json['Code'] != null) {
      code = json['Code'];
    }
    if (json['Message'] != null) {
      message = json['Message'];
    }
    if (json['Data'] != null) {
      data = <FishpondData>[];
      Map DataStr = json["Data"];
      DataStr.forEach((key, value) {
        data?.add(FishpondData.fromJson(key, value));
      });
    }
  }
}

class FishpondData {
  List<FishpondItem>? items;
  String? itemKey;

  FishpondData({this.items, this.itemKey});

  FishpondData.fromJson(String key, List json) {
    itemKey = key;
    items = json.map((e) => FishpondItem.fromJson(e)).toList();
  }
}

class FishpondItem {
  String? icon;
  String? id;
  String? img;
  String? name;
  String? type;

  FishpondItem({this.icon, this.id, this.img, this.name, this.type});

  FishpondItem.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    id = json['id'];
    img = json['img'];
    name = json['name'];
    type = json['type'];
  }
}
