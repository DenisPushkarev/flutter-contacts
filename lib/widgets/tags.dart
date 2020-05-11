import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TagsList extends StatelessWidget {
  final String uid;
  final Function(String tag) onDeleteTag;
  const TagsList({Key key, this.uid, this.onDeleteTag}) : super(key: key);

  void _onDeleteTag(String tag) {
    Firestore.instance.collection('users').document(uid).updateData({
      'tags': FieldValue.arrayRemove([tag])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
      stream: Firestore.instance.collection('users').document(uid).snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          var tags = snapshot.data.data['tags'] ?? [];
          return ListView.builder(
            itemCount: tags.length,
            itemBuilder: (BuildContext ctx, int index) {
              String tag = tags[index];
              tag = tag.length > 20 ? tag.substring(0, 25) + '... ': tag;
              return Row(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.label_outline),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(tag),
                  ),
                  Spacer(),
                  FlatButton(
                      onPressed: () => _onDeleteTag(tags[index]),
                      child: Icon(Icons.delete)),
                ],
              );
            },
          );
        } else {
          return Text('Тегов нет');
        }
      },
    ));
  }
}
