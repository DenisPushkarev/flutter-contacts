import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/widgets/geo_control.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserDetails extends StatefulWidget {
  final String uid;
  UserDetails({Key key, this.uid}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final _formKey = GlobalKey<FormState>();
  bool _isChanged = false;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController companyCtrl = TextEditingController();
  TextEditingController positionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('users')
        .document(widget.uid)
        .get()
        .then((snapshot) {
      var document = snapshot.data;
      nameCtrl.text = document['name'] ?? '';
      phoneCtrl.text = document['phone'] ?? '';
      companyCtrl.text = document['company'] ?? '';
      positionCtrl.text = document['position'] ?? '';
    });
  }



  void _onEditingComplete() async {
    var isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      var user = await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection('users').document(user.uid).updateData({
        'name': nameCtrl.text,
        'company': companyCtrl.text,
        'position': positionCtrl.text,
        'phone': phoneCtrl.text,
      }).then((onValue) {
        setState(() {
          _isChanged = false;
        });
      });
    }
  }

  void _onChanged(_) {
    setState(() {
      _isChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                key: ValueKey('contact'),
                controller: nameCtrl,
                onChanged: _onChanged,
                validator: (value) {
                  String val = value.trim();
                  if (val == "") return "Введите ФИО";
                  return null;
                },
                onEditingComplete: _onEditingComplete,
                decoration: InputDecoration(
                  labelText: 'Фамилия Имя Отчество',
                ),
              ),
              TextFormField(
                key: ValueKey('phone'),
                onChanged: _onChanged,
                controller: phoneCtrl,
                // controller: phoneCtrl,
                validator: (value) {
                  String val = value.trim();
                  if (val == "") return "Введите номер телефона";
                  return null;
                },
                onEditingComplete: _onEditingComplete,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Телефон',
                ),
              ),
              TextFormField(
                key: ValueKey('company'),
                controller: companyCtrl,
                onChanged: _onChanged,
                validator: (value) {
                  String val = value.trim();
                  if (val == "") return "Укажите название компании";
                  return null;
                },
                // onSaved: (value) => this._company = value.trim(),
                onEditingComplete: _onEditingComplete,
                decoration: InputDecoration(
                  labelText: 'Компания',
                ),
              ),
              TextFormField(
                key: ValueKey('position'),
                controller: positionCtrl,
                onChanged: _onChanged,
                validator: (value) {
                  String val = value.trim();
                  if (val == "") return "Укажите должность";
                  return null;
                },
                onEditingComplete: _onEditingComplete,
                decoration: InputDecoration(
                  labelText: 'Должность',
                ),
              ),
              if (_isChanged)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FlatButton(
                      onPressed: _onEditingComplete,
                      child: Text('Сохранить'),
                    ),
                  ],
                ),
              GeoControl(widget.uid),
            ],
          ),
        ),
      ),
    );
  }
}
