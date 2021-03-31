import 'package:http/http.dart' as http;
import 'dart:async';
import 'debug.dart';
import 'preferences.dart';

class RequestResponseHandler {
  static String pr0Api = 'https://pr0gramm.com/api';
  Map<String, String> headers = {};

  String paramsMaker(List<String> stringList) {
    String retString = "?";
    for (int index = 0; index < stringList.length; index++) {
      retString += stringList[index] + '&';
    }
    return retString.substring(0, retString.length - 1);
  }

  Future<http.Response> itemsGetWithoutPermission() async {
    print("asd");
    // final a = await get(url: "/items/get");

    // print(a);

    return get(url: "/items/get");
  }

  Future<http.Response> itemsGet({
    int promotedNum = 1,
    int flagsNum = 9,
    String tag,
  }) async {
    List<String> paramList = [];
    String promoted = "promoted=" + promotedNum.toString();
    String flags = "flags=" + flagsNum.toString();
    paramList.add(flags);
    paramList.add(promoted);

    if (tag != null) {
      // TODO: Is that necessary?
      // print("Tag: " + tag);
      String tags = "tags=" + tag;
      paramList.add(tags);
    }

    String req = paramsMaker(paramList);
    return get(url: "/items/get$req");
  }

  Future<http.Response> itemsInfo(int num) async {
    return get(url: "/items/info?itemId=" + num.toString());
  }

  Future<http.Response> login(
    String name,
    String password,
    String captcha,
    String token,
  ) async {
    print("Login");
    print("name: $name");
    print("password: $password");
    print("captcha: $captcha");
    print("token: $token");
    Uri uri = new Uri(
        path: 'https://pr0gramm.com/api/user/login'); // TODO: Check ob das geht
    return updateCookie(await http.post(
      uri,
      headers: headers,
      body: {
        'name': name,
        'password': password,
        'captcha': captcha,
        'token': token
      },
    ));
  }

  Future<http.Response> logout() async {
    if (internetDEBUG) {
      print("Logout");
    }
    return get(url: "/user/logout");
  }

  Future<http.Response> isLoggedIn() async {
    if (internetDEBUG) {
      print("IsLoggedIn");
    }
    return get(url: "/user/loggedin");
  }

  Future<http.Response> captcha() async {
    return get(url: "/user/captcha");
  }

  Future<http.Response> get({String url}) async {
    var url = Uri.https('www.googleapis.com', '/books/v1/volumes');
    // var url = Uri.https('www.pr0gramm.com', '/api/items/get');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      return response;
    } else {
      print('Response body: ${response.body}');
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
    // String requestPath = pr0Api + url;
    // Uri request;
    // try {
    //   String proApi = 'www.google.de';
    //   request = new Uri.https(proApi, "/helloworld"); // TODO: Test ob das geht
    //   print(request);
    //   if (internetDEBUG) {
    //     print("Request: " + request.path.toString());
    //     if (headers != null) {
    //       print("Header: " + headers.toString());
    //     }
    //   }
    //   print("DEBUG LI");
    //   return await http.get(Uri.https(proApi, "/helloworld"));
    // http.Response response = await http.get(request, headers: headers);
    // print("DEBUG LI");
    // print(response.body);
    // print("DEBUG LI");
    // return response;
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

  setCookie(String cookies) async {
    if (internetDEBUG) {
      print("Setting new cookie..");
    }
    Preferences.saveCookies(cookies);
    headers['Cookie'] = cookies;
  }

  http.Response updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      var strings = rawCookie.split(",");
      String addCookie = "";
      for (int i = 0; i < strings.length; i++) {
        if (strings[i].contains("me") ||
            strings[i].contains("pp") ||
            strings[i].contains("__cfduid")) {
          addCookie += strings[i].split(";").first + ";";
        }
      }
      addCookie = addCookie.substring(0, addCookie.length - 1);
      setCookie(addCookie);
    }
    return response;
  }
}
