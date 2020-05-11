import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewTag extends StatefulWidget {
  final String uid;
  NewTag({Key key, this.uid}) : super(key: key);

  @override
  _NewTagState createState() => _NewTagState();
}

class _NewTagState extends State<NewTag> {
  String tagValue = '';
  TextEditingController ctr = TextEditingController();
  void _onAddTag() async {
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('users').document(widget.uid).updateData({
      'tags': FieldValue.arrayUnion([tagValue]),
    }).then((onValue) {
      ctr.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: ctr,
            onChanged: (value) => setState(() {
              tagValue = value;
            }),
            decoration: InputDecoration(
              labelText: 'Добавить тег',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(Icons.done),
            color: Theme.of(context).primaryColor,
            onPressed: tagValue.trim().isEmpty ? null : _onAddTag,
          ),
        ),
      ],
    );
  }
}
