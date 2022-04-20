

class LastestListModel {
  int?code;
  String?message;
  List<LastestListItem>? data;

  LastestListModel({this.code, this.message, this.data});

  LastestListModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    message = json['Message'];

    if (json['Data'] != null){
      data = <LastestListItem>[];
      json['Data'].forEach((e){
        data?.add(LastestListItem.fromJson(e));
      });
    }

  }

}

class LastestListItem {
  String?id;
  String?createTime;
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
  String?desc;
  String?sort;
  String?img;
  LastestListItem(
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
        this.tid,
        this.desc,
        this.img,
        this.sort});

  LastestListItem.fromJson(Map<String, dynamic> json) {
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
    desc = json['Desc'];
    sort = json['sort'];
    img = json['img'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CreateTime'] = createTime;
    data['Desc'] = desc;
    data['Title'] = title;
    data['Url'] = url;
    data['icon'] = icon;
    data['id'] = id;
    data['img'] = img;
    data['imgUrl'] = imgUrl;
    data['sort'] = sort;
    data['tid'] = tid;
    data['type'] = type;
    data['sort'] = sort;
    data['img'] = img;
    return data;
  }
}