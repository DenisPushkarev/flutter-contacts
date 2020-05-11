import 'package:contacts/widgets/new_tag.dart';
import 'package:contacts/widgets/tags.dart';
import 'package:flutter/material.dart';

class UserTags extends StatefulWidget {
  final String uid;

  UserTags({Key key, this.uid}) : super(key: key);

  @override
  _UserTagsState createState() => _UserTagsState();
}

class _UserTagsState extends State<UserTags> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NewTag(uid: widget.uid),
        TagsList(
          uid: widget.uid,
          // onDeleteTag: _onDeleteTag,
        ),
      ],
    );
  }
}
