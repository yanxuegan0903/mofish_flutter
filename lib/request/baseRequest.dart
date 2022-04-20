// ignore_for_file: unnecessary_this, unnecessary_brace_in_string_interps, avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class BaseRequest {

  final String baseUrl;
  final String apiUrl;
  Map? params;
  BaseRequest(this.baseUrl, this.apiUrl);

  Future<Map<String,dynamic>> get() async{
    String url = appendApiUrl();
    if (params?.isNotEmpty ?? false){
      url = appendParams(url);
    }
    print("请求的url:${url}");
    var response = await http.get(Uri.parse(url));
    var jsonMap = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    print("result:${jsonMap}");
    return jsonMap;
  }

  String appendApiUrl(){
    return this.baseUrl+"/${this.apiUrl}";
  }

  String appendParams(String url){
    String str = "";
    params?.forEach((key, value) {
      str = str+"&$key=$value";
      return ;
    });
    if (str.isNotEmpty){
      str = str.replaceRange(0, 1, "?");
    }

    return url+str;
  }

}