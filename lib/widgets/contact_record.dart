import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class ContactRecord extends StatelessWidget {
  final dynamic record;
  const ContactRecord(this.record, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.data['name'] ?? '',
                      style: TextStyle(
                        color: Theme.of(context).accentTextTheme.title.color,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          record.data['company'] ?? '',
                          style: TextStyle(
                            color:
                                Theme.of(context).accentTextTheme.title.color,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          record.data['position'] ?? '',
                          style: TextStyle(
                            color:
                                Theme.of(context).accentTextTheme.title.color,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(32),
              ),
              child: IconButton(
                icon: Icon(Icons.phone),
                color: Colors.white,
                iconSize: 32,
                onPressed: (record.data['phone'] == null)
                    ? null
                    : () => launch("tel://" + record.data['phone']),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 8, top: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (record.data['tags'] ?? []).join(', '),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
              SizedBox(width: 58),
            ],
          ),
        ),
      ],
    );
  }
}
