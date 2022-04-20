

class BaseRequest {
  int? code;
  String? message;
  BaseRequest({this.code,this.message});

  BaseRequest.fromJson(Map<String,dynamic> json){
    if (json['Code'] != null){
      code = json['Code'];
    }
    if (json['Message'] != null){
      message = json['Message'];
    }
  }
  //
  // Map<String,dynamic>toJson(){
  //
  //   Map<String,dynamic> data = Map<String,dynamic>();
  //   if(Code != null){
  //     data["Code"] = Code;
  //   }
  //
  //   if(Message != null){
  //     data['Message'] = Message;
  //   }
  //
  //   if (data != null){
  //     toStr(data);
  //   }
  //
  //   return data;
  // }
  //
  // toStr(dynamic data){
  //   if (data is List){
  //     data.map((e) => toStr(e));
  //   }
  //   if (data is Map){
  //     data.map((key, value) => toStr(value));
  //   }
  //   print(data);
  // }

}