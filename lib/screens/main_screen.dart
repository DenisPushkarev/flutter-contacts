import 'package:contacts/screens/user_contacts.dart';
import 'package:contacts/screens/user_details.dart';
import 'package:contacts/screens/user_tags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String _uid;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) => setState(() {
          _uid = user.uid;
        }));
  }

  void _onItemTapped(int itemIndex) {
    setState(() {
      _currentIndex = itemIndex;
    });
  }

  Widget getView() {
    if (_uid == null) return CircularProgressIndicator();
    switch (_currentIndex) {
      case 0:
        return UserDetails(uid: _uid);
      case 1:
        return UserTags(uid: _uid);

      default:
        return UserContacts(uid: _uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            ["Профиль", "Мои интересы", "Рейтинг резонансов"][_currentIndex]),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onChanged: (item) {
              if (item == 'exit') FirebaseAuth.instance.signOut();
            },
            items: <DropdownMenuItem>[
              DropdownMenuItem(
                value: 'exit',
                child: Container(
                    child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text("Выход"),
                  ],
                )),
              ),
            ],
          ),
        ],
      ),
      body: Container(padding: EdgeInsets.all(16), child: getView()),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Профиль'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            title: Text('Теги'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_phone),
            title: Text('Контакты'),
          ),
        ],
        currentIndex: _currentIndex,
        // selectedItemColor: Theme.of(context).accentIconTheme,
        onTap: _onItemTapped,
      ),
    );
  }
}
