import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/response_parser.dart';
import 'package:flutter_application_1/content/captchaContainer.dart';

// TODO: Fix Pr0Captcha - Immutable but not final
class Pr0Captcha extends StatefulWidget {
  String token;
  Function loadNewcaptcha;

  @override
  _Pr0CaptchaState createState() => _Pr0CaptchaState();
}

class _Pr0CaptchaState extends State<Pr0Captcha> {
  Image oldImage;

  void reload() {
    setState(() {});
  }

  @override
  void initState() {
    widget.loadNewcaptcha = reload;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          FutureBuilder(
            key: Key("CaptchaToken"),
            future: ResponseParser.getCaptcha(),
            builder: (context, snapshot) {
              Image currentImage;
              if (snapshot.hasData) {
                CaptchaContainer captchaContainer = snapshot.data;
                int position = captchaContainer.captcha.indexOf(',') + 1;
                if (captchaContainer.captcha.length > position) {
                  Uint8List decoded = base64Decode(
                      captchaContainer.captcha.substring(position));
                  widget.token = captchaContainer.token;
                  currentImage = Image.memory(
                    decoded,
                    key: Key(captchaContainer.token),
                  );
                }
              }

              Stack stack = Stack(
                children: <Widget>[
                  oldImage ?? Container(),
                  AnimatedOpacity(
                    curve: Curves.easeOut,
                    duration: Duration(milliseconds: 400),
                    opacity: oldImage?.key != currentImage?.key ? 1 : 0,
                    child: currentImage ?? Container(),
                  ),
                ],
              );

              oldImage = currentImage;

              return stack;
            },
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: IconButton(
              icon: Icon(
                Icons.repeat,
                color: Colors.white,
                size: 24,
              ),
              onPressed: reload,
            ),
          )
        ],
      ),
    );
  }
}
