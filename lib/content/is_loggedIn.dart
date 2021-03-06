import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/design/pr0gramm_colors.dart';

class IsLoggedIn extends StatelessWidget {
  final bool loggedIn;
  final int ts;
  final String cache;
  final int rt;
  final int qc;

  IsLoggedIn({
    this.loggedIn = false,
    this.ts,
    this.cache,
    this.rt,
    this.qc,
  });

  factory IsLoggedIn.fromJson(Map<String, dynamic> parsedJson) {
    return new IsLoggedIn(
      loggedIn: parsedJson['loggedIn'],
      ts: parsedJson["ts"],
      cache: parsedJson["cache"],
      rt: parsedJson["rt"],
      qc: parsedJson["qc"],
    );
  }

  String asString() {
    String heading = " IsLoggedIn:\n";
    String body = " loggedIn: $loggedIn\n ts: $ts\n"
        " cache: $cache\n rt: $rt\n qc: $qc\n";
    return heading + body;
  }

  greyText(String s) {
    return Text(s, style: TextStyle(color: standardSchriftfarbe));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        greyText(asString()),
      ],
    );
  }
}
