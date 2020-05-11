import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class GeoControl extends StatefulWidget {
  final String uid;
  GeoControl(this.uid, {Key key}) : super(key: key);

  @override
  _GeoControlState createState() => _GeoControlState();
}

class _GeoControlState extends State<GeoControl> {
  bool _isUpdatingGeo = false;

  void _onUpdateGeoPosition() async {
    setState(() {
      _isUpdatingGeo = true;
    });
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    Geoflutterfire geo = Geoflutterfire();
    Firestore _firestore = Firestore.instance;
    GeoFirePoint myLocation = geo.point(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
    _firestore
        .collection('users')
        .document(widget.uid)
        .updateData({'geoPoint': myLocation.data}).then((_) {
      setState(() {
        _isUpdatingGeo = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUpdatingGeo)
      return FlatButton(
        onPressed: _onUpdateGeoPosition,
        child: Text('Опубликовать мою текущую геопозицию'),
      );
    else
      return Text("обновляю");
  }
}
