import 'package:earthquake_report/statefulWidget/account_edit_alert.dart';
import 'package:earthquake_report/statefulWidget/change_password_dialog.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  double imageCircularSize;

  @override
  Widget build(BuildContext context) {
    imageCircularSize = (40 / 100) * MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      width: imageCircularSize,
                      height: imageCircularSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(300),
                        child: Image.network(
                            'https://community.smartsheet.com/sites/default/files/default_user.jpg'),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
                accountInfo('Email', 'WentoxWtt@gmail.com'),
                accountInfo('NIK', '1234567890'),
                accountInfo('Nama', 'Owen Wattimena'),
                accountInfo('Alamat', 'Jl, Ir. M. Putuhena - Wayame'),
                accountInfo('No. HP', '085244140715'),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Ubah Password',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        ubahPasswordDialog();
                      },
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> ubahPasswordDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ChangePasswordDialog();
        });
  }

  Widget accountInfo(String title, String info) {
    return Container(
      padding: EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                style: Theme.of(context).textTheme.title,
              ),
              Text('$info', style: Theme.of(context).textTheme.body1)
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              switch (title) {
                case 'Email':
                  showEditProfileDialog(title, TextInputType.emailAddress);
                  // editProfileDialog(title, TextInputType.emailAddress);
                  break;
                case 'NIK':
                  showEditProfileDialog(title, TextInputType.number);
                  // editProfileDialog(title, TextInputType.number);
                  break;
                case 'Nama':
                  showEditProfileDialog(title, TextInputType.text);
                  // editProfileDialog('$title', TextInputType.text);
                  break;
                case 'Alamat':
                  showEditProfileDialog(title, TextInputType.text);
                  // editProfileDialog('$title', TextInputType.text);
                  break;
                case 'No. HP':
                  showEditProfileDialog(title, TextInputType.phone);
                  // editProfileDialog('$title', TextInputType.phone);
                  break;
                default:
              }
            },
          )
        ],
      ),
    );
  }

  showEditProfileDialog(String title, TextInputType textInputType) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AccountEditAlert(
            title: title,
            textInputType: textInputType,
          );
        });
  }
}
