import 'dart:convert';

import 'package:flutter_application_1/content/captchaContainer.dart';
import 'package:flutter_application_1/content/is_loggedIn.dart';
import 'package:flutter_application_1/content/pr0_comment.dart';
import 'package:flutter_application_1/content/pr0gramm_content.dart';
import 'package:flutter_application_1/content/pr0gramm_content_container.dart';
import 'package:flutter_application_1/content/pr0gramm_info.dart';
import 'package:flutter_application_1/content/pr0gramm_login.dart';
import 'package:flutter_application_1/content/pr0gramm_logout.dart';
import 'package:flutter_application_1/content/pr0gramm_tag.dart';
import 'package:http/http.dart';

import 'request_response_handler.dart';

abstract class ResponseParser {
  static RequestResponseHandler rrh = RequestResponseHandler();

  //Content
  static Future<Pr0ContentContainer> getPr0grammContentContainer(
      int promoted, int flags,
      {String tag}) async {
    Response response =
        await rrh.itemsGet(promotedNum: promoted, flagsNum: flags, tag: tag);
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    final contentContainer = Pr0ContentContainer.fromJson(parsedJson);
    return contentContainer;
  }

  static Future<List<Pr0grammContent>> getContentWithoutPermission() async {
    Response response = await rrh.itemsGetWithoutPermission();
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    final contentContainer = Pr0ContentContainer.fromJson(parsedJson);

    List<Pr0grammContent> pr0grammContentList = List<Pr0grammContent>();
    pr0grammContentList =
        contentContainer.items.map((i) => Pr0grammContent.fromJson(i)).toList();
    return pr0grammContentList;
  }

  static Future<List<Pr0grammContent>> getPr0grammContentList(
      int promoted, int flags,
      {String tag}) async {
    Pr0ContentContainer pr0grammContentContainer =
        await getPr0grammContentContainer(promoted, flags, tag: tag);
    List<Pr0grammContent> pr0grammContentList = List<Pr0grammContent>();
    pr0grammContentList = pr0grammContentContainer.items
        .map((i) => Pr0grammContent.fromJson(i))
        .toList();
    return pr0grammContentList;
  }

  //Info
  static Future<Pr0grammInfo> getPr0grammInfo(int itemID) async {
    // itemID = 680;
    Response response = await rrh.itemsInfo(itemID);
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    Pr0grammInfo pr0grammInfo = Pr0grammInfo.fromJson(parsedJson);
    return pr0grammInfo;
  }

  static getTagsOverID(int pr0grammContentID) async {
    return getTags((await getPr0grammInfo(pr0grammContentID)));
  }

  static getCommentsOverContent(
    Pr0grammContent content, {
    List<String> names,
  }) async {
    List<String> nameList =
        names == null ? [content.user] : [content.user] + names;
    return getComments((await getPr0grammInfo(content.id)), names: nameList);
  }

  static getCommentsOverID(
    int pr0grammContentID, {
    List<String> names,
  }) async {
    return getComments((await getPr0grammInfo(pr0grammContentID)));
  }

  static getTags(Pr0grammInfo pr0grammInfo) {
    List<Pr0grammTag> pr0grammTagList = List<Pr0grammTag>();
    pr0grammTagList =
        pr0grammInfo.tags.map((i) => Pr0grammTag.fromJson(i)).toList();
    return pr0grammTagList;
  }

  static getComments(Pr0grammInfo pr0grammInfo, {List<String> names}) {
    List<Pr0Comment> pr0grammCommentList = List<Pr0Comment>();
    pr0grammCommentList = pr0grammInfo.comments.map((elem) {
      return Pr0Comment.fromJson(
        elem,
        names: names,
      );
    }).toList();
    return pr0grammCommentList;
  }

  //Login
  static Future<Pr0grammLogin> getPr0grammLogin({
    String username,
    String password,
    String captcha,
    String token,
  }) async {
    Response response = await rrh.login(username, password, captcha, token);
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    return Pr0grammLogin.fromJson(parsedJson);
  }

  static setCookie(String cookies) {
    rrh.setCookie(cookies);
  }

  static Future<IsLoggedIn> isLoggedIn() async {
    Response response = await rrh.isLoggedIn();
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    return IsLoggedIn.fromJson(parsedJson);
  }

  static Future<Pr0grammLogout> logout() async {
    Response response = await rrh.logout();
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    return Pr0grammLogout.fromJson(parsedJson);
  }

  static Future<CaptchaContainer> getCaptcha() async {
    Response response = await rrh.captcha();
    Map<String, dynamic> parsedJson = jsonDecode(response.body);
    return CaptchaContainer.fromJson(parsedJson);
  }
}
