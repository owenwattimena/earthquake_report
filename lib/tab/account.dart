import 'package:earthquake_report/statefulWidget/account_edit_alert.dart';
import 'package:earthquake_report/statefulWidget/change_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import 'dart:convert';
import 'dart:async';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  SharedPreferences sharedPreferences;
  double imageCircularSize;
  String _email, _nik, _nama, _alamat, _noHp;

  final String url = 'earthquake-report-api/request/updateProfile.php';
  final String urlPass = 'earthquake-report-api/request/updatePassword.php';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    imageCircularSize = (40 / 100) * MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Account'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            return logoutDialog();
          },
        ),
      ]),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                // Stack(
                //   children: <Widget>[
                //     // Container(
                //     //   margin: EdgeInsets.only(bottom: 16),
                //     //   width: imageCircularSize,
                //     //   height: imageCircularSize,
                //     //   child: ClipRRect(
                //     //     borderRadius: BorderRadius.circular(300),
                //     //     // child: Image.network(
                //     //     // 'https://community.smartsheet.com/sites/default/files/default_user.jpg'),
                //     //   ),
                //     // ),
                //     // Container(
                //     //   child: IconButton(
                //     //     icon: Icon(
                //     //       Icons.add_a_photo,
                //     //       color: Theme.of(context).primaryColor,
                //     //     ),
                //     //     onPressed: () {},
                //     //   ),
                //     // )
                //   ],
                // ),
                accountInfo('Email', _email),
                accountInfo('NIK', _nik),
                accountInfo('Nama', _nama),
                accountInfo('Alamat', _alamat),
                accountInfo('No. HP', _noHp),
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

  logoutDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Text("Yakin Ingin Keluar?"),
            actions: <Widget>[
              RaisedButton(
                child: Text('Tidak'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Ya'),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                },
              )
            ],
          );
        });
  }

  Future<void> ubahPasswordDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ChangePasswordDialog(
            onChange: (password, passwordBaru) {
              updatePassword(password, passwordBaru);
            },
          );
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
                  showEditProfileDialog(
                      title, TextInputType.emailAddress, info);
                  // editProfileDialog(title, TextInputType.emailAddress);
                  break;
                case 'NIK':
                  showEditProfileDialog(title, TextInputType.number, info);
                  // editProfileDialog(title, TextInputType.number);
                  break;
                case 'Nama':
                  showEditProfileDialog(title, TextInputType.text, info);
                  // editProfileDialog('$title', TextInputType.text);
                  break;
                case 'Alamat':
                  showEditProfileDialog(title, TextInputType.text, info);
                  // editProfileDialog('$title', TextInputType.text);
                  break;
                case 'No. HP':
                  showEditProfileDialog(title, TextInputType.phone, info);
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

  updateProfile(String title, String field) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    switch (title) {
      case 'Email':
        this._email = field;
        sharedPreferences.setString('email', field);
        break;
      case 'NIK':
        this._nik = field;
        sharedPreferences.setString('nik', field);
        break;
      case 'Nama':
        this._nama = field;
        sharedPreferences.setString('nama', field);
        break;
      case 'Alamat':
        this._alamat = field;
        sharedPreferences.setString('alamat', field);
        break;
      case 'No. HP':
        this._noHp = field;
        sharedPreferences.setString('noHp', field);
        break;
      default:
    }
    var response = await http.post(host + url, body: {
      'id': id,
      'email': _email,
      'nik': _nik,
      'nama': _nama,
      'alamat': _alamat,
      'no_hp': _noHp,
    });
    var data = json.decode(response.body);
    Fluttertoast.showToast(
      msg: data['message'],
      toastLength: Toast.LENGTH_LONG,
    );
  }

  updatePassword(String password, String passwordBaru) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();

    var response = await http.post(host + urlPass, body: {
      'id': id,
      'password': password,
      'password_baru': passwordBaru,
    });
    var data = json.decode(response.body);
    if (data['status'] == 1) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } else {
      Fluttertoast.showToast(
        msg: data['message'],
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  showEditProfileDialog(
      String title, TextInputType textInputType, String info) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AccountEditAlert(
            title: title,
            textInputType: textInputType,
            value: info,
            callback: (field) {
              updateProfile(title, field);
              getUser();
            },
          );
        });
  }

  getUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    String email = sharedPreferences.getString('email') ?? null;
    String nik = sharedPreferences.getString('nik') ?? null;
    String nama = sharedPreferences.getString('nama') ?? null;
    String alamat = sharedPreferences.getString('alamat') ?? null;
    String noHp = sharedPreferences.getString('noHp') ?? null;

    setState(() {
      _email = email;
      _nik = nik;
      _nama = nama;
      _alamat = alamat;
      _noHp = noHp;
    });
  }
}
