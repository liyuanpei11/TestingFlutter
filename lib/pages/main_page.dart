import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/content/pr0gramm_login.dart';

class MainPage extends StatefulWidget {
  final Pr0grammLogin pr0grammLogin;

  MainPage({this.pr0grammLogin});

  @override
  MainPageState createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  String sFail =
      "Ups, da ist wohl etwas schief gelaufen!\nZum neu laden klicken";

  PageController pageController;
  var currentPageValue = 0.0;

  @override
  void initState() {
    PageController pageController = PageController();

    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return ContentsPage();
  }
}
