import 'dart:convert';

import 'package:earthquake_report/auth/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import 'package:progress_hud/progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ProgressHUD _progressHUD;
  SharedPreferences sharedPreferences;
  final _formKey = GlobalKey<FormState>();
  // final String host = 'http://192.168.1.7/';
  final String url = 'earthquake-report-api/request/auth/login.php';
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Verifikasi...',
      loading: false,
    );
  }

  login(String email, String password) async {
    var response = await http.post(host + url, body: {
      'email': email,
      'password': password,
    });
    var data = json.decode(response.body);
    _progressHUD.state.dismiss();
    if (data['status'] == 1) {
      int _id = int.parse(data['user']['id']);
      String _email = data['user']['email'];
      String _nik = data['user']['nik'];
      String _nama = data['user']['nama'];
      String _alamat = data['user']['alamat'];
      String _noHp = data['user']['no_hp'];

      setUser(_id, _email, _nik, _nama, _alamat, _noHp);
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      _showToast(data['mesage']);
    }
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
      msg: '$msg',
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                  size: 120,
                ),
                Text(
                  'Earthquake Report',
                  style: Theme.of(context).textTheme.body1,
                  // style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      TextFormField(
                        controller: _controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mohon masukan Email';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      TextFormField(
                        controller: _controllerPassword,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mohon masukan Password';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          RaisedButton(
                            padding: EdgeInsets.all(18),
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'MASUK',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                // final progress = ProgressHUD.of(context);
                                // progress.show();
                                _progressHUD.state.show();
                                // Future.delayed(Duration(seconds: 1), () {
                                //   progress.dismiss();
                                // });
                                // dismissProgressHUD();
                                var connectivityResult =
                                    await (Connectivity().checkConnectivity());
                                if (connectivityResult ==
                                    ConnectivityResult.none) {
                                  _showToast(
                                      'Mohon periksa koneksi internet anda!');
                                } else {
                                  login(_controllerEmail.text,
                                      _controllerPassword.text);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                text: 'Belum punya akun? ',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Daftar',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Register()));
                                        })
                                ]),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          _progressHUD
        ],
      ),
    );
  }

  setUser(int id, String email, String nik, String nama, String alamat,
      String noHp) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String _email = sharedPreferences.getString('email') ?? null;

    if (_email == null || email != _email) {
      sharedPreferences.setInt('id', id);
      sharedPreferences.setString('email', email);
      sharedPreferences.setString('nik', nik);
      sharedPreferences.setString('nama', nama);
      sharedPreferences.setString('alamat', alamat);
      sharedPreferences.setString('noHp', noHp);
      setState(() {});
    }
  }
}
