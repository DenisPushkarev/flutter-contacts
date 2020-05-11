import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/widgets/contact_record.dart';
import 'package:flutter/material.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
// import 'package:location/location.dart';

class UserContacts extends StatefulWidget {
  final String uid;
  const UserContacts({Key key, this.uid}) : super(key: key);

  @override
  _UserContactsState createState() => _UserContactsState();
}

class _UserContactsState extends State<UserContacts> {
  List<dynamic> documentsList;
  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('users')
        .document(widget.uid)
        .get()
        .then((onData) {
      List<String> tags = List.from(onData.data['tags'] ?? []);
      // Location location = new Location();
      // LocationData _locationData;

      // location.getLocation().then((_locationData) {
      //   Geoflutterfire geo = Geoflutterfire();
      //   GeoFirePoint center = geo.point(
      //       latitude: _locationData.latitude,
      //       longitude: _locationData.longitude);

      //   var collectionReference = Firestore.instance.collection('users');

      //   double radius = 50;
      //   String field = 'geoPoint';

      //   geo
      //       .collection(collectionRef: collectionReference)
      //       .within(center: center, radius: radius, field: field)
      //       .toList().then((data) {
      //       // .then((data) {
      //         print("test");
      //     // print('tags: ' + tags.toString());

          Firestore.instance
              .collection('users')
              .where('tags', arrayContainsAny: tags)
              .getDocuments()
              .then((data) {
          List documents = List.from(data.documents);

          documents.sort((doc1, doc2) {
            final List itags1 = List.from(doc1['tags'])
                .where((tt) => tags.contains(tt))
                .toList();
            final List itags2 = List.from(doc2['tags'])
                .where((tt) => tags.contains(tt))
                .toList();
            return itags1.length.compareTo(itags2.length);
          });

          // documents.forEach((d) => print(d.documentID.toString() +
          //     ':  ' +
          //     d.data['name'].toString() +
          //     '  ' +
          //     d.data['tags'].toString()));
          setState(() {
            documentsList = documents;
          });
        // });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (documentsList != null) {
      return ListView.builder(
          itemCount: documentsList.length,
          itemBuilder: (BuildContext ctx, int index) {
            return ContactRecord(documentsList[index]);
          });
    } else {
      return Text("Загружаю данные");
    }
  }
}
