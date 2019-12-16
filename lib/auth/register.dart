import 'dart:convert';

// import 'package:earthquake_report/auth/register_success.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';
import '../config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  ProgressHUD _progressHUD;

  final _formKey = GlobalKey<FormState>();
  final String url = 'earthquake-report-api/request/auth/register.php';

  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerNik = new TextEditingController();
  TextEditingController _controllerNama = new TextEditingController();
  TextEditingController _controllerAlamat = new TextEditingController();
  TextEditingController _controllerNoHp = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();
  TextEditingController _controllerUlangPassword = new TextEditingController();

  register(String email, String nik, String nama, String alamat, String noHp,
      String password, String ulangPassword) async {
    var response = await http.post(host + url, body: {
      'email': email,
      'nik': nik,
      'nama': nama,
      'alamat': alamat,
      'noHp': noHp,
      'alamat': alamat,
      'password': password,
      // 'ulangPassword': ulangPassword,
    });
    var data = json.decode(response.body);
    _progressHUD.state.dismiss();
    if (data['status'] == 1) {
      Navigator.pushReplacementNamed(context, '/registerSuccess');
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
  void initState() {
    super.initState();

    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Mendaftarkan...',
      loading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Text(
                      'Daftar',
                      style: Theme.of(context).textTheme.body1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
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
                            controller: _controllerNik,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              labelText: 'NIK',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Mohon masukan NIK';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          TextFormField(
                            controller: _controllerNama,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Nama',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Mohon masukan Nama';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          TextFormField(
                            controller: _controllerAlamat,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Alamat',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Mohon masukan Alamat';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          TextFormField(
                            controller: _controllerNoHp,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'No. HP',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Mohon masukan No. HP';
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
                          TextFormField(
                            controller: _controllerUlangPassword,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Ulang Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Mohon masukan Ulang Password';
                              } else if (value != _controllerPassword.text) {
                                return 'Ulang Password tidak sama dengan Password!';
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
                                  'DAFTAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             RegisterSuccess()));
                                    _progressHUD.state.show();

                                    var connectivityResult =
                                        await (Connectivity()
                                            .checkConnectivity());
                                    if (connectivityResult ==
                                        ConnectivityResult.none) {
                                      _showToast(
                                          'Mohon periksa koneksi internet anda!');
                                    } else {
                                      register(
                                          _controllerEmail.text,
                                          _controllerNik.text,
                                          _controllerNama.text,
                                          _controllerAlamat.text,
                                          _controllerNoHp.text,
                                          _controllerPassword.text,
                                          _controllerUlangPassword.text);
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
                                    text: 'Sudah punya akun? ',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                    children: <TextSpan>[
                                      TextSpan(
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                          text: ' Masuk',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pop(context);
                                            })
                                    ]),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          _progressHUD
        ],
      ),
    );
  }
}
