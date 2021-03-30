import 'package:flutter/material.dart';
import 'Design/loadingIndicator.dart';
import 'package:flutter_application_1/content/pr0gramm_content.dart';

class ThumbWidget extends StatelessWidget {
  final Pr0grammContent pr0grammContent;

  ThumbWidget({this.pr0grammContent});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pr0grammContent.getThumbnail(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Hero(
                tag: pr0grammContent.id,
                child: Image.file(snapshot.data),
              )
            : LoadingIndicator();
      },
    );
  }
}
